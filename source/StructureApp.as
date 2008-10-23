//
//  StructureApp
//
//  Created by William Shippy on 2008-10-19.
//  Copyright (c) 2008 All rights reserved.
//


import utils.XMLObject;
import mx.utils.Delegate;


class StructureApp {
	
	static private var _instance:StructureApp; 
	private var _xmlPath:String; 
	private var XMLPATH:String="";
	private var str_xml:XML;
	private var sXml:Object;
	private var myXmlObject:XMLObject;
	
	private var section_array:Array;
	private function StructureApp(){}
	
	static public function getInstance():StructureApp{ 
		if (_instance == undefined){ 
			_instance = new StructureApp(); 
		} 
			return _instance; 
	}
	
	
	public function getArrayData(_name:String):Array { 
		// loop thru array and ship appropriate one
		for(var x in section_array){
			if(section_array[x].name == _name){
				return section_array[x];
				trace("returning : "+section_array[x].name);
			}
		}
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
		var subnav_array:Array = new Array();
		for (var item in sXml.section) {
					section_array.push({
								name:sXml.section[item].attributes.name,
								eng:sXml.section[item].attributes.eng,
							  	esp:sXml.section[item].attributes.esp,
								link:sXml.section[item].attributes.link,
								data:sXml.section[item].data,
								galleryenabled:sXml.section[item].attributes.gallery_enabled, // if yes, get XML path later
								subnav_enabled:sXml.section[item].attributes.subnav_enabled // if yes, get subnav later
							   });
		}
		
		for(var bob in section_array){
			for(var bill in section_array[bob]){
			trace("OOOOO "+ bob +":"+bill+ " :: "+ section_array[bob][bill])
		}
		
	}
	


	}
}