/*	SubPageApp.as:  
	
	make a MAIN XML STRUCTURE file with the site structure in it as nodes
	build the navs based on that with names matching XML filenames full of data
	
GALLERY / TEXT
MAIN NAV
SUB NAV
SPANISH SWITCH


MANAGE SUB NAVS

see comps










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
	private var MLArray:Array;
	private var MLArray_esp:Array;
	private var ANIM_ENDPOINT:Number;
	private var ANIM_STARTPOINT:Number;
	private var galleryEnabled:Boolean;
	
	private var dataObj:Object;
	
	private var styles:TextField.StyleSheet;
	
	public function SubPageApp(clip:MovieClip){
		 trace("SUBPAGE APP CONSTRUCTOR ");
		
		trace(" HEY SUBPAGE   ::: "+StructureApp.getInstance().getPath()); 	
		BroadCaster.register(this,"loadASubPage");
		subpage1_mc = clip.subpage1;
		ANIM_ENDPOINT = subpage1_mc._y;
		ANIM_STARTPOINT = subpage1_mc._y +40;
		subpage1_mc._y = ANIM_STARTPOINT;
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
		trace("L A S P :: "+subpage1_mc);
		Tweener.removeTweens(subpage1_mc);
		
		subpage1_mc._alpha=0;
		subpage1_mc._y=ANIM_STARTPOINT;
		
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
		getXMLData();
		
		if(dataObj.subnav_item_array != undefined){
			buildSubNav();
		} else{
				MLArray = null;
				MLArray_esp = null;
			ML.disable();
		}
			
	}
	
	
	private function buildSubNav():Void{
		MLArray = new Array();
		MLArray_esp = new Array();
		
		
		trace("-----------------------+++++++++  "+dataObj.subnav_item_array[i].attributes.eng);
		var aLen = dataObj.subnav_item_array.length;
		
	/* 
		for(var xx=0;xx<aLen;xx++){
				trace("XXXXX  :: "+dataObj.subnav_item_array[xx].attributes.eng)
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
		
		/* 

					for (var zed in sXml){
						for (var zing in sXml[zed]){
							for (var zap in sXml[zed][zing]){
								trace(zed+" :: "+zing+" :: " +zap+ " :: "+sXml[zed][zing][zap]);
								}}}
								 
		*/

		
		if (_global.lang == "SPANISH"){
				ML = new menuList(MLArray_esp, subpage1_mc.menuholder_mc, "right"); // justify right or left
			}else{
				ML = new menuList(MLArray, subpage1_mc.menuholder_mc, "right"); // justify right or left
			}
		
		popData();
		
	}
	
	private function popData(){
		// bCopy = bCopy+ itemArray[i].childNodes[b].toString();
		trace(subpage1_mc);
		subpage1_mc.header_tf.text = sXml.main.item.headline.data;
		_global.mainImagePath =  sXml.main.item.attributes.swfName;
		BroadCaster.broadcastEvent("reloadMainImage");
		
	//	subpage1_mc.bodycopy_tf.styleSheet= styles;
		subpage1_mc.bodycopy_tf.htmlText = sXml.main.item.copy.data;
		Tweener.addTween(subpage1_mc, {_alpha:100, _y:ANIM_ENDPOINT, delay:.5, time:1.1, transition:"easeOut"});
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
		Tweener.addTween(subpage1_mc, {_alpha:0, _y:ANIM_STARTPOINT, time:0.25, transition:"easeOut"});
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