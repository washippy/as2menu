/*	SubPageApp.as:  
	
	make a MAIN XML STRUCTURE file with the site structure in it as nodes
	build the navs based on that with names matching XML filenames full of data
	
GALLERY / TEXT
MAIN NAV
SUB NAV
SPANISH SWITCH

*/ 

import utils.XMLObject;
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;
import StructureApp;



class SubPageApp extends MovieClip {

	private var XMLPATH:String="";
	private var subpage_xml:XML;
	private var sXml:Object;
	private var myXmlObject:XMLObject;
	private var subpage1_mc:MovieClip;
	private var menuholder_mc:MovieClip;
	private var ML:menuList;
	
	private var galleryEnabled:Boolean;
	
	private var dataObj:Object;
	
	private var styles:TextField.StyleSheet;
	
	public function SubPageApp(clip:MovieClip){
		 trace("SUBPAGE APP CONSTRUCTOR ");
		
		trace(" HEY SUBPAGE   ::: "+StructureApp.getInstance().getPath()); 	
		BroadCaster.register(this,"loadASubPage");
		subpage1_mc = clip.subpage1;
				styles = new TextField.StyleSheet();

				styles.setStyle("headline", {
				    color:'#7A192F', 
					fontFamily:'Univers 67 CondensedBold', 
				    fontSize:'11', 
				    fontWeight:'bold'
				});
				styles.setStyle("date", {
				    color:'#8EB8BF', 
					fontFamily:'Univers 57 Condensed', 
				    fontWeight:'bold', 
				    fontSize:'11'
				});
				styles.setStyle("copy", {
				    color:'#666666', 
					fontFamily:'Univers 57 Condensed', 
				    fontSize:'11'
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
		dataObj = new Object();
		trace("DANGIT "+_pagename);//StructureApp.getInstance().getArrayData(_pagename));
		var bob:String = _pagename;
		StructureApp.getInstance().setArrayData(_pagename); 
		
		dataObj = StructureApp.getInstance().getArrayData(); 
		
		if (_global.lang == "SPANISH"){
			var _lang:String = "esp";
		}else{
			var _lang:String = "eng";
		}	
		
		XMLPATH = "xml/"+dataObj.name+"_"+ _lang +".xml";   
	//		BroadCaster.register(this,"setEvents");
		getXMLData();
			
	}
	private function getXMLData():Void{
		// maybe cal_xml = null; ??
		trace("getting "+ XMLPATH)
		subpage_xml = new XML();
		subpage_xml.ignoreWhite = true;
		subpage_xml.load(XMLPATH); 

		subpage_xml.onLoad = Delegate.create(this, onXmlLoad);
		
	}
	
	private function onXmlLoad($success:Boolean):Void{
			if ($success) {
			
				trace("load cal data :"+ $success);
							
				myXmlObject = new XMLObject();
				sXml = myXmlObject.parseXML(subpage_xml);
			
			} else {
				 trace("load data died "+ $success);
			}
		fireitupman();
	}
	
	private function fireitupman():Void{
		disable();
			for (var zed in sXml){
				for (var zing in sXml[zed]){
					for (var zap in sXml[zed][zing]){
						trace(zed+" :: "+zing+" :: " +zap+ " :: "+sXml[zed][zing][zap]);
						}}}
						
			//subpage1_mc.menuholder_mc.attachMovie("menuItem", "menuItem"+num, menulist.getNextHighestDepth(), {_x:0, _y:(TF_HEIGHT * num), _title:_titleObj, _mc:_mcObj, _justify:justify});
		
			var suckerArray:Array = new Array();
			suckerArray[0]= "CHILDREN";
			suckerArray[1]= "YOUTH";

			suckerArray[2]= "YOUNG ADULT";
			suckerArray[3]= "SINGLES";
			suckerArray[4]= "GENERATION LIFE";
			suckerArray[5]= "HILLTOPPERS";
			suckerArray[6]= "CREATIVE ARTS";
			suckerArray[7]= "MARRIAGE & FAMILY";
			suckerArray[8]= "ESPANOL";
		
			ML = new menuList(suckerArray, subpage1_mc.menuholder_mc, "right"); // justify right or left
	
			popData();
		 //	trace(sXml.main.item.copy.data);
		
	}
	
	private function popData(){
		// bCopy = bCopy+ itemArray[i].childNodes[b].toString();
		trace(subpage1_mc);
		subpage1_mc.header_tf.text = sXml.main.item.headline.data;
		
		
	//	subpage1_mc.bodycopy_tf.styleSheet= styles;
		subpage1_mc.bodycopy_tf.htmlText = sXml.main.item.copy.data;
		Tweener.addTween(subpage1_mc, {_alpha:100, time:1.1, transition:"easeOut"});
		// story_tf.styleSheet = styles;
		// story_tf.htmlText = bCopy;
		// story_tf.autoSize=true;
		// TF_EXTENDED =story_tf._height + 20;
		// story_tf.autoSize=false;
		//
		// story_tf._height = TF_SHORT;

		// this.story_tf.htmlText = bodyCopy;
	}
	
	
	public function disable():Void{ 
		trace("sub page disable -->");
		Tweener.addTween(subpage1_mc, {_alpha:0, time:0.5, transition:"easeOut"});
				ML.disable();
		
		/* 
		thisapp.blocker_mc.swapDepths(thisapp.getNextHighestDepth())
			var invisify:Function = function(_ob:Object){
				trace("I I :"+_ob);
				_ob._visible=false;
				}
		Tweener.addTween(this, {time:1, transition:"easeOut", _alpha:100, onComplete:invisify, onCompleteParams:[thisapp]}); 
		*/
	}

}