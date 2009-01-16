/*	SubPageApp.as:  
	
	make a MAIN XML STRUCTURE file with the site structure in it as nodes
	build the navs based on that with names matching XML filenames full of data
	
GALLERY / TEXT
MAIN NAV
SUB NAV
SPANISH SWITCH


MANAGE SUB NAVS

see comps


FIX
loadASubSection




*/ 

import utils.XMLObject;
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;
import StructureApp;
import menuList;
import TextField.StyleSheet;



class SubPageApp extends MovieClip {

	private var XMLPATH:String="";
	private var subpage_xml:XML;
		private var subsect_xml:XML;
	private var sXml:Object;
	private var mySubXmlObject:XMLObject;

	private var sSubXml:Object;
	private var myXmlObject:XMLObject;
	private var subpage1_mc:MovieClip;
	private var menuholder_mc:MovieClip;
	
	private var ML:menuList;
	
	private var MLArray:Array;
	private var MLArray_esp:Array;
	
	private var TL:menuListHoriz;
	private var TLArray:Array;
	private var TLArray_esp:Array;
	private var thirdmenuholder_mc:MovieClip;
		
	private var _galleryEnabled:Boolean;		
	private var	galleryArray:Array;
	private var empty_mc:MovieClip;
	//private var larger_mc:MovieClip;

	private var gn:GalleryNav;

	private var TEXTFIELDMASKHEIGHT = 310; // hardcoded


	private var ANIM_ENDPOINT:Number;
	private var ANIM_STARTPOINT:Number;
	
	private var dataObj:Object;
	
	private var styles:StyleSheet;
	
	public function SubPageApp(clip:MovieClip){
		 trace("SUBPAGE APP CONSTRUCTOR ");
		// trace(" HEY SUBPAGE   ::: "+StructureApp.getInstance().getPath()); 	
		BroadCaster.register(this,"loadASubPage");
		BroadCaster.register(this,"loadASubSection");
		
		subpage1_mc = clip.subpage1;
		ANIM_ENDPOINT = subpage1_mc._y;
		ANIM_STARTPOINT = subpage1_mc._y +40;
		subpage1_mc._y = ANIM_STARTPOINT;
		
		MLArray = new Array();
		MLArray_esp = new Array();
		TLArray = new Array();
		TLArray_esp = new Array();
		
		
		
			
		galleryArray = new Array();
		
		
		styles = new TextField.StyleSheet();
	

		styles.setStyle(".subhead", {
		    color:'#7A192F',
			fontFamily:'Univers 67 CondensedBold', 
		    fontSize:'12'
		});
		styles.setStyle(".ital", {
			fontFamily:'Univers 45 LightOblique'
		});
			
		styles.setStyle("a:link", {
		    color:'#7A192F'
		});
		styles.setStyle("a:hover", {
		    textDecoration:'underline'
		});
					 
		

			
		//////////////  WAIT PATIENTLY ////////////////
		
	}
	
	public function loadASubPage(_pagename:String):Void{
		// use page name to get data
		// trace("L A S P :: "+subpage1_mc);
		Tweener.removeTweens(subpage1_mc);
		
		subpage1_mc._alpha=0;
		subpage1_mc._y=ANIM_ENDPOINT;//ANIM_STARTPOINT; I BAILED ON THE SLIDE IN ANIM FOR NOW
		
		dataObj = new Object();
		// trace("DANGIT "+_pagename);//StructureApp.getInstance().getArrayData(_pagename));
		var bob:String = _pagename;
		StructureApp.getInstance().setArrayData(_pagename); 
		
		dataObj = StructureApp.getInstance().getArrayData(); 
		
			if (_global.lang == "SPANISH"){
				var _lang:String = "_esp";
			}else{
				var _lang:String = "";
			}	
			
		
		XMLPATH = "xml/"+dataObj.name+ _lang +".xml";   
		getXMLData();
		
			// GALLERY ENABLED
		// trace("HEY HERE IT IS :::::::::::::::::::::::::: "+dataObj.galleryenabled);
		
		_galleryEnabled = dataObj.galleryenabled;
		
		
		if(dataObj.subnav_item_array != undefined){
		
			buildSubNav();
		} else{
				MLArray = [];
				MLArray_esp = [];
			ML.disable();
		}
	}
	
	public function loadASubSection(stuff:Object):Void{
		// use page name to get data
	//	var _obj:Object = new Object();
	//	_obj.pageName = _pagename;
	//	_obj.nameNum = nameNum;
		// trace("L A S Section :: "+stuff.nameNum);
			Tweener.removeTweens(subpage1_mc);
			
			//subpage1_mc._alpha=0;
		//	subpage1_mc._y=ANIM_STARTPOINT;
			
			dataObj = new Object(); 
	

	
			// trace("DANGIT "+stuff.pageName);//StructureApp.getInstance().getArrayData(_pagename));
	//	var bob:String = _pagename;
	//	StructureApp.getInstance().setArrayData(stuff.pageName); 
		
	
			dataObj = StructureApp.getInstance().getThirdNavArrayData(stuff.nameNum); 
			
				if (_global.lang == "SPANISH"){
					var _lang:String = "_esp";
				}else{
					var _lang:String = "";
				}	
			
			XMLPATH = "xml/"+dataObj.attributes.name+ _lang +".xml";   
			getSubSectionXMLData(); 

		// trace("LOL _-_-______------_-_--_-_-_-_- "+dataObj.subnav)
	 
		if(dataObj.subnav != undefined){ // change this to the item array
				buildThirdNav();
			} else{
					TLArray = [];
					TLArray_esp = [];
				TL.disable();
			} 
			
	}
	
	private function buildSubNav():Void{

			MLArray = [];
			MLArray_esp = [];
		
	//	trace("-----------------------+++++++++  "+dataObj.subnav_item_array[i].attributes.eng);
		var aLen = dataObj.subnav_item_array.length;
		
	/* 
		for(var xx=0;xx<aLen;xx++){
				// trace("XXXXX  :: "+dataObj.subnav_item_array[xx].attributes.eng)
			} 
	*/
		
		for(var i:Number = 0; i<aLen; i++){
			MLArray.push({
						name:dataObj.subnav_item_array[i].attributes.name,
						title:dataObj.subnav_item_array[i].attributes.eng
						});
			MLArray_esp.push({
						name:dataObj.subnav_item_array[i].attributes.name,
						title:dataObj.subnav_item_array[i].attributes.esp
						});
			
		}
	}
	
	private function buildThirdNav():Void{
		trace("BUILD THIRD NAV");

			TLArray = [];
			TLArray_esp = [];
		
	//	trace("-----------------------+++++++++  "+dataObj.subnav_item_array[i].attributes.eng);
		var aLen = dataObj.subnav.length;
		
	
	 
		for(var xx=0;xx<aLen;xx++){
					// trace("XXXXX  :: "+dataObj.subnav[xx].attributes.eng)
				} 
		 
	


	 
		for(var i:Number = 0; i<aLen; i++){
				TLArray.push({
							link:dataObj.subnav[i].attributes.link,
							title:dataObj.subnav[i].attributes.eng
							});
							
				TLArray_esp.push({
							link:dataObj.subnav[i].attributes.link,
							title:dataObj.subnav[i].attributes.esp
							});
			} 
		
		// if theres a third nav, launch it
		if (_global.lang == "SPANISH"){
				TL = new menuListHoriz(TLArray_esp, subpage1_mc.thirdmenuholder_mc);
			}else{
				TL = new menuListHoriz(TLArray, subpage1_mc.thirdmenuholder_mc); 
			}
	
	
	}
	
	private function getXMLData():Void{
		// maybe cal_xml = null; ??
		// trace("getting X1"+ XMLPATH)
		subpage_xml = new XML();
		subpage_xml.ignoreWhite = true;
		subpage_xml.load(XMLPATH); 

		subpage_xml.onLoad = Delegate.create(this, onXmlLoad);
		
	}
	
	private function onXmlLoad($success:Boolean):Void{
			if ($success) {
			
				// trace("load subpage data :"+ $success);
							
				myXmlObject = new XMLObject();
				sXml = myXmlObject.parseXML(subpage_xml);
			
			} else {
				 // trace("load data died "+ $success);
			}
		fireitupman();
	}
	
	private function fireitupman():Void{
		disable();
		// trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+ML)
		if (_global.lang == "SPANISH"){
		/* 
			
					
					Create another class like below, this will make another connection to the singleton 
					class, now if you use the standard way of connecting to another class you would use 
					the ‘new’ keyword like so: 
					var foo:Singleton = new Singleton(); 
					The above call will create a new instance and therefore return 0 the default value set 
					in the singleton class. So to retrieve the amount stored in the class you use: 
					Singleton.getInstance().getAmount(); 
					Of course you must remember to import the file for this method to work. 
					The caller class uses this Singleton pattern.
					
					 
		*/

				menuList.getInstance().init(MLArray_esp, subpage1_mc.menuholder_mc, "right");
		
			//	ML = new menuList(MLArray_esp, subpage1_mc.menuholder_mc, "right"); // justify right or left
			}else{
			//	ML = new menuList(MLArray, subpage1_mc.menuholder_mc, "right"); // justify right or left
				menuList.getInstance().init(MLArray, subpage1_mc.menuholder_mc, "right");
			}
		
		popData();
	}
	
	private function popData(){
		// bCopy = bCopy+ itemArray[i].childNodes[b].toString();
		
		//if its a GALLERY hop outta here
			// trace("_galleryEnabled" +_galleryEnabled)
				
		
//		trace(subpage1_mc);
		subpage1_mc.header_tf.text = sXml.main.item.headline.data;
		_global.mainImagePath =  sXml.main.item.attributes.swfName;
		BroadCaster.broadcastEvent("reloadMainImage");
		if(_galleryEnabled=="true"){
			subpage1_mc.subpagestroke_mc._alpha=0;
			buildGallery();  // GO GO GADGET GALLERY!
			subpage1_mc.bodycopy_tf_mc.bodycopy_tf.htmlText = "";
		}else{
		//	image_mcl.unloadClip(subpage1_mc.empty_mc);
		    subpage1_mc.subpagestroke_mc._alpha=100;
		//disable gallery
			gn.disable();
			subpage1_mc.bodycopy_tf_mc.bodycopy_tf.styleSheet = styles;
			subpage1_mc.bodycopy_tf_mc.bodycopy_tf.htmlText = sXml.main.item.copy.data;
			subpage1_mc.bodycopy_tf_mc.bodycopy_tf.autoSize = true;
			
			trace("TEXT FIELD HEIGHT "+ subpage1_mc.bodycopy_tf_mc.bodycopy_tf._height +"<------- - - - - - -  - -"+TEXTFIELDMASKHEIGHT);	
			var tfh = subpage1_mc.bodycopy_tf_mc.bodycopy_tf._height;
			

			//	test for scroller
			if(tfh > TEXTFIELDMASKHEIGHT){
				trace("SCROLL ON")
				disablescroller();
				initScroll();
			}else{
				trace("SCROLL ON")
				
				disablescroller();
			}
				
		}
		

		
	//	Tweener.addTween(subpage1_mc, {_alpha:100, _y:ANIM_ENDPOINT, delay:.5, time:1.1, transition:"easeOut"});
		Tweener.addTween(subpage1_mc, {_alpha:100, delay:.5, time:1.1, transition:"easeOut"});


	}
	

	
	private function buildGallery():Void{
		galleryArray=[];
		var gLen =  sXml.main.pic.length;	
		for(var i=0;i<=(gLen-1);i++){
			// trace("." +sXml.main.pic[i].attributes.filename);
		
			galleryArray.push({
				filename:sXml.main.pic[i].attributes.filename,
				picdate:sXml.main.pic[i].attributes.date,
				caption:sXml.main.pic[i].attributes.caption
			});	
		}
		
		trace("GALLERY : "+subpage1_mc.galleryNav);
		//image_mcl.loadClip(galleryArray[0].filename, subpage1_mc.empty_mc);
		if(gn){
			delete gn;//.init(galleryArray, subpage1_mc.galleryNav);
		}
			gn = new GalleryNav(galleryArray, subpage1_mc.galleryNav);
		
	}	
			
//// subnav

	private function getSubSectionXMLData():Void{
		// maybe cal_xml = null; ??
		// trace("getting X2  "+ XMLPATH);
		subsect_xml = new XML();
		subsect_xml.ignoreWhite = true;
		subsect_xml.load(XMLPATH); 

		subsect_xml.onLoad = Delegate.create(this, onSubXmlLoad);
	
	}
	
	private function onSubXmlLoad($success:Boolean):Void{		
		
			if ($success) {
			
				// trace("load supbage data :"+$success);
							
				mySubXmlObject = new XMLObject();
				sSubXml = myXmlObject.parseXML(subsect_xml);
			
			} else {
				 // trace("load data died "+ $success);
			}
		popSubData();
	}

	private function popSubData(){
		// bCopy = bCopy+ itemArray[i].childNodes[b].toString();
		 trace("POP sub data "+sSubXml.main.item.headline.data);
		subpage1_mc.header_tf.text = sSubXml.main.item.headline.data;
		_global.mainImagePath =  sSubXml.main.item.attributes.swfName;
		BroadCaster.broadcastEvent("reloadMainImage");
		
		subpage1_mc.bodycopy_tf_mc.bodycopy_tf.htmlText = sSubXml.main.item.copy.data;
		subpage1_mc.bodycopy_tf_mc.bodycopy_tf.autoSize = "left";
		
		var tfh = subpage1_mc.bodycopy_tf_mc.bodycopy_tf._height;
		
		trace("TEXT FIELD HEIGHT [sub]"+ subpage1_mc.bodycopy_tf_mc.bodycopy_tf._height +"<------- - - - - - -  - -");	

		//	test for scroller
		if(tfh > TEXTFIELDMASKHEIGHT){
			disablescroller();
			initScroll();
		
		}else{
			disablescroller();
		}
		
		
	//	Tweener.addTween(subpage1_mc, {_alpha:100, _y:ANIM_ENDPOINT, delay:.5, time:1.1, transition:"easeOut"});
		Tweener.addTween(subpage1_mc, {_alpha:100, delay:.5, time:1.1, transition:"easeOut"});
		

		
	}
	


	
	//////////////////////////////////
	// 		   SCROLLER JUNK		//
	//////////////////////////////////
	
	
	///////// scroller stuff //////// 
	private var channelheight:Number;
	private var scrubheight:Number;
	private var maskHeight:Number;
	private var clipHeight:Number;
	private var clipStartY:Number;
	private var scrubX:Number;
	private var scrubStartY:Number;
	private var scrubEndY:Number;
	private var startPct:Number;
	private var scrubberStartY:Number;
	private var mouseListener:Object = new Object();
	
	private function initScroll(){
		trace("SCROLLER INIT")
		subpage1_mc.subpage_scroller._alpha=100;
		var scrub:MovieClip = subpage1_mc.subpage_scroller.scrollscrubber;
		//// these are set for the startDrag args //////
		scrubStartY = 0;//scrub._y;

		channelheight = subpage1_mc.subpage_scroller.scrollchannel_mc._height;
		var _cH = channelheight;// local for the mouse listener

		scrubheight = scrub._height;
		scrubEndY = scrub._y + (channelheight - scrubheight);
		scrubX = scrub._x;

		////////////////////////////////////////////
		fireupScroller();
	}

	private function fireupScroller(){

		trace("SCROLL HEIGHT "+subpage1_mc.bodycopy_tf_mc.bodycopy_tf._height)
		trace("SCROLL channel HEIGHT "+ subpage1_mc.subpage_scroller.scrollchannel_mc._height)
		trace("SCROLL scrubber HEIGHT "+subpage1_mc.subpage_scroller.scrollscrubber._height)

		var scrub:MovieClip = subpage1_mc.subpage_scroller.scrollscrubber;
		var clip:MovieClip = subpage1_mc.bodycopy_tf_mc;

	 	clipStartY = subpage1_mc.bodycopy_tf_mc._y;

		var _cY = clipStartY; // local for the mouse listener
		var _cH = channelheight;// local for the mouse listener

		clipHeight = subpage1_mc.bodycopy_tf_mc.bodycopy_tf._height + 100;  //100 is a buffer area

			//  get start pos of scrubber and adjust clip below
		//	scrubberStartY = subpage1_mc.subpage_scroller.scrollscrubber._y;
			startPct = scrub._y / channelheight;



		maskHeight= TEXTFIELDMASKHEIGHT;//newsApp.news_textmask_mc._height;
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
		subpage1_mc.subpage_scroller.scrollscrubber.startDrag(false, scrubX, scrubStartY, scrubX, scrubEndY);
		Mouse.addListener(mouseListener);

	}

	private function sDragStop(){
		subpage1_mc.subpage_scroller.scrollscrubber.stopDrag();
		Mouse.removeListener(mouseListener);

	}
	
	private function disablescroller(){
		trace("DIS SCROLLER");
		
		delete subpage1_mc.subpage_scroller.scrollscrubber.onPress;
		delete subpage1_mc.subpage_scroller.scrollscrubber.onRelease 
		delete subpage1_mc.subpage_scroller.scrollscrubber.onReleaseOutsidefs;

		subpage1_mc.bodycopy_tf_mc._y=111;
		subpage1_mc.subpage_scroller.scrollscrubber._y=0;
		subpage1_mc.subpage_scroller._alpha=0;
	}

	
	
	//////////////////////////////////
	//////////////////////////////////

	public function disable():Void{ 
		// trace("sub page disable -->");
		Tweener.addTween(subpage1_mc, {_alpha:0, _y:ANIM_ENDPOINT, time:0.25, transition:"easeOut"});//ANIM_STARTPOINT
	//	ML.disable(); // didnt work
		TL.disable();
		menuList.getInstance().disable();	
		gn.disable();
		
	}
	
	
	
	

}