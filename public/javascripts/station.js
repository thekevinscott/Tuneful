$(function($){
	tuneful.station = function() {
		searchWaitTime = 300;
		addSongSearchInterval = '';
		oldSearch = '';
		numberOfResults = 15;
		station = {title: "60's Rock",url:'60s_rock'}
		errorText = "Hmm, there was a strange error. Sorry about that; Tuneful is a work in progress. We've been notified. Please try again later.";
		
		addSong = function() {
			$('#add-song input#search').keyup(function(){
				if ($(this).val() && oldSearch != $(this).val()) { 
					if (addSongSearchInterval) { clearInterval(addSongSearchInterval); }
					input = this;
					addSongSearchInterval = setTimeout(function(){
						$('#search-results').loading();
						tuneful.queryLastFM({options:{method:'track.search',track:$(input).val()}},function(data){
							processSongResults(data);
						});
					},searchWaitTime);
					oldSearch = $(this).val();
				}
			});
		}
		processSongResults = function(data) {
			str = '';
			if (data&&data.results&&data.results.trackmatches&&data.results.trackmatches.track) {
				num = (numberOfResults <= data.results.trackmatches.track.length) ? numberOfResults : data.results.trackmatches.track.length;
				
				buildTracks = function(track) {
					return '<li><a href="#" rel="{id:'+i+',artist:'+track.artist+',track:'+track.name+'}" >'+track.name+' / '+track.artist+'</a></li>';
				}
				
				if (data.results.trackmatches.track[0]) {
					for (var i=0;i<numberOfResults;i++) {
						str += buildTracks(data.results.trackmatches.track[i]);
					}
				} else {	
					str += buildTracks(data.results.trackmatches.track);					
				}
				$('#search-results').html(str);
			

				$('#search-results a').click(function(e){
					rel = $.toObj($(this).attr('rel'));
					trace(rel);

					$('#add-song').transition("Adding "+rel.track+" by "+rel.artist+" to "+station.title+"<br /><img src='images/loading.gif' />");
					var functionCount = setTimeout(function(){
						throwError($('#add-song'),{
							'problem':'timeout',
							'function':'search-results a click',
							'message':'no response from server for adding new track',
							'track':rel.track,
							'artist':rel.artist,
							'station':station.url,
							'time':Date.now()});
					},5000); // 5 seconds to let it happen
					
					
					$.post('station/'+station.url+'/add_song',{track:rel.track,artist:rel.artist},function(data){
						clearTimeout(functionCount);
						trace(data);
						if (! data.error && $('#search-results').html()!=errorText) {
							$('#add-song').html("Success! "+rel.track+" by "+rel.artist+" has been added to 60's Rock. Enjoy.");
							/*
							setTimeout(function(){
								$.fn.fancybox.close();
							},4000);*/
						} else {
							trace(throwError);				
							throwError($('#add-song'),{
								'problem':'data error',
								'function':'search-results a click, post response',
								'message':'there was a problem with the data passed back from the server',
								'track':rel.track,
								'artist':rel.artist,
								'station':station.url,
								'data':data});
						}
					},'json');
				});
				
			} else {			
				throwError($('#search-results'),{
					'problem':'data error',
					'function':'processSongResults',
					'message':'there was a problem with the data passed back from last.fm ',
					'station':station.url,
					'data':data});
			}
			
		};
		
		return {
			addSong : addSong,
			processSongResults : processSongResults,
		}	
		
	}({});
}(jQuery));