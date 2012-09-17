<%@page contentType="text/html" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<meta name="Copyright" content="Copyright (c) CT corporate technologies s.r.o.">
	<title>2charts.com Home</title> 
	<link rel="stylesheet" href="css/jquery-ui.css" />			<!-- leading slash for testing -->
	<link rel="stylesheet" media="screen and (min-width: 640px)" href="css/home.css" />
	<link rel="stylesheet" media="screen and (min-width: 960px)" href="css/home-wide.css" title="widescreen" />
	<link rel="stylesheet" media="screen and (min-width: 1280px)" href="css/home-wider.css" title="widescreen" />
	<link rel="shortcut icon" href="icon.png" />
	<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>-->
	<script src="lib/jquery-1.8.1.js"></script>
	<!-- IF MOBILE -->
		<!--<script src="lib/jquery.mobile-1.1.1.js"></script>-->
	<!-- ELSE -->
		<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"></script>
		<script src="lib/jquery.cookie.js"></script>
		<script src="lib/jqm-on-nonmobile.js"></script>
	<!-- ENDIF -->
	<link rel="stylesheet" href="lib/galleria/themes/override-css/override.css" />
	<script src="lib/galleria/galleria-1.2.8.js"></script>
	<script src="lib/galleria/plugins/flickr/galleria.flickr.min.js"></script>
	<script>
	var selectedTab = <%= request.getParameter("selectedTab") != null ? request.getParameter("selectedTab") : "null" %>;
	//WWW = "//localhost:8888/index";
	//PROXY = "//localhost:8888";
	WWW = "http://www.2charts.com/";
	PROXY = "http://proxy.2charts.com";
	INJECTSIGNIN = PROXY + "/injectAuthIfNeeded?url=";
	SEARCH = "www.bing.com/search";
		
	(function($,undefined) {
		$(document).ready(function(){
			if (window.matchMedia !== undefined) {
				var mq = window.matchMedia("(min-width: 640px)");
				mq.addListener(onWidthChange);
				onWidthChange(mq);
			}
			function onWidthChange(mq) {
				var msg = (mq.matches ? "more" : "less") + " than 640 pixels";
				//$(".ui-footer p").html(msg);
			}
			$(window)
				.resize(function(e) { 
					$("body").css({
						"min-height":$(window).height()-17
					});
				})
				.resize()
			;
			
			Galleria.loadTheme('lib/galleria/themes/azur/galleria.azur.min.js');
			Galleria.configure({
				autoplay: 7000
				,flickr: 'set:72157630985524022'
				,flickrOptions: {
					sort: 'date-posted-asc'
				}
				,fullscreenCrop:"height"
				,responsive:true
				,transition:"fadeslide"
			});
			//Galleria.run('#galleria', {
			//	flickr: 'set:72157630985524022'
			//	,flickrOptions: {
			//		sort: 'date-posted-asc'
			//	}
			//	,fullscreenCrop:"height"
			//	,responsive:true
			//	,transition:"fadeslide"
			//});

			isAuthPage = function(data) {
				return data.match(/Not logged in/);
			};
			var tabOptions = {
				cookie: {expires:1, secure:false}
				,cache:false
				//,create: function(event,ui) {
				//	var sel = $(this).tabs("option","selected");
				//	if (sel == 0) { 
				//		Galleria.run('#galleria')
				//		.get(0).play(7000);
				//	}
				//}
				,select: function(event,ui) {
					if (ui.index == 0) {
						Galleria.run('#galleria')
						.get(0).play(7000);
					}
					else { 
						if (Galleria.get().length) { Galleria.get(0).pause(); }
					}
				}
				,load: function(event,ui) {
					$o = $(".ui-tabs-panel");
					initUiClasses($o);
				}
				,ajaxOptions: {
					xhrFields: {
						withCredentials: true
					}
					,beforeSend: function( xhr, settings ) {
						settings.crossDomain = true;
						settings.url = settings.url.replace("PROXY",PROXY + "/");
						settings.url += "?" + "parentURI=" + encodeURIComponent(WWW);
					}
					,error: function( xhr, status, index, anchor ) {
						$( anchor.hash ).html("Error retrieving external content." );
						//window.location.href= INJECTSIGNIN + encodeURIComponent(window.location.href);
						return false;
					}
					,success: function(data, textStatus, jqXHR) {
						if (isAuthPage(data)) {
							window.location.href= INJECTSIGNIN + encodeURIComponent(window.location.href);
							return false;
						}
						return true;
					}
				}
			};
			if (selectedTab !== null) {
		        tabOptions = $.extend( {
					"selected":selectedTab
				}, tabOptions);
			};
			$(".ui-page:first .ui-listview:has(a)")
					.find("a").each( function(i) {
						var href = $(this).attr("href");
						$target = $(String(href));
						$target.insertAfter($(this).closest(".ui-listview"));
					})
					.end()
				.parent()
				.tabs(tabOptions)
				.each(function(i0) {
					if ($(this).tabs("option","selected") == 0) { 
						Galleria.run('#galleria')
						//.get(0).play(7000);
					}

				})
			;
			
			var searchHtml = '<form class="ui-search-appliance-form" action="' + PROXY + '/' + SEARCH + '">';
			searchHtml += '<div class="ui-search-appliance-buttonset"><button type="submit" class="ui-search-appliance-submit" tabindex="0"> Start 2charts.com session</button></div>';
			searchHtml += '<div class="ui-search-appliance-input"><input type="text" placeholder="Type your internet search terms here" class="ui-corner-all" name="q" aria-label="Start 2charts.com session"/></div>';
			searchHtml += '</form>';
			var $search = $(searchHtml);
			$(".ui-search-appliance").append($search);
			$(".ui-search-appliance-submit")
				.button({
            		icons: { primary: "ui-icon-search" }
            	})
            ;
		});
	})(jQuery);
	</script>
</head> 

	
<body> 

<div data-role="page" id="one">
	<div data-role="header">
		<div data-role="leftdiv">
			<!--<div style="margin-left:1em"><img src="res/20120913_logo_from_svg.png"/></div>-->
			<div style="margin-left:1em">
				<svg width="360" height="80" xmlns="http://www.w3.org/2000/svg">
				 <!-- Created with SVG-edit - http://svg-edit.googlecode.com/ -->
				 <defs>
				  <linearGradient id="svg_10" x1="0" y1="0.24" x2="1" y2="0.76">
				   <stop offset="0" stop-color="#c4f1ff"/>
				   <stop offset="1" stop-color="#45a5b4"/>
				  </linearGradient>
				 </defs>
				 <g display="inline">
				  <title>Layer 1</title>
				  <rect id="svg_1" height="64" width="64" y="9" x="0" stroke-width="0" stroke="#000000" fill="#44505f"/>
				 </g>
				 <g>
				  <title>Layer 2</title>
				  <rect id="svg_2" height="37" width="19" y="35" x="9" stroke-width="0" stroke="#000000" fill="url(#svg_10)"/>
				  <rect id="svg_3" height="50" width="19" y="22" x="36" stroke-width="0" stroke="#000000" fill="url(#svg_10)"/>
				  <text font-weight="bold" xml:space="preserve" text-anchor="middle" font-family="Sans-serif" font-size="69" id="svg_4" y="71.5" x="164" stroke-width="0" stroke="#000000" fill="#44505f">2char</text>
				  <text font-weight="bold" xml:space="preserve" text-anchor="middle" font-family="Sans-serif" font-size="69" id="svg_4" y="71.5" x="285" stroke-width="0" stroke="#000000" fill="#44505f">ts</text>
				  <text transform="rotate(-90 333.00000000000006,31.999999999999975) " font-weight="bold" xml:space="preserve" text-anchor="middle" font-family="Sans-serif" font-size="24" id="svg_4" y="40.5" x="333" stroke-width="0" stroke="#000000" fill="#44505f">com</text>
				  <ellipse fill="#44505f" stroke="#000000" stroke-width="0" stroke-dasharray="null" stroke-linejoin="null" stroke-linecap="null" cx="336" cy="67" id="svg_7" rx="4" ry="4"/>
				 </g>
				</svg>
			</div>
		</div><!-- /leftdiv -->
		<div data-role="centerdiv">
			<div data-role="search-appliance">
			</div>
		</div><!-- /centerdiv -->
	</div><!-- /header -->

	<div data-role="content">
		<div data-role="leftdiv">
			<p></p>
		</div><!-- /content -->
		<div data-role="centerdiv">
			<div id="list" data-role="page"> 
				<div data-role="content">
					<ul data-role="listview">
						<li><a href="#home">Home</a></li>
						<li><a href="documentation.html">Documentation</a></li>
						<li><a href="PROXYcheckout"><span>Buy</span></a></li>
						<li><a href="PROXYaccountSummary"><span>My Profile</span></a></li>
					</ul>
				</div> 
			</div>
			<!-- ================================================================================ HOME -->
			<div id="home" data-role="page"> 
				<div data-role="content">
					<h4>2charts.com - what's that?!</h4>
					<p>
						<span>Welcome to 2charts.com  - a billion charts at your disposal !! </span><br/>
						<span>2charts.com is <i>NOT</i> a developer tool - it is a tool for <i>you</i>, the internet user. </span><br/>
						<span>Upon your "click", the 2charts.com servers in the "cloud" derive charts from tabular data contained anywhere on the internet. </span>
						<span>For optimized usability,  2charts.com  seamlessly integrates into your favorite web browser.</span>
						<span>Highlights: </span>
						<ul>
							<li>No installation required!</li>
							<li>No configuration required!</li>
							<li>No development required! (send your IT people on a vacation ;-)</li>
							<li>Free trial period so you can check it out.</li>
							<li>Screenshot Gallery:<br/>
								<div data-role="gallery" id="galleria">
							</li>
						</ul>
					</p>
	 
					<!--<div data-role="collapsible">
						<h4 text-align="middle">Screenshot Gallery</h4>
						<div data-role="gallery" id="galleria">
						</div>
					</div>-->
			</div> 
		</div><!-- content -->
	</div><!-- content -->
	
	<div data-role="footer" data-theme="d">
		<span><a href="mailto:marty@2charts.com">Contact</a></span>
		<span> © 2012  2charts.com </span>
	</div><!-- /footer -->
</div><!-- /page one -->

</body>
</html>