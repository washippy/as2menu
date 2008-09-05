/*
	ACTIONSCRIPT ON FRAME 1 OF MAIN TIMELINE
	Responsible for loading XML and initializing App.
*/
import mx.utils.Delegate;
import utils.XMLObject;


var lang = "ENG"; // ESP for spanish
var XMLPATH:String= "xml/mtz_home_eng.xml";
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
