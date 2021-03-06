<%@ page import="org.grails.plugin.Plugin" %>
<g:setProvider library="yui"/>

<html>
<head>
    <meta name="layout" content="pluginDetails">
</head>
<body>
	<div id="pluginDetailsBox" align="center">
		
		<div id="pluginDetailsContainer">
			
			<gui:dialog id='loginDialog' title="Login required" modal="true">
			    <div id='loginFormDiv'></div>
			</gui:dialog>

			<div id="downloadBox">
				<a href="${plugin.downloadUrl}"><r:img uri="/images/new/plugins/Buttons/downloadBox_btn.png" alt="Download" border="0"/></a>
			</div>

			<h1 id="pluginBoxTitle">${plugin?.title}</h1>

			<div class="ratingBox">
			    <shiro:isLoggedIn>
					<rateable:ratings bean="${plugin}"/>						
			    </shiro:isLoggedIn>
			    <shiro:isNotLoggedIn>
					<div id="ratingDisplay">
						<rateable:ratings bean="${plugin}" active="false" href="${createLink(controller:'user', action:'login', params:[originalURI:request.forwardURI])}"/>																							
					</div>
			    </shiro:isNotLoggedIn>
			</div>


		    <div class="pluginDetail">
		        <table>
		            <tr>
		                <th>Author(s):</th>
		                <td>${plugin.author}</td>
		            </tr>
		            <tr>
		                <th>Current Release:</th>
		                <td>${plugin.currentRelease}</td>
		            </tr>
		            <tr>
		                <th>Grails Version:</th>
		                <td>${plugin.grailsVersion ?: '?'}</td>
		            </tr>
		            <tr>
		                <th>Tags</th>
		                <td class='tags'>
		                    <span id='pluginTags'>
		                        <g:render template='tags' var='plugin' bean="${plugin}"/>
		                    </span>
		                    <span id='addTagTrigger'><r:img uri="/images/famfamfam/add.png"/></span>
		                </td>
		            </tr>
		        </table>
		    </div>
		    <div class="links">
		        <a href="${plugin.fisheye}">
					<div class="fisheye">
						<r:img uri="/images/new/plugins/icons/fisheye.png" border="0" /> 
						Fisheye
					</div>
				</a>
		        <a href="${plugin.documentationUrl}">
					<div class="docs">
						<r:img uri="/images/new/plugins/icons/doc.png" border="0" /> 
						Docs
					</div>

		        </a>
		        <g:link controller="plugin" action="editPlugin" id="${plugin.id}">
					<div class="edit">
						<r:img uri="/images/new/plugins/icons/16x16_icons/edit.png" border="0" /> 
						Edit Plugin
					</div>
				</g:link>
		    </div>
			
		</div>
		
	</div>

	
</div>



    %{--
        Logged in users will be able to add tags
    --}%
    <shiro:isLoggedIn>
        <gui:dialog id='addTagDialog'
            title='Add Tags'
            form='true' url="${createLink(controller:'plugin', action:'addTag', params:[id:plugin.id])}"
            triggers="[show:[id:'addTagTrigger',on:'click']]"
            update='pluginTags'
        >
            <gui:autoComplete id='newTag'
                controller='tag' action='autoCompleteNames'
                resultName='tagResults'
                labelField='name'
                minQueryLength='1'
                queryDelay='1'
            />
        </gui:dialog>

        <script>
            YAHOO.util.Event.onDOMReady(function() {
                // on show, put the dialog in the right place
                GRAILSUI.addTagDialog.subscribe('show', function() {
                    var pos = YAHOO.util.Dom.getXY('addTagTrigger');
                    this.cfg.setProperty('x',pos[0]+20);
                    this.cfg.setProperty('y',pos[1]+20);
                });
                // on hide, clear out the text within it
                GRAILSUI.addTagDialog.subscribe('hide', function() {
                    document.getElementById('newTag').value = ''
                });
            });
        </script>
    </shiro:isLoggedIn>
    %{-- Unauthenticated users get defered to the login screen --}%
    <shiro:isNotLoggedIn>
        <script>
            YAHOO.util.Event.onDOMReady(function() {
                // on show, put the dialog in the right place
                YAHOO.util.Event.on('addTagTrigger', 'click', function() {
                    window.location = "${createLink(controller:'user', action:'login', params:[originalURI:request.forwardURI])}";
                });
                // also hang up rating click if not logged in, redirect to login page with originalURI of this page
                // for redirect
                YAHOO.util.Event.on('ratingdiv', 'click', function(e) {
                    YAHOO.util.Event.stopEvent(e);
                    window.location = "${createLink(controller:'user', action:'login', params:[originalURI:request.forwardURI])}";
                });
            });
        </script>
    </shiro:isNotLoggedIn>

	<div id="pluginContent" align="center">
	    <cache:text key="pluginTabs_${plugin.id}">
	        <gui:tabView>
	            <g:each var="wiki" in="${Plugin.WIKIS}">
	                <gui:tab id="${wiki}Tab" label="${wiki[0].toUpperCase() + wiki[1..-1]}" active="${wiki == 'description'}">
	                    <g:render template="../content/viewActions" model="${[content: plugin[wiki], update: wiki + 'Tab', editFormName: wiki + 'EditForm']}"/>
	                    <div class='${wiki}, wikiPage'><wiki:text page="${plugin[wiki]?.title}" /></div>
	                </gui:tab>
	            </g:each>
	        </gui:tabView>
		</cache:text>		
	</div>
</body>
</html>
