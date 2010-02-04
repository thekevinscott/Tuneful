tuneful_invites = function(total_invites) {
	
	invites = total_invites-1;
	
	$(document).ready(function(){
		$('#invites form a').click(function(e){
			e.preventDefault();
			//if ()
		});
	});
	
	
	function getInvites() {
		return invites;
	}
	return {
		getInvites: getInvites
	}

};