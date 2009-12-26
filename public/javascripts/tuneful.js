var tuneful = $(function($){
	return function(options) {		
		
		privatevar = 'private!';
		requests = {'/' : 'pane-1'};
		// initialize
		
		$(document).ready(function(){
			$('a').click(function(e){
				e.preventDefault();
				window.location.hash = $(this).attr('href');
				go($(this).attr('href'));
			});
		});
		
		currentLink = window.location.hash.substring(1);
		windowChange = setInterval(function(){
			if (window.location.hash.substring(1)!==currentLink) {
				go(window.location.hash.substring(1));
			}
		},20);
		
		go = function(href) {
			currentLink = href;
			/*
			if (requests[href]) {
				request = requests[href];
			} else {
				request = 'pane-'+(parseInt($('.pane:last').attr('id').split('-').pop() )+1);
				requests[href] = request;
				$('#slideshow').append('<div id="'+request+'" class="pane" >STUFF GOES IN HERE</div>');
			}
			*/
			$.get(currentLink,{},function(data){
				$('#tuneful').html(data);				
			});
		}
		
		return {
			'publicvar' : 'test',
			'publicmethod' : function() {
				alert(privatevar);
			},
			changeStation : function(url) {
				console.log(url);
			}
		};
	}({});
}(jQuery));