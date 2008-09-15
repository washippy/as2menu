/*
	ACTIONSCRIPT ON FRAME 1 OF MAIN TIMELINE
	Responsible for loading XML and initializing App.
*/
import mx.utils.Delegate;
import utils.XMLObject;

//var defaultLang; // from embed flash var

//if (defaultLang != undefined){
//	_global.lang = defaultLang; // SPANISH for yes spanish
	
//}else{
	_global.lang ="ENGLISH";
//}

/*   	esp.onPress = function(){
		trace("GGGGGGGGGGGGGGGGGGGGGG "+_global.lang)
		if(_global.lang == "SPANISH"){
			set (_global.lang, "ENGLISH"); 
		}else if (_global.lang == "ENGLISH"){;			
			set (_global.lang, "SPANISH"); 
		}	
		changeLanguage();
	}   */


var XMLPATH:String = (_global.lang =="SPANISH") ? "xml/mtz_home_esp.xml" : "xml/mtz_home_eng.xml";

/*   	function changeLanguage(){
		XMLPATH = (_global.lang =="SPANISH") ? "xml/mtz_home_esp.xml" : "xml/mtz_home_eng.xml";
		reLoadXML(XMLPATH);
		this.tf.text =_global.lang;
				
	}   */


var xml:XML;
var oXml:Object;
var app:App;

XML.prototype.ignoreWhite = true;

function loadXML(_xmlPath:String):Void{
	xml = new XML();
	xml.onLoad = Delegate.create(this, onXmlLoad);
	xml.load(_xmlPath);
}

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



function reLoadXML(_xmlPath:String):Void{
	xml.onLoad = Delegate.create(this, onXmlRELoad);
	xml.load(_xmlPath);
}

function onXmlRELoad($success:Boolean):Void{
	trace('xml loaded again');
	if (!$success) {
		trace('xml died');
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

// startup app

	// make sure mini apps can unload and reload
	// make mini apps go get their own data   ?
	
	
// load english XML
	// on load of data...
// load miniapps
	

// write function to reload XML and build data objects
// and unload and reload apps.

// 
