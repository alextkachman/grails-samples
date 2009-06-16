<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <g:javascript src="common/application.js"/>
    <g:javascript src="common/tracking.js"/>
    
    <link rel="stylesheet" href="css/new/master.css" type="text/css" media="screen" title="Master screen stylesheet" charset="utf-8" />
    <link rel="stylesheet" href="css/new/homepage.css" type="text/css" media="screen" title="Master screen stylesheet" charset="utf-8" />
    
	<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
	<meta name="robots" content="NOODP">	
	<meta name="Description" content="Grails is a high-productivity web framework based on the Groovy language that embraces the coding by convention paradigm, but is designed specifically for the Java platform.">	
	
	<title>Grails - The search is over.</title>

	<g:layoutHead />

</head>
<body>
    
<div align="center">
    <a href="http://www.springsource.com/"><div id="springSourceBar"></div></a>
    <div class="mainMenuBarWrapper">
        <ul id="mainMenuBar">
            <li><a href="http://www.springsource.com/products">Products</a></li>
            <li><a href="http://www.springsource.com/services">Support and Services</a></li>
            <li><a href="http://www.springsource.com/training">Training</a></li>
            <li><g:link controller="content" id="Download">Downloads</g:link></li>
            <li><g:link controller="content" id="Documentation">Documentation</g:link></li>
            <li><g:link controller="content" id="Community">Community</g:link></li>
        </ul><!-- mainMenuBar -->
    </div><!-- mainMenuBarWrapper -->
</div><!-- center -->

<div id="graphicHeader"></div>

<div id="barDecoration"></div>

<div id="contentWrapper">
    <div id="contentCenter" align="center">
        <div id="contentArea">
            
            <div id="grailsAttributes">
                <div class="left">
        	        <h2>Rapid</h2>
                    <p>Have your next Web 2.0 project done in weeks instead of months. Grails delivers a new age of Java web application productivity.</p>		
                </div><!-- left column -->
                <div class="center">
        			<h2>Dynamic</h2>
                    <p>Get instant feedback, see instant results. Grails is the premier dynamic language web framework for the JVM.</p>
                </div><!-- center column -->
                <div class="right">
        			<h2>Robust</h2>
                    <p>Powered by <a href="http://springframework.org">Spring</a>, Grails out performs the competition. Dynamic, agile web development without compromises.</p>
                </div><!-- right column -->
            </div><!-- grailsAttributes -->
            
            <div class="eventDownloadWrapper">
                <div id="events">
                    <h3>Events</h3>
                    <ul>
                        <li>
                            <h4>June 17-19, 2009</h4>
                            Groovy and Grails - Belgium, Brussels
                        </li>
                        <li>
                            <h4>June 17-19, 2009</h4>
                            Groovy and Grails - Belgium, Brussels
                        </li>
                        <li>
                            <h4>June 17-19, 2009</h4>
                            Groovy and Grails - Belgium, Brussels
                        </li>
                        <li>
                            <h4>June 17-19, 2009</h4>
                            Groovy and Grails - Belgium, Brussels
                        </li>
                        <li>
                            <h4>June 17-19, 2009</h4>
                            Groovy and Grails - Belgium, Brussels
                        </li>
                        <li>
                            <h4>June 17-19, 2009</h4>
                            Groovy and Grails - Belgium, Brussels
                        </li>
                    </ul>
                </div><!-- events -->
                
                <div id="globeGraphic"></div>
            
                <div id="downloadBox">
                    <div class="downloadPluginWrapper">
                        <div id="download">
                            <h3>Download Grails v1.1.1</h3>
                            A short description of what I am downloading and some fluffy text highlighting grails key features.  Should not be longer than this.
                            <h4>Learn More</h4>
                        </div><!-- download -->
                        <div id="plugins">
                            <h3>Grails Plugins</h3>
                            <ul>
                                <g:each var="plugin" in="${newestPlugins}">
                                    <li><g:link controller="plugin" action="show" params="[name:plugin.name]">${plugin.title}</g:link></li>
                                </g:each>
                            </ul>
                            <h4>View All</h4>
                        </div><!-- plugins -->
                    </div><!-- downloadPluginWrapper -->
                </div><!-- downloadBox -->
            </div><!-- eventDownloadWrapper -->
            
            <div class="newsScreencastWrapper">
                <div id="latestNews">
                    <h2>Latest News</h2>
                    <div id="newsBox">
                        <ul>
                            <g:each var="newsItem" in="${newsItems}">
                                <li>
                                    <g:link controller="blog"  action="showEntry" params="[author:newsItem.author, title: newsItem.title]">
                                        <div class="detail">
                                            <h4>${newsItem.title}</h4>
                                            <div class="author">by ${newsItem.author} | ${newsItem.tags.join(', ')}</div>
                                            <div class="comments">${newsItem.comments.size()} comments</div>
                                        </div>
                                        <div class="calendar">
                                            <div class="month">${newsItem.month}</div>
                                            <div class="day">${newsItem.day}</div>
                                        </div>
                                    </g:link>
                                </li>
                            </g:each>
                        </ul>
                        <div class="actions">
                            <g:link controller="blog" action="createEntry">Add news</g:link> | <g:link controller="blog" action="feed" params="[format:'rss']">Subscribe</g:link>
                        </div><!-- actions -->
                    </div><!-- newsBox -->
                </div><!-- latestNews -->
            
                <div id="screencasts">
                    <h2>Recent Screencasts</h2>
                    <div class="castBox">
                        <div class="castScreen">
                            <g:link controller="screencast" action="show" id="${latestScreencastId}">
                                <img src="/images/new/play_icon.png"/>
                            </g:link>
                        </div><!-- castScreen -->
                        <h4><g:link controller="screencast" action="list">View All</g:link></h4>
                    </div><!-- castBox -->
                </div><!-- screencasts -->
            </div><!-- newsScreencastWrapper -->
            
        </div>
    </div>
    
    <div id="grailsOptionsWrapper">
        <div id="grailsOptionsGraphicsWrapper">
            <div id="mountainLeft"></div>
            <div id="knight"></div>
            <div id="mountainRight"></div>
            <div id="castle"></div>
        </div><!-- grailsOptionsGraphicsWrapper-->
        <div id="grailsOptionsBackgroundStretch">
            <div align="center">
                <div id="grailsOptions">
                    <div class="left">
            	        <h3>Training</h3>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ut risus in eros consectetur feugiat. Fusce elementum convallis porttitor. Nulla facilisi. Morbi at erat felis. Aenean ante nisl, pulvinar nec varius ut, egestas sit amet dolor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae fermentum odio. Quisque quis lacus id dolor rhoncus placerat ut eu odio. Duis nec ipsum est. Proin congue faucibus risus, at blandit libero rutrum at. Vivamus ac laoreet lectus. Nam et nisi est. Aliquam hendrerit tristique lectus sit amet fringilla. Aenean pretium lacus vitae massa bibendum feugiat. Suspendisse a mi mauris. Etiam fermentum lacus nec lectus luctus vitae porta nisl ultrices.</p>		
                    </div><!-- left column -->
                    <div class="center">
            			<h3>Support</h3>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ut risus in eros consectetur feugiat. Fusce elementum convallis porttitor. Nulla facilisi. Morbi at erat felis. Aenean ante nisl, pulvinar nec varius ut, egestas sit amet dolor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae fermentum odio. Quisque quis lacus id dolor rhoncus placerat ut eu odio. Duis nec ipsum est. Proin congue faucibus risus, at blandit libero rutrum at. Vivamus ac laoreet lectus. Nam et nisi est. Aliquam hendrerit tristique lectus sit amet fringilla. Aenean pretium lacus vitae massa bibendum feugiat. Suspendisse a mi mauris. Etiam fermentum lacus nec lectus luctus vitae porta nisl ultrices.</p>
                    </div><!-- center column -->
                    <div class="right">
            			<h3>Services</h3>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ut risus in eros consectetur feugiat. Fusce elementum convallis porttitor. Nulla facilisi. Morbi at erat felis. Aenean ante nisl, pulvinar nec varius ut, egestas sit amet dolor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae fermentum odio. Quisque quis lacus id dolor rhoncus placerat ut eu odio. Duis nec ipsum est. Proin congue faucibus risus, at blandit libero rutrum at. Vivamus ac laoreet lectus. Nam et nisi est. Aliquam hendrerit tristique lectus sit amet fringilla. Aenean pretium lacus vitae massa bibendum feugiat. Suspendisse a mi mauris. Etiam fermentum lacus nec lectus luctus vitae porta nisl ultrices.</p>
                    </div><!-- right column -->
                </div><!-- grailsOptions -->
            </div><!-- center -->
        </div><!-- grailsOptionsBackgroundStretch -->
    </div><!-- grailsOptionsWrapper -->
</div><!-- contentWrapper -->

<div id="footer">
    <div align="center">
        <div class="innerFooter">
            <a href="http://twitter.com/grails"><div class="twitter"></div></a>
            <a href="http://www.springsource.com"><div class="springSource"></div></a>
            <p>&copy; Copyright 2009 SpringSource.<br/>All Rights Reserved.</p>
        </div><!-- innerFooter -->
    </div><!-- center -->
</div><!-- footer -->

</body>
</html>