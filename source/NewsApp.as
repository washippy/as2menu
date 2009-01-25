/*	NewsApp.as:  
	
TO DO :	

get XML 
get total stories [NUM]
make empty movie clip [SCROLLER]

attach [NUM] stories {data}

draw each
update movieclip height
update scrollbar pos

on MORE CLICK; on LESS CLICK
TWEEN story
TWEEN other stories in relation to tweening story
 	update movie clip H
 	update scroller



SPANISH SWITCH

*/ 

import utils.XMLObject;
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;



class NewsApp extends MovieClip {

	private var XMLPATH:String="";
	private var news_xml:XML;
	private var nXml:Object;
	private var myXmlObject:XMLObject;
	private var newsApp:MovieClip;
	private var newsScroller:MovieClip;
	private var news_textmask_mc:MovieClip;
	private var itemArray:Array;
	//25 x 45
		private var FADEINDELAY:Number = 1.5; // seconds
		
		public var ready:Boolean=false;
	

	
	public function NewsApp(passmealong:String, clip:MovieClip){
		// trace("NEWS APP CONSTRUCTOR "+passmealong+clip);
		newsApp = clip.news_app_mc;
		//if (_global.lang == "SPANISH"){}else{}
		
		XMLPATH = "xml/"+passmealong;     
		//newsApp = clip.calendar_app_mc;
		BroadCaster.register(this,"updatePositions");
		BroadCaster.register(this,"updateScroller");

		newsScroller = newsApp.createEmptyMovieClip("newsScroller", this.getNextHighestDepth());
		newsScroller._x=17;
		newsScroller._y=45;
		clipStartY = 45;
		
		newsScroller.setMask(newsApp.news_textmask_mc);
	
		getNews();
	}
	
	private function getNews():Void{

		news_xml = new XML();
		news_xml.ignoreWhite = true;
		news_xml.load(XMLPATH); ////////////// add espANOL func later
		news_xml.onLoad = Delegate.create(this, onXmlLoad);
		
	}
	
	private function onXmlLoad($success:Boolean):Void{
			if ($success) {
			
		//	trace("load NEWS data :"+ $success+XMLPATH);
							
			myXmlObject = new XMLObject();
			nXml = myXmlObject.parseXML(news_xml);
			nXml = nXml.news;
			
			itemArray = news_xml.firstChild.childNodes;
			
			makeStories();
		
		} else {
			 // trace("load news data died "+ $success);
		}
		
	}
	
	private function makeStories():Void {
		totalStories = nXml.item.length;
		
		for(var i=0;i<totalStories;i++){
				//	trace("				MAKE STORIES :: "+totalStories)
			
				//	var _hObj:Object = nXml.item[i].attributes.headline;
				//	var _dObj:Object = nXml.item[i].attributes.date;
				//	var _bcObj:Object = nXml.item[i].data;
				//	var _lObj:Object = nXml.item[i].attributes.link;


			     /* 	trace("----------------"+newline+itemArray[i].childNodes[0].childNodes+
						newline+itemArray[i].childNodes[1].childNodes+
						newline+itemArray[i].childNodes[2].childNodes);	 */
				
				var sendCopy:String="";
		
				for(var b=0;b< itemArray[i].childNodes.length;b++){
				//	trace(itemArray[i].childNodes[b].toString());
					sendCopy = sendCopy+ itemArray[i].childNodes[b].toString();
				}
			//	trace("SEND >>> "+sendCopy)
				newsScroller.attachMovie("news_story_mc", "news_story_mc"+i, newsScroller.getNextHighestDepth(), {bCopy:sendCopy});
		

			//	newsScroller.attachMovie("news_story_mc", "news_story_mc"+i, newsScroller.getNextHighestDepth(), {headline:_hObj, date:_dObj, bodyCopy:_bcObj, link:_lObj});
				if(i>0){
					newsScroller["news_story_mc"+i]._y = newsScroller["news_story_mc"+(i-1)]._y +newsScroller["news_story_mc"+(i-1)]._height +10
				}
				
		}
	//	<item headline="HEADLINE HERE." date="FRIDAY, JULY 05, 2008" link="moreinfo.html">
	//	<![CDATA[Story here.]]></item>
		initScroll();

		// fade in moved to enable();
		this.ready=true;
		
	}
	
	private function updatePositions() {
		for(var i=1;i<totalStories;i++){
				newsScroller["news_story_mc"+i]._y = newsScroller["news_story_mc"+(i-1)]._y +newsScroller["news_story_mc"+(i-1)]._height +10;
			}
	}
	
	private function updateScroller() {
		
		fireupScroller();
	}
	
	
	
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
		
	
		
		// trace("SCROLL HEIGHT "+newsScroller._height)
		// trace("SCROLL channel HEIGHT "+ newsApp.news_scrollbar_mc.scrollchannel_mc._height)
		// trace("SCROLL scrubber HEIGHT "+newsApp.news_scrollbar_mc.scrollscrubber._height)
		
		var scrub:MovieClip = newsApp.news_scrollbar_mc.scrollscrubber;
		var clip:MovieClip = newsScroller;
		
	// 	clipStartY = 0;//newsScroller._y;
		
		var _cY = clipStartY; // local for the mouse listener
		var _cH = channelheight;// local for the mouse listener
		
		clipHeight = newsScroller._height + 100;  //100 is a buffer area
		
			//  get start pos of scrubber and adjust clip below
			scrubberStartY = newsApp.news_scrollbar_mc.scrollscrubber._y;
			startPct = scrub._y / channelheight;
		
		
		
		maskHeight= newsApp.news_textmask_mc._height;
		var clipScrollDist:Number = (clipHeight- maskHeight) +50;



		
		
		var scrollDist = scrubEndY - scrubStartY;
		
			// SET MC APPROPRIATELY TO SCRUB START DIST ...
			// this is for later when scroller is reset
		clip._y = clipStartY-(clipScrollDist * startPct);
			
			
			
	   	// trace("TEST channel height "+channelheight);
		
		
		mouseListener.onMouseMove = function() {
			// get the %Y of the scrubber
			// trace("TEST channel height "+_cH);
		   	
			var pct = scrub._y / _cH;
			// trace("moved "+ scrub._y +" :: "+_cH+ " :: "+pct);
		   	clip._y =_cY-(clipScrollDist * pct);
			// trace( _cY+"::"+clipScrollDist );
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
	
	public function disable():Void{
		// trace(newsApp);
		var invisify:Function = function(_ob:Object){
			trace("I I :"+_ob);
			_ob._visible=false;
			}
			
		Tweener.addTween(newsApp, {time:1, transition:"easeOut", _alpha:0, onComplete:invisify, onCompleteParams:[newsApp]});
		
	}
	
	public function enable(_reset:Boolean):Void{
		if(_reset){
				totalStories = nXml.item.length;
				for(var i=0;i<totalStories;i++){
						newsScroller["news_story_mc"+i].closeStory();
				}
		}
		newsApp._visible=true;
	//	Tweener.addTween(newsApp, {time:1, transition:"easeOut", _alpha:100});	
		Tweener.addTween(newsApp, {time:1.5, delay:FADEINDELAY, transition:"easeOut", _alpha:100});  /// fade in  news app
		
	}
	
}