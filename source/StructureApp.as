//
//  StructureApp
//
//  Created by William Shippy on 2008-10-19.
//  Copyright (c) 2008 All rights reserved.
//


import mx.utils.Delegate;
import utils.*;


class StructureApp {
	
	static private var _instance:StructureApp; 
	private var _xmlPath:String; 
	private var XMLPATH:String="";
	private var str_xml:XML;
	private var sXml:Object;
	private var myXmlObject:XMLObject;
	private var hotarray:String;
	private var section_array:Array;
	
	private var navbar_array:Array;
	
	private function StructureApp(){}
	
	static public function getInstance():StructureApp{ 
		if (_instance == undefined){ 
			_instance = new StructureApp(); 
		} 
			return _instance; 
	}
	
	
	public function setArrayData(_set:String):Void { 
		// set var to loop thru array and ship appropriate one
		hotarray = _set;
	}
	
	public function getArrayData():Object { 
			// loop thru array and ship appropriate one
			trace("GET ARRAY DAATA :: " + hotarray);
			for(var f in section_array){
				trace("checkin : "+section_array[f].name);
				
				if(section_array[f].name == hotarray){
					return section_array[f];
					trace("returning : "+section_array[f].name);
				}
			}			
	}



	
	public function getNavArray():Array { 
			// loop thru array and ship appropriate one
			trace("GET NAV ARRAY DAATA :: "+section_array);
			return section_array;		
	}	
	
	
	public function getPath():String { 
		return _xmlPath; 
	} 
	
	public function setPath(_xP:String):Void { 
		_xmlPath = "xml/"+_xP;
		trace("++++++++++++++++ STRUCTURE PATH RECEIVED :"+_xP);
		getData();
	}
	
	private function getData():Void{
		// maybe str_xml = null; ??
		str_xml = new XML();
		str_xml.ignoreWhite = true;
		str_xml.load(_xmlPath); 

		str_xml.onLoad = Delegate.create(this, onXmlLoad);
		
	}
	
	private function onXmlLoad($success:Boolean):Void{
		if ($success) {
			
			// trace("load cal data :"+ $success);
							
			myXmlObject = new XMLObject();
			sXml = myXmlObject.parseXML(str_xml);
			sXml = sXml.mtzion; // xmlObject = root node...
			//trace("FOOOOOOOOOOOOOOOOOOOOO : "+sXml.section[0]);
			for (var item in sXml.section){
				trace("structure data : " +item +" :: " +sXml.section[item].attributes.name);
			}
			setupArrays();
		} else {
			 trace("load structure data died WHAA "+ $success);
		}
	}
	
	private function setupArrays():Void{
		section_array = new Array();
		var slen:Number = sXml.section.length;
		
		//navbar_array = new Array(slen);
		trace("BANGOOOO "+ navbar_array.length);
		
			for (var i:Number=0;i< slen; i++) {
						section_array.push({
							name:sXml.section[i].attributes.name,
							eng:sXml.section[i].attributes.eng,
						  	esp:sXml.section[i].attributes.esp,
						    navNum:sXml.section[i].attributes.navbarposition,
							link:sXml.section[i].attributes.link,
							data:sXml.section[i].data,
							galleryenabled:sXml.section[i].attributes.gallery_enabled, // if yes, get XML path later
							subnav_enabled:sXml.section[i].attributes.subnav_enabled // if yes, get subnav later
						   });
			}
			
		// BROADCAST THIS EVENT
		BroadCaster.broadcastEvent("navBarGetData");	
			
	}	
}