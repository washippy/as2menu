/*
	ACTIONSCRIPT ON FRAME 1 OF MAIN TIMELINE
	Responsible for loading XML and initializing App.
	
	TO DO
	
	[X] Add BUTTON BAR functions
	
	[X] SUB PAGE FORMATTING IS HOSED
	
	[  ] STEAL DEEP LINK CODE
	
	[...] CHANGE the way SPANISH BUTTON WORKS ... and where it goes
	
	[X] FIX SCROLLERS [news] 
	
	[X] ADD SCROLLER TO SUBPAGEAPP
	
	[  ] LOTS OF DATA TO FORMAT
	
	[  ] TWEAK LOAD SEQUENCE
	
	[  ] SIDE TABS
	
	[  ] HTML FOOTER
	
	[  ] PROMO AUTO FLIPPER ??
	[  ]  NEWS / CALENDAR APP ??	


	[  ] TEST TEST TEST
	
	
	
	OLD ------
	// startup app

		// make sure mini apps can unload and reload
		// make mini apps go get their own data   ?

	// load english XML
		// on load of data...
	// load miniapps

	// write function to reload XML and build data objects
	// and unload and reload apps.

	
*/

import mx.utils.Delegate;
import utils.XMLObject;
import SWFAddress;
import SWFAddressEvent;




if (this._parent.setLang != undefined){
	_global.lang = this._parent.setLang; // SPANISH or ENGLISH if defined
}else{ 
//	_global.lang ="SPANISH";
	_global.lang ="ENGLISH";
}
 

var XMLPATH:String; 

XMLPATH = "xml/mtz_home.xml"; // set to english

if(_global.lang == "SPANISH"){
	XMLPATH = "xml/mtz_home_esp.xml"; // or maybe spanish
}


tracer.text+= "LANGUAGE SET TO ::::::: "+this._parent.setLang + newline+_global.lang+newline+"=================="+newline;
trace("LANGUAGE SET TO ::::::: "+this._parent.setLang+ newline+_global.lang)

////   DEEP LINKING	  ////////////
/* 
this.deepLink = '/portfolio/2/';
this.onRelease = _parent.btnRelease;
this.onRollOver = _parent.btnRollOver;
this.onRollOut = _parent.btnRollOut;

 
*/



// SWFAddress include
//#include "SWFAddress.as"

// SWFAddress actions
/* 
function btnRelease() {
	SWFAddress.setValue(this.deepLink);
}
function btnRollOver() {
	SWFAddress.setStatus(this.deepLink);
}
function btnRollOut() {
	SWFAddress.resetStatus();
}



// SWFAddress handling
SWFAddress.onChange = function() {
	var value = SWFAddress.getValue(); // "deeplink"
	

	var title = 'SWFAddress Website';	
	var names = SWFAddress.getPathNames();
	for (var i = 0; i < names.length; i++) {
		title += ' / ' + names[i].substr(0,1).toUpperCase() + names[i].substr(1);
		trace(names[i])
		
	}
	SWFAddress.setTitle(title); // HTML page title
	
}

*/



		//
	
/////////////////////////////////	

		
		
/*   	esp.onPress = function(){
		// trace("GGGGGGGGGGGGGGGGGGGGGG "+_global.lang)
		if(_global.lang == "SPANISH"){
			set (_global.lang, "ENGLISH"); 
		}else if (_global.lang == "ENGLISH"){;			
			set (_global.lang, "SPANISH"); 
		}	
		changeLanguage();
	}   */

	/*   	function changeLanguage(){
			XMLPATH = (_global.lang =="SPANISH") ? "xml/mtz_home_esp.xml" : "xml/mtz_home.xml";
			reLoadXML(XMLPATH);
			this.tf.text =_global.lang;

		}   */

//var XMLPATH:String = (_global.lang =="SPANISH") ? "xml/mtz_home_esp.xml" : "xml/mtz_home.xml";





var xml:XML;
var oXml:Object;
var app:App;

XML.prototype.ignoreWhite = true;

function loadXML(_xmlPath:String):Void{
	xml = new XML();
	xml.onLoad = Delegate.create(this, onXmlLoad);
	
		if (System.capabilities.playerType=="External") {
			xml.load(_xmlPath);
		}else{
			var numbersss = Math.ceil(Math.random()*1000000)+100000;
			xml.load(_xmlPath+"?random="+numbersss);
		}
	

}

/*
var numbersss = Math.ceil(Math.random()*1000000)+100000;
xml.load("Cal.xml?random="+numbersss);

*/

function onXmlLoad($success:Boolean):Void{
	 trace('xml loaded');
	if (!$success) {
		 trace('xml died');
		return;
	}

	var myXmlObject:XMLObject = new XMLObject();
	oXml = myXmlObject.parseXML(xml);
	oXml = oXml.main; // xmlObject = root XML node...
	
	// RUN PROGRAM
	app = new App(this, oXml);
}
	
home.onPress = function(){
	// trace("HOME JAMES ")
	app.reloadDisplayElements("home");
}



function reLoadXML(_xmlPath:String):Void{
	xml.onLoad = Delegate.create(this, onXmlRELoad);
	xml.load(_xmlPath);
}

function onXmlRELoad($success:Boolean):Void{  // may be obsolete
	// trace('xml loaded again');
	if (!$success) {
		// trace('xml died');
		return;
	}

	var myXmlREObject:XMLObject = new XMLObject();
	oXml = myXmlREObject.parseXML(xml);
	oXml = oXml.main; // xmlObject = root XML node...
	
	// RUN PROGRAM
	app.reDistributeData(oXml);
}



/// INIT LOADER
// START LOAD
loadXML(XMLPATH);


