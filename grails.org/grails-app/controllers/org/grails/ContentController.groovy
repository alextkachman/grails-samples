package org.grails


import javax.servlet.ServletContext
import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.grails.wiki.WikiPage
import org.grails.content.Version
import org.grails.content.notifications.ContentAlertStack
import org.grails.wiki.BaseWikiController
import org.grails.plugin.Plugin
import org.grails.content.Content

class ContentController extends BaseWikiController {
    
    static accessControl = {
        // Alternatively, several actions can be specified.
        role(name: 'Editor', only:['createNews','editWikiPage','markupWikiPage', 'saveWikiPage', 'createWikiPage', 'postComment'] )
        role(name: 'Administrator', action: 'rollbackWikiVersion' )
    }

    def cacheService
    def wikiPageService

    ContentAlertStack contentToMessage

   def search = {
		if(params.q) {
			def searchResult = WikiPage.search(params.q, offset: params.offset, escape:true)
            def filtered = searchResult.results.unique { it.title }.collect {
                // WikiPages that are actually components of a Plugin should be treated as a Plugin
                if (it.title.matches(/(${Plugin.WIKIS.join('|')})-[0-9]*/)) {
                    // we're returning the actual parent Plugin object instead of the WikiPage, but we'll make the body
                    // of the WikiPage available on this Plugin object so the view can render it as if it were a real
                    // WikiPage by calling on the 'body' attributed
                    def plugin = Plugin.read(it.title.split('-')[1])
                    plugin.metaClass.getBody = { -> it.body }
                    return plugin
                }
                it
            }
			searchResult.results = filtered
			searchResult.total = filtered.size()
			flash.message = "Found $searchResult.total results!"
			flash.next()
			render(view:"/searchable/index", model:[searchResult:searchResult])
		}
		else {
			render(view:"homePage")
		}
   }

   def latest = {

         def engine = createWikiEngine()

         def feedOutput = {

            def top5 = WikiPage.listOrderByLastUpdated(order:'desc', max:5)
            title = "Grails.org Wiki Updates"
            link = "http://grails.org/wiki/latest?format=${request.format}"
            description = "Latest wiki updates Grails framework community"

            for(item in top5) {
                entry(item.title) {
                    link = "http://grails.org/${item.title.encodeAsURL()}"
                    publishedDate = item.dateCreated
                    engine.render(item.body, context)
                }
            }
         }

        withFormat {
            html {
                redirect(uri:"")
            }
            rss {
                render(feedType:"rss",feedOutput)
            }
            atom {
                render(feedType:"atom", feedOutput)
            }
        }
    }

    def previewWikiPage = {
        def page = WikiPage.findByTitle(params.id?.decodeURL())
        if(page) {
            def engine = createWikiEngine()
            page.discard()
            page.properties = params

            render( engine.render(page.body, context) )
        }
    }

    def index = {
        def pageName = params.id

        if(pageName) {
            if(pageName == 'Home') {
                render(view:"homePage")
            }
            // treat plugin pages differently
            else if (pageName.matches(/(${Plugin.WIKIS.join('|')})-[0-9]*/)) {
                // name will look like this: description-34
                // last half is plugin id
                def plugin = Plugin.get(pageName.split('-')[1])
                if (request.xhr) {
                    // update the wikiTab, not the whole contentPane
                    def wikiPage = wikiPageService.getCachedOrReal(pageName)
                    return render(template:"wikiShow", model:[content:wikiPage, update:"${pageName.split('-')[0]}Tab"])
                }
                redirect(controller:'plugin', action:'show', params:[name:plugin.name])
            }
            else {
                def wikiPage = wikiPageService.getCachedOrReal(pageName)
                if(wikiPage) {
                    if(request.xhr) {
                        render(template:"wikiShow", model:[content:wikiPage, update:params.update])
                    } else {
                        render(view:"contentPage", model:[content:wikiPage, comments: wikiPage.comments.sort { it.dateCreated }])
                    }
                }
                else {
                    response.sendError 404
                }
            }
		} else {
			render(view:"homePage")
		}
	}

    def postComment = {
        def content = Content.get(params.id)
//        def c = new Comment(body:params.comment, user: request.user)
//        content.addToComments(c)
        content.addComment(request.user, params.comment)
        content.save(flush:true)
        render(template:'/comments/comment', var:'comment', bean:content.comments[-1])
    }



    def showWikiVersion = {
        def page = WikiPage.findByTitle(params.id.decodeURL())
        def version
        if(page) {
            version = Version.findByCurrentAndNumber(page, params.number.toLong())
        }

        if(version) {
            render(view:"showVersion", model:[content:version, update:params.update])                    
        }
        else {
            render(view:"contentPage", model:[content:page])
        }

    }

    def markupWikiPage = {
        def page = WikiPage.findByTitle(params.id.decodeURL())

        if(page) {
            render(template:"wikiFields", model:[wikiPage:page])
        }
    }

	def infoWikiPage = {
        def page = WikiPage.findByTitle(params.id.decodeURL())

        if(page) {

            def pageVersions = Version.findAllByCurrent(page)
            pageVersions = pageVersions.sort { it.number }                        

            render(template:'wikiInfo',model:[wikiPage:page, versions:pageVersions, update:params.update])
        }

    }

	def editWikiPage = {
        if(!params.id) {
            render(template:"/shared/remoteError", [code:"page.id.missing"])
        }
        else {
            def page = WikiPage.findByTitle(params.id.decodeURL())

            render(template:"wikiEdit",model:[wikiPage:page, update: params.update, editFormName: params.editFormName])
        }
    }

    def createWikiPage = {
        if (params.xhr) {
            return render(template:'wikiCreate', var:'pageName', bean:params.id?.decodeURL())
        }
        [pageName:params.id?.decodeURL()]
    }

    def saveWikiPage = {
      if(request.method == 'POST') {
          if(!params.id) {
                render(template:"/shared/remoteError", model:[code:"page.id.missing"])
            }
            else {
                WikiPage page = WikiPage.findByTitle(params.id.decodeURL())
                if(!page) {
                    page = new WikiPage(params)
                    page.save()
                    if(page.hasErrors()) {
                        render(view:"createWikiPage", model:[pageName:params.id, wikiPage:page])
                    }
                    else {
                        Thread.start {
                            contentToMessage?.pushOnStack page
                        }
                        Version v = page.createVersion()
                        v.author = request.user
                        assert v.save()

                        redirect(uri:"/${page.title.encodeAsURL()}")
                    }
                }
                else {
                    if(page.version != params.version.toLong()) {
                        render(template:"wikiEdit",model:[wikiPage:page, error:"page.optimistic.locking.failure"])
                    }
                    else {

                        page.body = params.body
                        page.lock()
                        page.version = page.version+1
                        page.save(flush:true)
                        if(page.hasErrors()) {
                            render(template:"wikiEdit",model:[wikiPage:page])
                        }
                        else {
                            Thread.start {
                                contentToMessage?.pushOnStack page
                            }

                            Version v = page.createVersion()
                            v.author = request.user                            
							assert v.save()

                            evictFromCache(params.id)
                            render(template:"wikiShow", model:[content:page, message:"wiki.page.updated", update: params.update])
                        }
                    }
                }
            }
          
      }
      else {
          response.sendError(403)
      }
    }

    private evictFromCache(id) {
        id = id.decodeURL()
        cacheService.removeWikiText(id)
        cacheService.removeContent(id)

    }

    def rollbackWikiVersion = {
        if(request.method == 'POST') {
            def page = WikiPage.findByTitle(params.id.decodeURL())
            if(page) {
                def version = Version.findByCurrentAndNumber(page, params.number.toLong())
                if(!version) {
                   render(template:"versionList", model:[wikiPage: page,versions:Version.findAllByCurrent(page), message:"wiki.version.not.found"])
                }
                else {
                    if(page.body == version.body) {
                        render(template:"versionList", model:[wikiPage: page,versions:Version.findAllByCurrent(page), message:"Contents are identical, no need for rollback."])     
                    }
                    else {

                        page.lock()
                        page.version = page.version+1
                        page.body = version.body
                        assert page.save(flush:true)
                        Version v = page.createVersion()
                        v.author = request.user                        
                        assert v.save()
                        evictFromCache params.id

                        render(template:"versionList", model:[wikiPage: page, versions:Version.findAllByCurrent(page).sort { it.number }, message:"Page rolled back, a new version ${v.number} was created"])
                    }
                }
            }
            else {
                render(template:"versionList", model:[wikiPage: page,versions:Version.findAllByCurrent(page), message:"wiki.page.not.found"])
            }
        }
        else {
            response.sendError(403)
        }
    }

    def diffWikiVersion = {

        def page = WikiPage.findByTitle(params.id.decodeURL())
        if(page) {
            def leftVersion = params.number.toLong()
            def left = Version.findByCurrentAndNumber(page, leftVersion)
            def rightVersion = params.diff.toLong()
            def right = Version.findByCurrentAndNumber(page, rightVersion)
            if(left && right) {
                return [message: "Showing difference between version ${leftVersion} and ${rightVersion}", text1:right.body.encodeAsHTML(), text2: left.body.encodeAsHTML()]
            }
            else {
                return [message: "Version not found in diff"]
            }

        }
        else {
            return [message: "Page not found to diff" ]
        }
    }

    def previousWikiVersion = {
        def page = WikiPage.findByTitle(params.id.decodeURL())
        if(page) {
            def leftVersion = params.number.toLong()
            def left = Version.findByCurrentAndNumber(page, leftVersion)

            List allVersions = Version.findAllByCurrent(page).sort { it.number }
            def right = allVersions[allVersions.indexOf(left)-1]
            def rightVersion = right.number

            if(left && right) {
                render(view:"diffView",model:[content:page,message: "Showing difference between version ${leftVersion} and ${rightVersion}", text1:right.body.encodeAsHTML(), text2: left.body.encodeAsHTML()])
            }
            else {
                render(view:"diffView",model:[message: "Version not found in diff"])
            }

        }
        else {
            render(view:"diffView",model: [message: "Page not found to diff" ] )
        }

    }

    def uploadImage = {
        def config = ConfigurationHolder.getConfig()
        if(request.method == 'POST') {
            MultipartFile file = request.getFile('file')
            ServletContext context = getServletContext()
            def path = context.getRealPath("/images${ params.id ? '/' + params.id.encodeAsURL() : '' }" )
            log.info "Uploading image, file: ${file.originalFilename} (${file.contentType}) to be saved at $path"
            if(config.wiki.supported.upload.types?.contains(file.contentType)) {
                def newFilename = file.originalFilename.replaceAll(/\s+/, '_')
                File targetFile = new File("$path/${newFilename}")
                if(!targetFile.parentFile.exists()) targetFile.parentFile.mkdirs()
                log.info "Target file: ${targetFile.absolutePath}"
                try {
                    log.info "Attempting file transfer..."
                    file.transferTo(targetFile)
                    log.info "Success! Rendering message back to view"
                    render(view:"/common/iframeMessage", model:[pageId:"upload",
                            frameSrc: g.createLink(controller:'content', action:'uploadImage', id:params.id),
                            message: "Upload complete. Use the syntax !${params.id ? params.id.encodeAsURL() + '/' : ''}${newFilename}! to refer to your file"])
                } catch (Exception e) {
                    log.error(e.message, e)
                    render(view:"/common/uploadDialog",model:[category:params.id,message:"Error uploading file!"])
                }
            }
            else {
                log.info "Bad file type, rendering error message to view"
                render(view:"/common/uploadDialog",model:[category:params.id,message:"File type not in list of supported types: ${config.wiki.supported.upload.types?.join(',')}"])
            }
        }
        else {
            render(view:"/common/uploadDialog", model:[category:params.id])
        }
    }
}
