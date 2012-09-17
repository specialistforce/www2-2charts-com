	(function($,undefined) {
		$(document).ready(function(){
			initUiClasses = function($node) {
				$node.find("*[data-role]").each( function(i) {
					var $dataRole = $(this).attr("data-role");
					var $dataPosition = $(this).attr("data-position");
					$(this).addClass("ui-"+$dataRole);
					if ($dataPosition !== undefined) { $(this).addClass("ui-"+$dataRole+"-"+$dataPosition); };
				});				
			};
			//////////////////////////////////////////////////////////////////// Simulate JQuery Mobile:
			//$("*[data-role]").each( function(i) {
			//	var $dataRole = $(this).attr("data-role");
			//	var $dataPosition = $(this).attr("data-position");
			//	$(this).addClass("ui-"+$dataRole);
			//	if ($dataPosition !== undefined) { $(this).addClass("ui-"+$dataRole+"-"+$dataPosition); };
			//});
			initUiClasses($(document));
			$("h1,h2,h3,h4").addClass("ui-title");
			$(".ui-listview")
				.find("li")
					.addClass("ui-li")
					.has("a").addClass("ui-btn")
			;
			$(".ui-iframe").each(function(i){
				var src = $(this).attr("data-src");
				$('<iframe src="'+src+'"/>').appendTo($(this));
			});
			$(".ui-page:first")
				.addClass("ui-page-active")
				; /*
				.find(".ui-listview:has(a)")
					.find("a").each( function(i) {
						var href = $(this).attr("href");
						$target = $(String(href));
						$target.insertAfter($(this).closest(".ui-listview"));
					})
					.end()
				.parent()
				.tabs(
					{
						,ajaxOptions: {
							beforeSend: function( xhr, settings ) {
								settings.url = settings.url.replace("SLASH","/");
							}
							,error: function( xhr, status, index, anchor ) {
								alert(status);
								$( anchor.hash ).html("Error retrieving external content." );
								window.location.href="trySecuredURL?url=home.html";
								return false;
							}
							,success: function(data, textStatus, jqXHR) {
								if (data.match(/Not logged in/)) {
									window.location.href="trySecuredURL?url=home.html";
									return false;
								}
								return true;
							}
						}
					}					
				)
			;
*/			
		});
	})(jQuery);
	