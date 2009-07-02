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
	private var thirdnav_array:Array;
	
	private var hotsubarray:String;

	private var navbar_array:Array;
	
	private function StructureApp(){
		trace("STRUCTURE APP CONSTRUCTOR");
	}
	
	static public function getInstance():StructureApp{ 
		if (_instance == undefined){ 
			_instance = new StructureApp(); 
		} 
			return _instance; 
	}
	
	
	public function setArrayData(_set:String):Void { 
		// set var :: later will loop thru array and ship appropriate one
		hotarray = _set;
	}	
	public function setSubArrayData(_set:String):Void { 
		// set var to loop thru array and ship appropriate one
		hotsubarray = _set;
	}
	
	public function getArrayData():Object {   //////////////this needs a level heirarchy
			// loop thru array and ship appropriate one
			// trace("GET ARRAY DAATA :: " + hotarray);
			for(var f in section_array){
				// trace("checkin : "+section_array[f].name +" :: "+ section_array[f].subnav_item_array[0].attributes.name);
				
				if(section_array[f].name == hotarray){
					return section_array[f];
					// trace("returning : "+section_array[f].name);
				}else{
					// trace("nuthin here");
					
				}
			}			
	}
	public function getThirdNavArrayData():Array { 	
		trace("G T N A Data ..................... "+hotarray+" || "+hotsubarray)
		for(var f in section_array){
			if(section_array[f].name == hotarray){
				for(var s in section_array[f].subnav_item_array){
					
				if(section_array[f].subnav_item_array.length == undefined){
					trace("A " +section_array[f].subnav_item_array.attributes.name)
					
						if(section_array[f].subnav_item_array.attributes.name == hotsubarray){
								return section_array[f].subnav_item_array;
						}
				}else{
					trace("B " + section_array[f].subnav_item_array[s].attributes.name)
					
						if(section_array[f].subnav_item_array[s].attributes.name == hotsubarray){
								return section_array[f].subnav_item_array[s];
						}
				}
				
				
				
				}
			}
		}
	}


	
	public function getNavArray():Array { 
			// trace("GET NAV ARRAY :: "+section_array);
			return section_array;		
	}	
	
	
	public function getPath():String { 
		return _xmlPath; 
	} 
	
	public function setPath(_xP:String):Void { 
		_xmlPath = "xml/"+_xP;
		 trace("++++++++++++++++ STRUCTURE PATH RECEIVED :"+_xP+newline+newline);
		getData();
	}
	
	private function getData():Void{
		// trace("GET DATA "+_xmlPath);
		// maybe str_xml = null; ??
		str_xml = new XML();
		str_xml.ignoreWhite = true;
		str_xml.onLoad = Delegate.create(this, onXmlLoad);
		
		
			if (System.capabilities.playerType=="External") {
				str_xml.load(_xmlPath); 
			}else{
				var numbersss = Math.ceil(Math.random()*1000000)+100000;
				str_xml.load(_xmlPath+"?random="+numbersss);
			}
		

		
	}
	
	private function onXmlLoad($success:Boolean):Void{
	// trace("onXmlLoad")
		if ($success) {
			
			// trace("load cal data :"+ $success);
							
			myXmlObject = new XMLObject();
			sXml = myXmlObject.parseXML(str_xml);
			sXml = sXml.mtzion; // xmlObject = root node...
			//trace("FOOOOOOOOOOOOOOOOOOOOO : "+sXml.section[0]);
			/* 
			for (var item in sXml.section){
							// trace("structure data : " +item +" :: " +sXml.section[item].attributes.name);
						} 
			*/

		//	
			setupArrays();
		} else {
			 trace("load structure data died WHAA "+ $success);
		}
	}
	
	private function setupArrays():Void{
		section_array = new Array();
		thirdnav_array = new Array();
		
		var slen:Number = sXml.section.length;
		
		//navbar_array = new Array(slen);
		
			for (var i:Number=0;i< slen; i++) {
						section_array.push({
							name:sXml.section[i].attributes.name,
							eng:sXml.section[i].attributes.eng,
						  	esp:sXml.section[i].attributes.esp,
						    navNum:sXml.section[i].attributes.navbarposition,
							link:sXml.section[i].attributes.link,
							data:sXml.section[i].data,
							galleryenabled:sXml.section[i].attributes.gallery_enabled, // if yes, get XML path later
						//	subnav_enabled:sXml.section[i].attributes.subnav_enabled, // if yes, get subnav later
							subnav_item_array:sXml.section[i].item,
							subnav_spanish_item_array:sXml.section[i].spanishitem // if yes, get subnav later
							
						   });
						
						//// third nav here?
						// trace("!!!"+sXml.section[i].attributes.name)
						
			}
			

		
		// BROADCAST THIS EVENT
		BroadCaster.broadcastEvent("navBarGetData");	
			
	}	
}


/*

var iLen = sXml.section[i].item.length;
for (var o=0;o<=iLen;o++){
	
	var snLen = sXml.section[i].item[o].subnav.length;
	for (var p=0;p<=snLen;p++){
		// trace("WELL FOO HERE IT IS "+o+" :: "+p+" :: "+sXml.section[i].item[o].subnav[p].attributes.eng)
		
		
		thirdnav_array.push({
												name:sXml.section[i].item[o].subnav[p].attributes.name,
												eng:sXml.section[i].item[o].subnav[p].attributes.eng,
											  	esp:sXml.section[i].item[o].subnav[p].attributes.esp
										}); 
	

		
	}
}


*/