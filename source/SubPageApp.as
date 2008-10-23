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
	
	private var dataArray:Array;
	
	
	public function SubPageApp(passmealong:String, clip:MovieClip){
		 trace("SUBPAGE APP CONSTRUCTOR ");
		
		trace(" HEY SUBPAGE   ::: "+StructureApp.getInstance().getPath()); 	
		BroadCaster.register(this,"loadASubPage");


		//////////////  WAIT PATIENTLY ////////////////
		
	}
	public function loadASubPage(_pagename:String):Void{
		// use page name to get data
		dataArray = new Array();
		dataArray = StructureApp.getInstance().getArrayData(_pagename); 
		
		if (_global.lang == "SPANISH"){
			var _lang:String = "esp";
		}else{
			var _lang:String = "eng";
		}	
		trace("DANGIT "+_pagename);//StructureApp.getInstance().getArrayData(_pagename));
		
		XMLPATH = "xml/"+dataArray.name+"_"+ _lang +".xml";   
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
			
			// trace("subpage data :" +sXml.item[0].data);
			
			// goFn();
			
			} else {
				 trace("load data died "+ $success);
			}
			
	}
	
	public function reLoadData(passmealong:String){
		// for spanish... new xmlpath
		XMLPATH = "xml/"+passmealong;  
		//goFn();
		
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