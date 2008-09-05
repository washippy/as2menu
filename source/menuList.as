//
//  menuItem
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//


/*
	ACTIONSCRIPT ON FRAME 1 OF MAIN TIMELINE
	Responsible for loading XML and initializing App.
*/

import mx.utils.Delegate;










class menuItem extends MovieClip {
	
	private var title:String;
	var XMLPATH:String="";
	var xml:XML;
	var oXml:Object;
	var app:App;
	
	// get length
	
	private function menuItem(){
		// GET XML FOR NOW, LATER MAYBE JUST DROP ONE IN 
		XML.prototype.ignoreWhite = true;
		xml = new XML();
		xml.onLoad = Delegate.create(this, onXmlLoad);
		xml.load(XMLPATH);
		XMLPATH = "menu.xml";
	}
	
	
	function onXmlLoad($success:Boolean):Void
	{
		trace('xml loaded');

		if (!$success) {
			// bad.
			return;
		}

		var myXmlObject:XMLObject = new XMLObject();
		oXml = myXmlObject.parseXML(xml);
	 	oXml = oXml.menu; 

		// RUN PROGRAM
		//	app = new App(mcApp, oXml);
		
	}
	
	
}