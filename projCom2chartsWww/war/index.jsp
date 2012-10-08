<%@page contentType="text/html" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<meta content="text/html; charset=utf-8" http-equiv="content-type"/>
	<meta name="Copyright" content="Copyright (c) CT corporate technologies s.r.o."/>
	<title>2charts.com Home</title> 
	<link rel="stylesheet" media="screen" href="css/home.css" />
	<link rel="stylesheet" media="only screen and (min-width:960px) and (max-width:1279px)" href="css/home-wide.css" title="widescreen" />
	<link rel="stylesheet" media="only screen and (min-width:1280px)" href="css/home-wider.css" title="widescreen" />
	<link rel="shortcut icon" href="icon.png" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<!--<script src="lib/jquery-1.8.1.js"></script>-->
	<!-- IF MOBILE -->
		<!--<script src="lib/jquery.mobile-1.1.1.js"></script>-->
	<!-- ELSE -->
		<link rel="stylesheet" href="css/jquery-ui.css" />
		<link rel="stylesheet" href="css/jquery-ui-override.css" />
		<!--<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"></script>-->
		<script src="lib/jquery-ui-1.8.23.js"></script>
		<script src="lib/jquery.cookie.js"></script>
		<script src="lib/jqm-on-nonmobile.js"></script>
	<!-- ENDIF -->
	<link rel="stylesheet" href="lib/galleria/themes/override-css/override.css" />
	<script src="lib/galleria/galleria-1.2.8.js"></script>
	<script src="lib/galleria/plugins/flickr/galleria.flickr.min.js"></script>
	<script src="lib/modernizr.js"></script>
	<script>
	var selectedTab = <%= request.getParameter("selectedTab") != null ? request.getParameter("selectedTab") : "null" %>;
	//document.domain = "2charts.com";	
	//WWW = "//localhost:8888/index";
	//PROXY = "//localhost:8888";
	WWW = "http://www.2charts.com/";
	QUERYSTRING = "?" + "parentURI=" + encodeURIComponent(WWW);
	PROXY = "http://proxy.2charts.com";
	INJECTSIGNIN = PROXY + "/injectAuthIfNeeded?url=";
	
	SEARCH = "www.bing.com/search";
	var $firstMenu;
		
	Modernizr.load({
		test: Modernizr.svg
		//,nope: ['css/no-svg.css']
		,both: ['css/no-svg.css']
	});

	(function($,undefined) {
		$(document).ready(function(){
			$firstMenu = $(".ui-page:first .ui-listview:has(a)");
			$firstMenu.data("onSelectionChange", function(selectionIndex) {
				switch(selectionIndex) {
					case 0:
						//$("#checkout iframe").attr("src", "about:blank");
						$("#checkout").html('');
						$("#myprofile").html('');
						Galleria.run('#galleria')
							.get(0).play(7000);
					break;
					case 1:
						$("#checkout").html('');
						$("#myprofile").html('');
						if (Galleria.get().length) { Galleria.get(0).pause(); };
					break;
					case 2:
						var url = PROXY + "/checkout" + QUERYSTRING;
						$("#checkout").html(
							Modernizr.xhr2 ? '' : '<iframe src="' + url + '" width="480px" height="300px"/>'
						);
						$("#myprofile").html('');
						if (Galleria.get().length) { Galleria.get(0).pause(); };
					break;
					case 3:
						var url = PROXY + "/accountSummary" + QUERYSTRING;
						$("#checkout").html('');
						$("#myprofile").html(
							Modernizr.xhr2 ? '' : '<iframe src="' + url + '" width="720px" height="400px"/>'
						);
						if (Galleria.get().length) { Galleria.get(0).pause(); };
					break;
					default:
				};
			});
				
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
				//autoplay: 7000,
				flickr: 'set:72157630985524022'
				,flickrOptions: {
					sort: 'date-posted-asc'
				}
				,fullscreenCrop:"height"
				,responsive:true
				,transition:"fadeslide"
			});

			isAuthPage = function(data) {
				return data.match(/Not logged in/);
			};
			var tabOptions = {
				cookie: {expires:1, secure:false}
				,cache:false
				,select: function(event,ui) {
					$firstMenu.data("onSelectionChange")(ui.index);
				}
				,load: function(event,ui) {
					$o = $(".ui-tabs-panel");
					initUiClasses($o);						// add ui- classes depending on data-role
				}
				,ajaxOptions: {
					xhrFields: {
						withCredentials: Modernizr.xhr2
					}
					,beforeSend: function( xhr, settings ) {
						settings.crossDomain = Modernizr.xhr2;
						settings.url = settings.url.replace("PROXY",PROXY + "/");
						settings.url += QUERYSTRING;
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
			// ============================================================================== initialize tabs:
			if (Modernizr.xhr2 === false) {
				$firstMenu.find("li:eq(2) a").attr("href","#checkout");
				$firstMenu.find("li:eq(3) a").attr("href","#myprofile");
				//$firstMenu.find("li:eq(3) a").remove();
			};
			// ============================================================================== populate tabs:
			$firstMenu
					.find("a[href^='#']").each( function(i) {
						var href = $(this).attr("href");
						$target = $(String(href));
						//$target.insertAfter($(this).closest(".ui-listview"));
						$target.insertAfter($firstMenu);
					})
					.end()
				.parent()
				.tabs(tabOptions)
				.each(function(i0) {
					var selectionIndex = $(this).tabs("option","selected");
					$firstMenu.data("onSelectionChange")(selectionIndex);
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
			// ============================================================================== preselect (focus) search field:            
            $(".ui-search-appliance-input input").focus();
		});
	})(jQuery);
	</script>
</head> 

	
<body> 

<div data-role="page" id="one">
	<div data-role="header">
		<div data-role="leftdiv">
			<div class="img"><img src="res/20120920.HH1.png" height="50"/></div>
			<!--<div class="svg">
				<svg width="360" height="80" xmlns="http://www.w3.org/2000/svg">
				 <defs>
				  <linearGradient y2="0.76" x2="1" y1="0.24" x1="0" id="svg_10">
				   <stop stop-color="#c4f1ff" offset="0"/>
				   <stop stop-color="#45a5b4" offset="1"/>
				  </linearGradient>
				 </defs>
				 <g transform="scale(1)">
					 <g display="inline">
					  <title>Layer 1</title>
					  <rect fill="#44505f" stroke="#000000" stroke-width="0" x="0" y="8" width="64" height="64" id="svg_1"/>
					 </g>
					 <g>
					  <title>Layer 2</title>
					  <rect fill="url(#svg_10)" stroke="#000000" stroke-width="0" x="9" y="34" width="19" height="37" id="svg_2"/>
					  <rect fill="url(#svg_10)" stroke="#000000" stroke-width="0" x="37" y="21" width="19" height="50" id="svg_3"/>
					  <text fill="#44505f" stroke="#000000" stroke-width="0" x="164" y="71.5" id="svg_4" font-size="69" font-family="Sans-serif" text-anchor="middle" xml:space="preserve">2char</text>
					  <text fill="#44505f" stroke="#000000" stroke-width="0" x="287" y="71.5" id="svg_4" font-size="69" font-family="Sans-serif" text-anchor="middle" xml:space="preserve">ts</text>
					  <text fill="#44505f" stroke="#000000" stroke-width="0" x="335" y="40.5" id="svg_4" font-size="24" font-family="Sans-serif" text-anchor="middle" xml:space="preserve" transform="rotate(-90 336.00000000000006,31.999999999999975) ">com</text>
					  <ellipse ry="4" rx="4" id="svg_7" cy="67" cx="338" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" stroke="#000000" fill="#44505f"/>
					 </g>
				 </g>
				</svg>
			</div>
			<div class="svg">
				<svg width="364" height="70" xmlns="http://www.w3.org/2000/svg">
				 <defs>
				  <linearGradient y2="0.76" x2="1" y1="0.24" x1="0" id="svg_10">
				   <stop stop-color="#c4f1ff" offset="0"/>
				   <stop stop-color="#45a5b4" offset="1"/>
				  </linearGradient>
				 </defs>
				 <g>
					 <g display="2charts.com">
					  <title>2charts.com</title>
					  <rect fill="#44505f" stroke="#FFFFFF00" stroke-width="0" x="0" y="14" width="48" height="48" id="svg_1"/>
					 </g>
					 <g>
					  <title>2charts.com</title>
					  <rect fill="url(#svg_10)" stroke="#FFFFFF00" stroke-width="0" x="7" y="33" width="14" height="28" id="svg_2"/>
					  <rect fill="url(#svg_10)" stroke="#FFFFFF00" stroke-width="0" x="27" y="23" width="14" height="38" id="svg_3"/>
					 </g>
					 <g>
					  <title>2charts.com</title>
					  <text fill="#44505f" stroke="#FFFFFF00" stroke-width="0" x="124" y="61" id="svg_4" font-size="54" font-family="Sans-serif" text-anchor="middle" xml:space="preserve">2char</text>
					  <text fill="#44505f" stroke="#FFFFFF00" stroke-width="0" x="221" y="61" id="svg_5" font-size="54" font-family="Sans-serif" text-anchor="middle" xml:space="preserve">ts</text>
					  <text fill="#44505f" stroke="#FFFFFF00" stroke-width="0" x="307" y="61" id="svg_6" font-size="54" font-family="Sans-serif" text-anchor="middle" xml:space="preserve">com</text>
					  <ellipse ry="4" rx="4" id="svg_7" cy="49" cx="251" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" stroke="#000000" fill="#44505f"/>
					 </g>
				 </g>
				</svg>
			</div>
			-->
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
			<!-- ================================================================================ TABS: -->
			<div id="list" data-role="page"> 
				<div data-role="content">
					<ul data-role="listview">
						<li><a href="#home">Home</a></li>
						<li><a href="documentation.html">Documentation</a></li>
						<li><a href="PROXYcheckout"><span>Buy</span></a></li>
						<li><a href="PROXYaccountSummary"><span>My Profile</span></a></li>
						<!--<li><a href="#checkout"><span>Buy (IE)</span></a></li>-->
					</ul>
				</div> 
			</div>
			<!-- ================================================================================ HOME: -->
			<div id="home" data-role="page"> 
				<div data-role="header" data-position="fixed">
					<div data-role="leftdiv">
						<h4>2charts.com - what's that?!</h4>
					</div>
				</div> 
				<div data-role="content">
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
				</div>
			</div> 
			<!-- ================================================================================ iFRAMEs: -->
			<div id="checkout" data-role="page"> 
				<div data-role="content">
					<!--<iframe src="about:blank" width="480px" height="440px"/>-->
				</div>
			</div> 
			<div id="myprofile" data-role="page"> 
				<div data-role="content">
					<!--<iframe src="about:blank" width="640px" height="400px"/>-->
				</div>
			</div> 
		</div><!-- content -->
	</div><!-- content -->
	
	<div data-role="footer" data-theme="d">
		<span><a href="mailto:marty@2charts.com">Contact</a></span>
		<span><a href="terms-of-use.html" target="_blank">Terms of Use</a></span>
		<span> © 2012  2charts.com </span>
	</div><!-- /footer -->
</div><!-- /page one -->

</body>
</html>