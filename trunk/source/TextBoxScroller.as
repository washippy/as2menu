

///////// scroller stuff //////// 
private var channelheight:Number;
private var scrubheight:Number;

private var maskHeight:Number;
private var clipHeight:Number;
private var clipStartY:Number;
private var scrubX:Number;
private var scrubStartY:Number;
private var scrubEndY:Number;
private var totalStories:Number;
private var startPct:Number;
private var scrubberStartY:Number;
private var mouseListener:Object = new Object();

private function initScroll(){
	var scrub:MovieClip = newsApp.news_scrollbar_mc.scrollscrubber;
	
	//// these are set for the startDrag args //////
	scrubStartY = scrub._y;
	
	channelheight = newsApp.news_scrollbar_mc.scrollchannel_mc._height;
	var _cH = channelheight;// local for the mouse listener
	
	scrubheight = scrub._height;
	scrubEndY = scrub._y + (channelheight - scrubheight);
	scrubX = scrub._x;
	
	////////////////////////////////////////////
	fireupScroller();
}

private function fireupScroller(){
	

	
	trace("SCROLL HEIGHT "+newsScroller._height)
	trace("SCROLL channel HEIGHT "+ newsApp.news_scrollbar_mc.scrollchannel_mc._height)
	trace("SCROLL scrubber HEIGHT "+newsApp.news_scrollbar_mc.scrollscrubber._height)
	
	var scrub:MovieClip = newsApp.news_scrollbar_mc.scrollscrubber;
	var clip:MovieClip = newsScroller;
	
// 	clipStartY = 0;//newsScroller._y;
	
	var _cY = clipStartY; // local for the mouse listener
	var _cH = channelheight;// local for the mouse listener
	
	clipHeight = newsScroller._height;
	
		//  get start pos of scrubber and adjust clip below
		scrubberStartY = newsApp.news_scrollbar_mc.scrollscrubber._y;
		startPct = scrub._y / channelheight;
	
	
	
	maskHeight= newsApp.news_textmask_mc._height;
	var clipScrollDist:Number = (clipHeight- maskHeight) +50;



	
	
	var scrollDist = scrubEndY - scrubStartY;
	
		// SET MC APPROPRIATELY TO SCRUB START DIST ...
		// this is for later when scroller is reset
	clip._y = clipStartY-(clipScrollDist * startPct);
		
		
		
   	trace("TEST channel height "+channelheight);
	
	
	mouseListener.onMouseMove = function() {
		// get the %Y of the scrubber
		trace("TEST channel height "+_cH);
	   	
		var pct = scrub._y / _cH;
		trace("moved "+ scrub._y +" :: "+_cH+ " :: "+pct);
	   	clip._y =_cY-(clipScrollDist * pct);
		trace( _cY+"::"+clipScrollDist );
		// set the %Y of the scrollable clip to the % Y of the scrubber
	    updateAfterEvent();
	};
	
	
	scrub.onPress = Delegate.create(this, sDrag);
	scrub.onRelease = scrub.onReleaseOutside = Delegate.create(this, sDragStop);
	
		
}

private function sDrag(){
	newsApp.news_scrollbar_mc.scrollscrubber.startDrag(false, scrubX, scrubStartY, scrubX, scrubEndY);
	Mouse.addListener(mouseListener);
	
}

private function sDragStop(){
	newsApp.news_scrollbar_mc.scrollscrubber.stopDrag();
	Mouse.removeListener(mouseListener);
	
}