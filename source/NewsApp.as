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
	//25 x 45

	public function NewsApp(passmealong:String, clip:MovieClip){
		 trace("NEWS APP CONSTRUCTOR "+this);
		if (_global.lang = "SPANISH"){
			
		}else{
			
		}
		
		XMLPATH = "xml/"+passmealong;     
		//newsApp = clip.calendar_app_mc;
		//BroadCaster.register(this,"setEvents");
		
		newsScroller = clip.news_app_mc.createEmptyMovieClip("newsScroller", this.getNextHighestDepth());
		var w:Number = 251;
		    var h:Number = 310;
		    newsScroller.beginFill(0x333333);
		    newsScroller.lineTo(w, 0);
		    newsScroller.lineTo(w, h);
		    newsScroller.lineTo(0, h);
		    newsScroller.lineTo(0, 0);
		    newsScroller.endFill();
		newsScroller._x=25;
		newsScroller._y=45
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
			
			trace("load NEWS data :"+ $success);
							
			myXmlObject = new XMLObject();
			nXml = myXmlObject.parseXML(news_xml);
			nXml = nXml.news;
			makeStories();
		
		} else {
			 trace("load news data died "+ $success);
		}
		
	}
	

	private function makeStories():Void {
		var totalStories = nXml.item.length;
		for(var i=0;i<totalStories;i++){
			trace("				MAKE STORIES :: "+newsScroller._y)
			
			var _hObj:Object = nXml.item[i].attributes.headline;
			var _dObj:Object = nXml.item[i].attributes.date;
			var _bcObj:Object = nXml.item[i].data;
			var _lObj:Object = nXml.item[i].attributes.link;
			
			
			
			newsScroller.attachMovie("news_story_mc", "news_story_mc"+i, newsScroller.getNextHighestDepth(), {headline:_hObj, date:_dObj, bodyCopy:_bcObj, link:_lObj});
			if(i>0){
				newsScroller["news_story_mc"+i]._y = newsScroller["news_story_mc"+(i-1)]._y +newsScroller["news_story_mc"+(i-1)]._height +10
			}
		}
	//	<item headline="HEADLINE HERE." date="FRIDAY, JULY 05, 2008" link="moreinfo.html">
	//	<![CDATA[Story here.]]></item>

		
	}
	







//////////////////////// old stuff 



/* 
		
		if(calApp.calscroller_mc.content_tf._height >=MASKHEIGHT){
			enableScroller(calApp.calscroller_mc.content_tf._height);
		}else{
			disableScroller();
		}
 */



	   
/*	
	private function disableScroller(){
		calApp.calscroller_mc.moreUP._visible=false;
		calApp.calscroller_mc.moreDOWN._visible=false;

		calApp.calscroller_mc.moreUP.enabled=false;
		calApp.calscroller_mc.moreDOWN.enabled=false;
		
	
		calApp.calscroller_mc.moreUP.onPress=function(){
		// nuthin
		};
			
		calApp.calscroller_mc.moreDOWN.	onPress=function(){
		// nuthin
						
		};
	}
	
	private function enableScroller(h:Number){
		//trace("scroller tf height = "+h);
		// mask height = 186
		writeScrollerEvents();		
	}
	
	private function shipIt(){
		//trace("SHIPPED");
		BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
	}
	
	private function writeScrollerEvents(){
	//	trace(calApp.calscroller_mc.content_tf._height);
	//	trace(calApp.calscroller_mc.content_tf._y);
		//trace("WSE ::::::::::::::::");
		
		// MASKHEIGHT = 186
		
		//if the Y of the tf is near start y  - height 
		var tf = calApp.calscroller_mc.content_tf._y;
		//trace("tf Y: "+tf)
		var topY = 14 -calApp.calscroller_mc.content_tf._height;
		//trace("topY: "+topY)
		var bottomY =  14;
		//trace("bottomY: "+bottomY)
		var deltaTOP = tf+Math.abs(topY);
		//trace("delta top :"+deltaTOP);
		
		var deltaBTM = Math.abs(bottomY-tf);
		//trace("delta bottom :"+deltaBTM);
		
		
		
		if(tf > topY && tf < bottomY){
			// enable both
			//trace("A")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
			//	this._parent.content_tf._y-=10;
		////	if delta top is greater than 100, use 100,  else use delta top
				Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y-100, onCompleteEvent:calApp.shipIt});
			//	BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
				
			};
				
			calApp.calscroller_mc.moreDOWN.onPress=function(){
				////	if delta bottom is less than 100 use delta bottom else use 100
				Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y+100, onCompleteEvent:calApp.shipIt});							
			};
			
			
		}else if(tf > topY && tf >= bottomY){
			//disable DOWN
			//enable UP
			//trace("B")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=false;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=50;
	
			calApp.calscroller_mc.moreUP.onPress=function(){
			//	this._parent.content_tf._y-=10;
	
			Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y-100, onCompleteEvent:shipIt});	
			//	BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
			//	this._parent.content_tf._y+=10;					
			};
			
		}else if(tf <= topY && tf < bottomY){
			//disable UP
			//enable DOWN
			//trace("C")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=false;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=50;
			calApp.calscroller_mc.moreDOWN._alpha=100;
		
			calApp.calscroller_mc.moreUP.onPress=function(){
				//this._parent.content_tf._y-=10;
				Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y-100, onCompleteEvent:shipIt});
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
			//	this._parent.content_tf._y+=10;
			Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y+100, onCompleteEvent:shipIt});
				//BroadCaster.broadcastEvent("writeScrollerEvents", this, false);						
			};
				
		}
	}


*/	
	}