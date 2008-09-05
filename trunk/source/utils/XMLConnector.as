//-------------------
// IMPORTS
//-------------------

import mx.utils.Delegate;
//import utils.Observer;

//-------------------
// CLASS
//-------------------
class utils.XMLConnector {
	
//-------------------
// PROPERTIES
//-------------------

	private var _xml:XML;
	private var _url:String;

//-------------------
// GET/SET
//-------------------
	
	// returns xml object
	public function get schema():XML {
		return this._xml;
	}
	
	// returns the url passed/set in onXMLLoad
	public function get url():String {
		return this._url;
	}
	
//-------------------
// CONSTRUCTOR
//-------------------

	function XMLConnector() {
		this.initialize();
	}

//-------------------
// PRIVATE
//-------------------

	private function initialize():Void {
		this._xml = new XML();
		this._xml.ignoreWhite = true;
		this._xml.onLoad = Delegate.create(this, onXMLLoad);
	}
	
	private function onXMLLoad(success:Boolean):Void {
		if (success) {
			("success!!!");
			this.notifyResults(this._xml);
		}else{
			("failed...");
		}
	}

//-------------------
// PUBLIC
//-------------------

	public function loadXML(url:String):Void {
		this._url = url;
		this._xml.load(url);
	}
}