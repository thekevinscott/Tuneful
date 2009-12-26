$(function($){
	var tuneful = function(options) {
		privatevar = 'private!';
		// initialize
		
		
		
		return {
			'publicvar' : 'test',
			'publicmethod' : function() {
				alert(privatevar);
			}
		};
	}({});
}(jQuery));