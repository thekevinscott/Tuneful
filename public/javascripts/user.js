$(function($){
	tuneful.user = function(options) {
		throwError = function(msg) { trace('User JS: '); trace(msg); };
		
		parent = options.parent;
		var name, email, hash;
		
		login = function() {
			
		};
		logout = function() {
			
		};
		create = function(opt) {
			$.getJSON('users/new.js',{},function(data){
				if (opt.callback) { opt.callback(data); }
			});
		}
		
		cookie = parent.readCookie('user.unique_hash');
		if (! cookie) {
			// this is a total new user. do a ping to the server and create a new user
			create({callback: function(data) {
				if (data&&data.user&&data.user.unique_hash) {
					hash = data.user.unique_hash;
					parent.writeCookie('user.unique_hash',hash);
					
				} else { this.throwError('There was an error creating the user, there is no unique hash'); }
			}});
			
		} else {
			hash = cookie;
			// this is a returning user. they may have visited the site before and not logged in, or they may have a login
		}
		
		
		return {
			parent: parent,
			throwError : throwError,
			getUser : function(key) {
				obj = {name: name, email: email, hash: hash};
				if (key) {
					return obj[key] || "That key does not exist";
				}
				return obj;
			}
		}
	
	
	}({parent: tuneful});
}(jQuery));