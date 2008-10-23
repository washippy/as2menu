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
	
	private var galleryEnabled:Boolean;
	
	private var dataObj:Object;
	
	private var styles:TextField.StyleSheet;
	
	public function SubPageApp(passmealong:String, clip:MovieClip){
		 trace("SUBPAGE APP CONSTRUCTOR ");
		
		trace(" HEY SUBPAGE   ::: "+StructureApp.getInstance().getPath()); 	
		BroadCaster.register(this,"loadASubPage");

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
		
			for (var zed in sXml){
				for (var zing in sXml[zed]){
					for (var zap in sXml[zed][zing]){
						trace(zed+" :: "+zing+" :: " +zap+ " :: "+sXml[zed][zing][zap]);
						}}}
			// goFn();
			 trace(sXml.main.item.data);
		
	}
	
	private function popData(){
		// bCopy = bCopy+ itemArray[i].childNodes[b].toString();

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