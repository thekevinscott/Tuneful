var tuneful = $(function($){
	return function(options) {		
		
		privatevar = 'private!';
		requests = {'/' : 'pane-1'};
		// initialize
		
		$(document).ready(function(){
			/*
			$('a:not(.lightbox)').click(function(e){
				e.preventDefault();
				window.location.hash = $(this).attr('href');
				go($(this).attr('href'));
			});
			*/
			$("a.lightbox").fancybox();
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
			changeStation : function(url) {
				console.log(url);
			},
			lastfm_api_key : 'ea3dfbd0cc2ec04264aff8b83a01676f',
			lastfm : 'http://ws.audioscrobbler.com/2.0/?',
			youtube : 'http://gdata.youtube.com/feeds/api/videos?orderby=relevance&v=2&alt=json&callback=?&',
			callbacks : {},
			radio : null,
			init : function() {

				$(document).ready(function(){
					$('.comment').click(function(e){
						$('.comment-form').slideDown('slow');
					});
					$('#radio-popout').click(function(){
						if (station) { station.openRadio(); }
						else {
							var opts = 'location=0,status=0,toolbar=0,scrollbars=0,resizable=0,directories=0,menubar=0,height=200,width=600';
							window.open('radio/'+tuneful.radio,'Tuneful Radio',opts);
						}
					});
				});

			},
			queryLastFM : function(opt,callback) {
				var url = 	this.lastfm+'api_key='+this.lastfm_api_key+'&format=json&callback=?';
				for (var i in opt.options) {
					url += '&'+i+'='+opt.options[i];
				}
				var self = 	this;
				$.getJSON(url, function(data){ callback(data);});
			},

			queryYouTube : function(opt,callback) {
				var url = this.youtube+'q='+opt.search.split(' ').join('+');
				$.getJSON(url,function(data){callback(data); });
			},
			addCallback : function(opts) {
				type = opts.type;	// youtube
				arg = opts.arg;	// playerid
				callback = opts.callback; // callback
				obj = opts.obj; // the object which owns the callback
				if (type&&arg&&callback&&obj) { 
					if (! this.callbacks[type]) { this.callbacks[type] = {}; }
					this.callbacks[type][arg] = {callback:callback,obj:obj};
					return true;
				} else {return false;}
			},
			onYouTubePlayerReady : function(args) {
				callbacks = this.callbacks.youtube;
				if (callbacks[args]) { callbacks[args].callback({args:args,self:obj}); }
			},
			writeCookie	: function(name,value,days) {
				if (days==undefined) {
					days = 7;		// a week, if we don't specify
				}
				var date = new Date();
				date.setTime(date.getTime()+(days*24*60*60*1000));
				var expires = "; expires="+date.toGMTString();
				if (name.split('.')[0]!='tuneful') { name = 'tuneful.'+name; }
				document.cookie = name+"="+value+expires+"; path=/";
			},
			readCookie : function(name) {
				if (name.split('.')[0]!='tuneful') { name = 'tuneful.'+name; }		
				var nameEQ = name + "=";
				var ca = document.cookie.split(';');
				for(var i=0;i < ca.length;i++) {
					var c = ca[i];
					while (c.charAt(0)==' ') c = c.substring(1,c.length);
					if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
				}
				return null;
			}
		};
	}({});
}(jQuery))[0];

function trace(msg){
	if (window['console']&&console.log) { console.log(msg); }
}
// for youtube
function onYouTubePlayerReady(playerId) { 
	tuneful.onYouTubePlayerReady(playerId);
}
jQuery.fn.loading = function(data) {
	if (data) { data = '<br />'+data; } else { data = null; }
	$(this).html('<div class="loading"><img src="'+html+'images/loading.gif" alt="Loading" />'+data+'</div>');
};
