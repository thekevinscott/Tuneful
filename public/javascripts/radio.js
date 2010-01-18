$(function($){
	tuneful.radio = function() {
		
		playerid = 'player';			// our default name, 99% chance this will never change
		embedded = true;
		player = null;
		
		playlist = [];
		station = null;
		state = 'IDLE';
		index = 0;
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
		
		
		throwError = function(msg) { trace('Radio JS: '); trace(msg); };
		
		
		connect = function(options) {
			if (options) {
				if (options.playlist && options.playlist.tracks) {
					for (var i in options.playlist.tracks) { playlist.push(options.playlist.tracks[i]); }
				} else { this.throwError('No playlist provided.'); }
				
				
				if (options.station && options.station.title && options.station.url) {
					station = options.station; 
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
				
			} else { this.throwError('You must provide an initial argument object to the Connect function.'); }
		};
		
		play = function() {
			// do we have a playlist?
			index = 0;
			if (playlist&&playlist.length>0) {
				
				if (state!='Playing') {	// start playing
					start = playlist[index].start || 0;
					player.loadVideoById(playlist[index].url,start);
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
				$('#track-title').html(track.title);
				$('#track-artist').html(track.artist);
				$('#track-album').html(track.album);
			}
		};

		
		loadNext = function() {
			trace('load next');
			url = window.location.pathname;
			var self = this;
			$.getJSON(url,{next:true},function(data){
				index = self.playlist.push(data.tracks[0]) - 1;
				trace(data);
				trace(data.servertime);
				trace('we should set the above, in radio js (line 90)');
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
				//console.log('on state change');
				
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
				console.log(this.state);
			},

			onError : function(error) {
				this.updateVideoLink();
			},

			play : play,

			next : function() {		
				console.log('next');		
				//this.playing = false;
				radio.playlist.shift();
				this.play();
				if (! this.muted) {	$('#radio-state').html(this.state);	}
			},

/*
			setupControls : function() {
				if (! this.embedded) { this.keyListeners(); }
				this.radioControls();
				$('#station-logo').click(function(){window.open('station.php','Station');});
				//trace('I have arrived');
				$('#buy #hide-links').click(function(){
					if ($(this).hasClass('hidden')) {
						$(this).removeClass('hidden');
						$('#buy .button').show();
						$(this).html('Hide links');
					} else {
						$(this).addClass('hidden');
						$('#buy .button').hide();
						$(this).html('Show buy links');
					}
				});
			},
			radioControls : function() {
				self = this;
				$('#radio-controls a').each(function(i,idx){
					$(this).click(function(){
						action = $(this).attr('id');
						switch(action) {
							case 'thumb-up' : case 'thumb-down' :
								self.thumb(this);
							break;
						}
					});
				}).hover(function(){
						$(this).parent().find('.help').html($(this).attr('title'));
					},function(){
						$(this).parent().find('.help').html('');
					});
			},

			keyListeners : function() {
				var self = this;
				$(document).keydown(function(e){
					key = e.keyCode;
					switch(key) {

						case 32 : 	// space
							//self.playPause();
							self.volume('toggle');
						break;
						case 38 :
							self.thumb('up');
						break;
						case 40 :
							self.thumb('down');
						break;
						case 61 : case 107 :
							self.volume('up');
						break;
						case 109 :
							self.volume('down');
						break;
					}
				})
			},
			thumb : function(obj) {
				cssOff = {opacity:0.3}; cssOn = {opacity:1.0};
				if (typeof(obj)=='string'){obj = $('#radio-thumbs a#thumb-'+obj);}
				dir = $(obj).attr('id').split('-').pop();
				trace(dir);
				$("#radio-thumbs a").unbind('mouseenter mouseleave').css(cssOn);  
				$('#radio-thumbs .help').css({color:'#333333'}).html($(obj).attr('title'));

				if (dir=='up') { anti = 'down' } else { anti = 'up'; }
				$('#radio-thumbs a#thumb-'+anti).css(cssOff).hover(function(){$(this).css(cssOn)},function(){$(this).css(cssOff)});
			},
			resetThumbs : function() {
				$('.help').html('').css({color:'#999'});
				$('#radio-thumbs a').css({opacity:1.0});
			},
			volume : function(dir) {
				if (dir=='toggle') {
					if (this.muted) {
						this.on();
					} else {
						this.off();
					}
				}
				trace('volumne '+dir);
			},
			on : function() {
				this.muted = false;
				$('#radio-state').html(this.state);
				if (this.player) { this.player.unMute(); }
			},
			off : function() {
				this.muted = true;
				$('#radio-state').html('OFF');
				if (this.player) { this.player.mute(); }
			},
			close : function() {
				$(this.player).remove();
				$('#radio').slideUp();
			},*/
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
				save({url:'track/update',options:options});
			},

			throwError : throwError,
			embedded : embedded,
			connect : connect
		}	
		
	}({});
}(jQuery));