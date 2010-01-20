(function($) {
	$.fn.scroller = function(params) {
		var memory = {};
		var sitTime = 2000;
		var scrollSpeed = 60;
		var offset = 35;
		var scrollingIntervals = {};
		this.each(function() {
			if (params.toggle) {
				
				$(document).ready(function(){
					$('#track-info-toggle a').click = function() {
						//alert('shit balls');
					}
				});
				
			}
			
			
			if (! memory[this] || $(this).html!= memory[this]) {
				memory[this] = $(this).html();
				reset(this);
			}			
			var self = this;
			
			function reset(el) {
				$(el).css({'marginLeft':0});
				setTimeout(function(){
					div_width = $(el).parent().width();
					words_width = $('.track-info-words').width();
					scrollingIntervals[el] = setInterval(function(){scrollIt(el);},scrollSpeed);
					
				},sitTime);
			}
			function scrollIt(el){
				marginLeft = parseInt($(el).css('marginLeft'));
				
				if (marginLeft > (div_width-words_width)-offset) {
					marginLeft = (marginLeft-1)+'px';
					$(el).css({'marginLeft':marginLeft});
				} else {
					clearInterval(scrollingIntervals[el]);
					setTimeout(function(){
						reset(el);
					},sitTime);
				}
			}
			
		});


		return this;
	};
	
		
})(jQuery);