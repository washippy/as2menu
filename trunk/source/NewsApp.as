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
	
	private var scrubX:Number;
	private var scrubStartY:Number;
	private var scrubEndY:Number;
	private var totalStories:Number;

	private var mouseListener:Object = new Object();
	
	
	public function NewsApp(passmealong:String, clip:MovieClip){
		// trace("NEWS APP CONSTRUCTOR "+passmealong+clip);
		newsApp = clip.news_app_mc;
		//if (_global.lang = "SPANISH"){}else{}
		
		XMLPATH = "xml/"+passmealong;     
		//newsApp = clip.calendar_app_mc;
		BroadCaster.register(this,"updatePositions");
		
		newsScroller = newsApp.createEmptyMovieClip("newsScroller", this.getNextHighestDepth());
		newsScroller._x=25;
		newsScroller._y=45;
	//	newsScroller.setMask(newsApp.news_textmask_mc);
	
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
			 trace("load news data died "+ $success);
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
				trace("SEND >>> "+sendCopy)
				newsScroller.attachMovie("news_story_mc", "news_story_mc"+i, newsScroller.getNextHighestDepth(), {bCopy:sendCopy});
		

			//	newsScroller.attachMovie("news_story_mc", "news_story_mc"+i, newsScroller.getNextHighestDepth(), {headline:_hObj, date:_dObj, bodyCopy:_bcObj, link:_lObj});
				if(i>0){
					newsScroller["news_story_mc"+i]._y = newsScroller["news_story_mc"+(i-1)]._y +newsScroller["news_story_mc"+(i-1)]._height +10
				}
				
		}
	//	<item headline="HEADLINE HERE." date="FRIDAY, JULY 05, 2008" link="moreinfo.html">
	//	<![CDATA[Story here.]]></item>
		initScroll();
		
	}
	private function updatePositions() {
		for(var i=1;i<totalStories;i++){
				newsScroller["news_story_mc"+i]._y = newsScroller["news_story_mc"+(i-1)]._y +newsScroller["news_story_mc"+(i-1)]._height +10;
			}
	}
	
	
	
	private function initScroll(){
		trace("SCROLL HEIGHT "+newsScroller._height)
		trace("SCROLL channel HEIGHT "+ newsApp.news_scrollbar_mc.scrollchannel_mc._height)
		trace("SCROLL scrubber HEIGHT "+newsApp.news_scrollbar_mc.scrollscrubber._height)
		Tweener.addTween(newsApp, {time:1.5, delay:2, transition:"easeOut", _alpha:100});  /// fade in  news app
		
		var scrub:MovieClip = newsApp.news_scrollbar_mc.scrollscrubber;
		var clip:MovieClip = newsScroller;
		var clipStartY = newsScroller._y;
		var clipHeight = newsScroller._height;
		
		var maskHeight= newsApp.news_textmask_mc._height;
		var clipScrollDist:Number = (clipHeight- maskHeight) +50;

		scrubStartY = scrub._y;
		var channelheight:Number = newsApp.news_scrollbar_mc.scrollchannel_mc._height;
		var scrubheight:Number = scrub._height;
		scrubEndY = scrub._y + (channelheight - scrubheight);
		scrubX = scrub._x;
		
		var scrollDist = scrubEndY - scrubStartY;
		
		mouseListener.onMouseMove = function() {
			// get the %Y of the scrubber
			var pct = scrub._y / channelheight;
			trace("moved "+ scrub._y+" :: "+channelheight+ " :: "+pct);
		   	clip._y =clipStartY-(clipScrollDist * pct);
			trace( clipScrollDist );
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
	
	/* 

			function disableInfoScrollers() {
				this.indicator_mc._y = INDICATOR_START_Y;
				this.textblock_mc._y = TEXTBOX_START_Y;
				this.indicator_mc._visible = false;
				this.uparrow_mc._visible = false;
				this.downarrow_mc._visible = false;
			}
			function enableInfoScrollers(z) {
				trace("HEY FOO ITS :"+z+" "+this);
				this.indicator_mc._y = INDICATOR_START_Y;
				this.textblock_mc._y = TEXTBOX_START_Y;
				this.indicator_mc._visible = true;
				this.uparrow_mc._visible = true;
				this.downarrow_mc._visible = true;
				textboxend = this.textblock_mc._height;
				textboxdestination = (this.textMask_mc._y+this.textMask_mc._height)-10;
				trace("end "+textboxend);
				trace("dest "+textboxdestination);
				diffH = (-(textboxend-textboxdestination)/INDICATOR_DIST);
				trace("diffH : "+diffH);
			}
			function scrollBar(dir, y) {
				switch (dir) {
				case "up" :
					if (y != undefined && y != null) {
						if (this.indicator_mc._y>(16+y)) {
							this.indicator_mc._y -= y;
							this.textblock_mc._y -= diffH*y;
						}else{
						this.indicator_mc._y=INDICATOR_START_Y;
						}
					} else {
						if (this.indicator_mc._y>16) {
							this.indicator_mc._y--;
							this.textblock_mc._y -= diffH;
						}
					}
					break;
				case "down" :
					if (y != undefined && y != null) {
						if (this.indicator_mc._y<(INDICATOR_DIST-y)) {
							this.indicator_mc._y += y;
							this.textblock_mc._y += diffH*y;
						}else{
						this.indicator_mc._y=INDICATOR_DIST;
						}
					} else {
						if (this.indicator_mc._y<INDICATOR_DIST) {
							this.indicator_mc._y++;
							this.textblock_mc._y += diffH;
						}
					}
					break;
				case "indicator" :
					trace("IND eeeeeeeeeeeeeeeee "+this.indicator_mc._y+"  :  "+this.textblock_mc._y);
					this.textblock_mc._y = ((this.indicator_mc._y-16)*diffH)-16;
					break;
				}
			}	
	 
	*/

	
}