$(function($){
	if (tuneful&&tuneful.user&&!tuneful.user.invites||1) {
		tuneful.user.invites = function(options) {
			
			// we don't know how many invites the dude has left.
			// only the server knows that.
			
			throwError = function(msg) { trace('User Invites JS: '); trace(msg); };
		
			parent = options.parent;
			
			var invites;
		
			function write(target,msg){
				if (target&&$(target)) { $(target).html(msg); return true; }
				else { return false; }
			}
			
			function validEmail(email) {
				validRegExp = /^[^@]+@[^@]+.[a-z]{2,}$/i;
				if (email.search(validRegExp) == -1)  {return false;} 
				else {return true;}
			}
		
			addInputListeners = function() {
				
				$('#invites .an-invite input').blur(function(){
					$(this).removeClass('error').removeClass('works');
					email_val = $(this).val()
					if (email_val) {
						if (! tuneful.user.invites.validEmail(email_val)) {
							$(this).addClass('error');
							if ($(this).parent().find('.error-msg').length==0) {
								$(this).parent().append('<div class="error-msg">This does not appear to be a valid email address</div>');
							}
							$(this).parent().find('.error-msg').slideDown();
						} else {
							$(this).addClass('works');
							$(this).parent().find('.error-msg').slideUp();
						}
					}
				});
				
				
				$('#invites .an-invite input').focus(function(){
					$(this).parent().find('.error-msg').slideUp();
				});
			}
			
			addEmailInput = function(e) {
				e.preventDefault();
				invite_length = $('#invites .an-invite').length;
				if (invite_length<tuneful.user.invites.getInvites()) {
					$('#invites #invite-collection').append('<div class="an-invite"><label>Invite #'+(invite_length+1)+': </label><input type="text" /></div>');
				};
				tuneful.user.invites.addInputListeners();
				if (invites-invite_length-1>0) {
					write($('#invites #number-left'),"You've got "+(invites-invite_length-1)+" more invites");
				} else {
					$('#invites #add-more').remove();
					$('#invite-collection').append("<div id='add-more'>You've got no more invites</div>");
				}
			}
		
			var setInvites = function(i) {
				// this function is basically init
				invites = i;
				write($('#invites #invite-header span'),"You've got "+invites+" invites left.");
				//console.log('set');
				tuneful.user.invites.addInputListeners();
				$('#invites #add-more').click(tuneful.user.invites.addEmailInput);
				
				$('#invites form').submit(function(e){
					e.preventDefault();
					
					inputs = $('#invite-collection input');
					if ($('#invite-collection input.error').length>0) {
						alert("Please only submit valid email addresses");
					} else {
						emails = [];
						inputs.each(function(i,idx){
							val = $(idx).val();
							if (val) { emails.push(val); }
						});
						if (emails.length==0) {
							alert("You haven't entered any email addresses!");
						} else {
							
							$.post('users/invites',{invites:emails.toString()},function(data){
								if (data.error==0) {
									emails_length = emails.length;
									last = emails.pop();
									if (emails_length>0) {
										emails = emails.join(', ')+' and '+last;
									} else {
										emails = last;
									}
									string = "You have successfully invited "+emails+'<br /><br />Well done!';
									$('#invites').html(string);
									tuneful.user.updateInvites(emails_length);
								} else if (data.error==3) {
									$('#invites').html("You sneaky bugger! How'd you do that? Don't abuse the system!<br /><br />We've taken the first couple from your list.");
								} else {
									$('#invites').html("Grrr, there was some sort of error. We've been notified. Please try again later.");
								}
							},'json');
							
							$('#invites').loading();
						}
						
					}
				});
				// how many invites are on the page?
				//console.log($('#invites .an-invite').length);
			}
		
			return {
				parent: parent,
				validEmail : validEmail,
				setInvites: setInvites,
				addInputListeners : addInputListeners,
				addEmailInput : addEmailInput,
				getInvites: function() { return invites; } // we expose this publicly, but we're also gonna check your invites on the server, so no hanky-panky
			}
	
	
		}({parent: tuneful.user});
	}
}(jQuery));