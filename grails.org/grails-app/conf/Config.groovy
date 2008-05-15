// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

wiki.supported.upload.types = ['image/png','image/jpg','image/gif']


grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text-plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]
// The default codec used to encode data with ${}
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
grails.converters.encoding="UTF-8"

// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true

// set per-environment serverURL stem for creating absolute links
environments {
    production {
        grails.serverURL = "http://www.yourexcitingapplication.com"
    }
}

// log4j configuration
log4j {
    appender.stdout = "org.apache.log4j.ConsoleAppender"
    appender.'stdout.layout'="org.apache.log4j.PatternLayout"
    appender.'stdout.layout.ConversionPattern'='[%r] %c{2} %m%n'
    appender.file = "org.apache.log4j.FileAppender"
    appender.'file.layout'="org.apache.log4j.PatternLayout"
    appender.'file.layout.ConversionPattern'='[%r] %c{2} %m%n'
    appender.'file.File'="stacktrace.log"
    rootLogger="info,stdout"
    logger {
        grails="info"
        StackTrace="info,file"
        org {
            codehaus.groovy.grails.web.servlet="info"  //  controllers
            codehaus.groovy.grails.web.pages="info" //  GSP
            codehaus.groovy.grails.web.sitemesh="info" //  layouts
            codehaus.groovy.grails."web.mapping.filter"="info" // URL mapping
            codehaus.groovy.grails."web.mapping"="info" // URL mapping
            codehaus.groovy.grails.commons="info" // core / classloading
            codehaus.groovy.grails.plugins="info" // plugins
            codehaus.groovy.grails.orm.hibernate="info" // hibernate integration
            springframework="off"
        }
		org.hibernate.SQL="off"
		org.hibernate.type="off"		
    }
    additivity.StackTrace=false
}

