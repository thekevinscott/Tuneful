$(function($){
	tuneful.radio = function() {
		
		playerid = 'player';			// our default name, 99% chance this will never change
		embedded = true;
		player = null;
		
		playlist = [];
		station = null;
		state = 'IDLE';
		index = 0;
		servertime = 0;
		createSwf = function() {
			if (! tuneful.addCallback({type:'youtube',arg:this.playerid,callback:this.swfCallback,obj:this}) ) { 
				throwError('Error adding Youtube callback'); 
			}
			if (swfobject) {
			    swfobject.embedSWF(
					"http://www.youtube.com/apiplayer?enablejsapi=1&version=3&playerapiid="+this.playerid,
					this.playerid, "1", "1", "9", null, null, 
					{ allowScriptAccess: "always" }, 
					{ id: this.playerid }
				);
			} else { throwError('Error embedding SWF, no swfobject found'); }
		};
		swfCallback = function(opts) {
			self = opts.self;
			div = opts.args || self.playerDiv;
			self.player = $('#'+div)[0];		// FUCK YOU FLASH
			self.loaded = true;
			self.player.addEventListener('onStateChange','tuneful.radio.onStateChange');	// NEED TO FIX THESE!!!!!!
			self.player.addEventListener('onError','tuneful.radio.onError');
			// If the swf has been created successfully, and we already have a playlist, start playing it.
			if (playlist.length>0&&state!= 'PLAYING' ) {
				self.play();
			} else {
				//console.log('connect has not been called yet, wait for it');
			}
		};
		
		
		//throwError = function(msg) { trace('Radio JS: '); trace(msg); };
		
		throwError = function(target,opts,text) {
			trace('THROW THE FUCKING ERROR');
			text = text || errorText;
			$(target).html(text);
			trace('throw Error from Station');
			trace(opts);
			$.post('/errors/',opts);
		}
		
		connect = function(options) {
			//trace(options);
			if (options) {
				if (options.playlist && options.playlist.tracks) {
					for (var i in options.playlist.tracks) { playlist.push(options.playlist.tracks[i]); }
				} else { this.throwError('No playlist provided.'); }
				
				if (options.station && options.station.title && options.station.url) {
					station = options.station; 
					servertime = options.playlist.servertime;
					/*
					this.setupControls();
					this.servertime = options.playlist.servertime;
					self = this;
					if (this.embedded) { 
						$('#radio-contents').prepend('<a id="popout" href="#" class="button">Popout</a>'); 
						$('#popout').click(function(e){
							var opts = 'location=0,status=0,toolbar=0,scrollbars=0,resizable=0,directories=0,menubar=0,height=200,width=600';
							var result = window.open('radio/'+self.station.station_hash,'Tuneful Radio',opts);
							trace(result);
							self.close();
						});
					}*/
				} else { this.throwError('No station provided.'); }
				
				// If options have been passed successfully, and we already have a player object, start playing it
				if (player&&state!='PLAYING') {
					play();
				} else { 
					//console.log('swf has not been inited yet');
				}
				
				if ($('#radio-add-song').length>0) {
					$('#radio-add-song').attr('href','station/'+station.url+'/find_song');
				}
				
			} else { this.throwError('You must provide an initial argument object to the Connect function.'); }
		};
		
		play = function() {
			trace('-----------------');
			trace('play');
			trace('[play]playlist:');
			trace(playlist);
			// do we have a playlist?
			index = 0;
			if (playlist&&playlist.length>0) {
				
				if (state!='Playing') {	// start playing
					start = playlist[index].start || 0;
					trace('[play]current track');
					trace(playlist[index]);
					trace('the current track is :'+ playlist[index].title);
					if (playlist[index+1]) {
						trace('the next track is :'+playlist[index+1].title);
					} else {
						trace('there is no next track, well haver to go get it');
					}
					player.loadVideoById(playlist[index].file,start);
					playlist[index].playing = true;

					getTrackInfo(index);	
					writeTrackInfo(playlist[index]);		// we pass the writing function the individual track
					//this.resetThumbs();
					if (! playlist[index + 1 ]) { loadNext(); }


					/*

					if (! this.listener) {
						if (this.muted) {this.player.mute();}
						else{$('#radio-state').html(this.state);}

					}
					*/

				} 
			}
		};
		
		getTrackInfo = function(index) {
			if (! index) { index = 0; }
			if (! playlist[index].image || ! playlist[index].album) { 
				tuneful.queryLastFM({options:{artist:playlist[index].artist,track:playlist[index].title,method:'track.getinfo'}},function(data){
					if (! data.error&&data.track&&data.track.album) { 

						if (! playlist[index].album) { 
							playlist[index].album= data.track.album.title;
							//self.updates.push({track:self.playlist[index],key:'album'});
						};
						if (! playlist[index].image) { 
							playlist[index].images_data 	= data.track.album.image;
							playlist[index].image 			= playlist[index].images_data[1]['#text'];
							//self.updates.push({track:playlist[index],key:'image'});
						};
						//self.update();
					} else { 
						if (data.error==6) { data.error = "No image found."; }
						throwError(data.error); 
						playlist[index].image = 'default.png';
					}
					
					
					
					if (playlist[index].writeWhenReady) {
						writeTrackInfo(playlist[index]);
					}
					
					
				});
			} else { writeTrackInfo(playlist[index]); }
		};

		writeTrackInfo = function(track) {
			if (track.playing) { 
				$('.status').hide();
				$('#track-info').show();
				if (track.image) { $('#track-logo').css('background','url('+track.image+') no-repeat').html(''); }
				else { this.playlist[index].writeWhenReady = true; }
				//console.log(track);
				$('#track-title').html(track.title);
				$('#track-artist').html(track.artist);
				$('#track-album').html(track.album);
				
			}
		};
		
		loadNext = function() {
			trace('---------');
			trace('load next');
			file = window.location.pathname;
			var self = this;
			$.getJSON('/station/'+station.url+'/playlist/next',{},function(data){
				trace('[load next]playlist');
				trace(playlist);
				
				track = data.playlist.tracks.pop();
				trace('[load next]track');
				trace(track);
				trace(track.title);
				playlist.push(track);
				trace('[load next]playlist');
				trace(playlist);
				trace('the current track: '+playlist[0].title);
				trace('the next track: '+playlist[1].title);
				//this.servertime = data.servertime;
				self.playlist[index].writeWhenReady = false;
				self.getTrackInfo(index);
			});
		};
		
		
		
		
		
		
		readPlaylist = function(key) {
			if ( key ) {
				if (playlist[key]) { return playlist[key]; }
				else { return false; }
			} else { return playlist; }
		};
		readStation = function() {
			return station;
		}
		
		// our private init methods
		createSwf();
		
		var radio_menu_html = '';
		
		
		addComment = function(target) {
			$('#radio-more').unbind('mouseout');
			$('#radio-more-menu').height($('#radio-more-menu').height()).width($('#radio-more-menu').width());
			
			$('#radio-more-menu').append('<form rel="'+target+'"><textarea></textarea><a href="#">Cancel</a><input type="submit" value="Add Comment" /></form>');
			
			
			$('#radio-more-menu #radio-more-menu-wrapper').slideUp('fast');
			$('#radio-more-menu form').slideDown('fast');
			
			$('#radio-more-menu form').submit(function(e){
				e.preventDefault();
				comment = $('#radio-more-menu textarea').val();
				if (comment) { 
					$('#radio-more-menu').html('Comment Saved.');
					setTimeout(function(){
						$('#radio-more-menu').slideUp(150,closeRadioMenu);
					},1000);
					$.post($(this).attr('rel')+'/comment',{},function(data){
						console.log(data);
					});
				} else { alert('You have to write a comment, or cancel.'); }
			});
			$('#radio-more-menu a').click(closeRadioMenu);
		}
		
		openRadioMenu = function(e) {
			e.preventDefault();
			/*
			$('#radio-more').css({	'-moz-border-radius-bottomleft':'0','-moz-border-radius-bottomright':'0',
									'-webkit-border-radius-bottomleft':'0','-webkit-border-radius-bottomright':'0'});
									*/
			$('#radio-more').css(makeBorders(0,['bottom']));									
			$('#radio-more-menu').show();
			if (! radio_menu_html) { radio_menu_html = $('#radio-more-menu').html(); }
		}
		closeRadioMenu = function(e) {
			if (e) { e.preventDefault(); }
			$('#radio-more').css(makeBorders(10,['bottom']));
			$('#radio-more-menu').hide().width('200px').height('auto');
			if (radio_menu_html) { 
				$('#radio-more-menu').html(radio_menu_html); 
				menuClickHandlers();
			}
			
			//$('#radio-more-menu a.lightbox').fancybox({'hideOnContentClick':false,'frameHeight': 600,'overlayOpacity':0.6});
		}
		menuClickHandlers = function(){
			$('#radio-more-menu a.lightbox').fancybox({'hideOnContentClick':false,'frameHeight': 600,'overlayOpacity':0.6});
			
			
			$('#radio-more-menu a').click(function(e) {
				
				e.preventDefault();
				switch($(this).attr('id')) {
					case 'track-buy-song' :
						$('#radio-more-menu #radio-more-menu-wrapper').slideUp('fast');
						$('#radio-more-menu #menu-buy-links').slideDown('fast');
						
					break;
					case 'comment-track' : case 'comment-station' :
						addComment($(this).attr('id').split('-').pop());
					break;
					case 'radio-add-song' :
						closeRadioMenu();
					break;

				}
			});
		};
		
		/****** Set up Player Controls ******/
		
		$(document).ready(function(){
		
		
			// open, close track info
			var radioSectionWidths = {left: $('#radio-left').width(), right: $('#radio-right').width()};
			
			$('#track-info-toggle a').click(function(e){
				e.preventDefault();
				if ($(this).attr('rel')=='closed') { // then open it
					$('#radio-left').animate({width:'100%'});
					$('#radio-right').animate({width:'0%',opacity:0});
					$(this).attr('rel','open').html('&laquo;');

				} else {
					$('#radio-left').animate({width:radioSectionWidths.left});
					$('#radio-right').animate({width:radioSectionWidths.right,opacity:1});	
					$(this).attr('rel','closed').html('&raquo;');		
				}
			});
			
			// voting
			$('#track-voting a').click(function(e){
				e.preventDefault();
				direction = $(this).attr('id').split('-').pop();
				//console.log(direction);
				switch(direction) {
					case 'up' :
						
					break;
					case 'down' :
					break;
				}
			});
			
			
			$('#radio-more').hover(openRadioMenu, closeRadioMenu);
			
			addComment = addComment;
			menuClickHandlers();
			
			
			// add scrolling text
			$('.track-info-wrapper').scroller({toggle:$('#track-info-toggle a')});
			
		});
		
		vote = function(el) {
			alert(el);
		}
		
		
		return {
			player : player,
			playerid : playerid,
			readPlaylist : readPlaylist,
			readStation : readStation,
			swfCallback : swfCallback,
			
			//player : null,
			//state : 'IDLE',
			//current : null,
			//bufferingAttempts : 0,
			//servertime : 0,
			//muted : false,
			//updates : [],

			onStateChange : function(state) {
				//Possible values are unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5)
				switch(state) {
					case -1 : this.state = 'LOADING'; break;
					case 0 : this.state = 'ENDED'; break;
					case 1 : this.state = 'PLAYING'; break;
					case 2 : this.state = 'PAUSEd'; break;
					case 3 : this.state = 'BUFFERING'; break;
					
					case 5 : this.state = 'VIDEO CUED'; break;
				}
				if (state==0) {		// ended
					if (this.listener) { this.play(); }
					else { this.next(); }
				}
				if (state==3) {
					//trace('**** BUFFERING ****');
					stop_time = Date.now();
					//trace(Date)
				} else {
					if (stop_time) { // catch up to where we were
						//trace('now we should jump ahead, so were not behind');
					}
					
					stop_time = null;
				}
				//console.log(this.state);
			},

			onError : function(error) {
				this.updateVideoLink();
			},

			play : play,

			next : function() {	
				trace('-----------------');
				trace('next');	
				
				playlist.shift();
				this.play();
				$('#radio-state').html(this.state);
			},
			update : function()
			{
				trace(this.updates);
				options = {};
				for (var i in this.updates) {
					track = this.updates[i].track;
					key = this.updates[i].key;
					val = this.updates[i].val || track[key];
					options[key] = val;
				}	
				options.title = track.title;
				options.track_id = track.id;
				save({file:'track/update',options:options});
			},

			throwError : throwError,
			embedded : embedded,
			connect : connect
		}	
		
	}({});
}(jQuery));