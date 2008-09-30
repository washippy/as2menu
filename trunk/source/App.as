/*
	App.as:
*/ 
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.*;


class App extends MovieClip {
	
	//	private static var DOCUMENT_WIDTH:Number = 709;
	//	private static var DOCUMENT_HEIGHT:Number = 642;
	//	private static var BLUR_MAX:Number = 6;
	//	private static var BUTTONGLOW:GlowFilter = new GlowFilter(0xE36101, 0.66, 8, 8, 2);
	
	private var _oXml:Object;
	private var _mc:MovieClip;	
	
//	GLOBAL private var assetPath:String;
	private var mainImagePath:String;
	private var navBarArray:Array;
	private var promoBarArray:Array;
// GLOBAL private var leftColumnPicPath:String;
	private var newsAppXMLPath:String;
	private var calendarAppXMLPath:String;
	private var videoannouncementsAppXMLPath:String;
	
	private var newsApp:NewsApp;
	private var calendarApp:CalendarApp;
//	private var videoannouncementsApp:videoannouncementsApp;
	private var navbarApp:Navbar;
	private var mainImageApp:MainImage;
	private var promoApp:PromoBar;
	
	private var sideButtonBarArray:Array;

	

	public function App($mc:MovieClip, $oXml:Object){
		_mc = $mc;
		_oXml = $oXml;
		
		trace(_mc+" :: "+_oXml.appvalues.attributes.assetpath);
		
		distributeData();
		initDisplayElements();
		initEvents();		
		_mc.play();
	}
	
	public function reDistributeData($oXml:Object):Void{
	 // when ESP is hit, a new data obj will be passed here, 
		_oXml = $oXml;
		// data re distributed
		distributeData();
		// APPS re initiated
		initDisplayElements();
	}
	
	
	private function distributeData():Void{
		_global.assetPath=_oXml.appvalues.attributes.assetpath;

		mainImagePath=_oXml.mainimage.attributes.assetname;
		
		navBarArray = new Array();
		var nLen = _oXml.navbar.item.length;
		for(var n=0;n<nLen;n++){
			navBarArray.push({title:_oXml.navbar.item[n].attributes.title});
		}
		
		promoBarArray = new Array();
		var pLen = _oXml.promobar.item.length;
		for(var z=0;z<pLen;z++){
			promoBarArray.push({
				headline:_oXml.promobar.item[z].attributes.headline,
				assetname:_oXml.promobar.item[z].attributes.assetname,
				assetType:_oXml.promobar.item[z].attributes.type,
				copy:_oXml.promobar.item[z].data
				});
		}
		
		_global.leftColumnPicPath=_oXml.leftcolumnpic.attributes.assetname;

		newsAppXMLPath=_oXml.newsapp.attributes.XMLpath;
		trace(newsAppXMLPath+"*******************  **    * * * * *  * *")
		calendarAppXMLPath=_oXml.calendarapp.attributes.XMLpath;
		videoannouncementsAppXMLPath=_oXml.videoannouncementsapp.attributes.XMLpath;
	
		sideButtonBarArray = new Array();
		var sLen = _oXml.sidebuttonbar.item.length;
		for(var s=0;s<sLen;s++){
			sideButtonBarArray.push({
				title:_oXml.sidebuttonbar.item[s].attributes.title,
				url:_oXml.sidebuttonbar.item[s].attributes.url
				});
		}	
	}
	
	private function initDisplayElements():Void{
		// LAUNCH SUB APPS which should be ALPHA zero to fade in when loaded
		//trace("what is this "+ _mc)
		calendarApp = new CalendarApp(calendarAppXMLPath, _mc);
		navbarApp = new Navbar(navBarArray, _mc);
		mainImageApp = new MainImage(mainImagePath, _mc);
		promoApp = new PromoBar(promoBarArray, _mc);
		newsApp = new NewsApp(newsAppXMLPath, _mc);
	}
	
	
	
	
	private function initEvents():Void
	{
		/*
		Tweener.addTween(_mc.mcNavigator, {delay:2.25, time:1, transition:"easeInBack", _alpha:100, _yscale:100, _xscale:100});
		Tweener.addTween(_mc.mcThumbTitle, {delay:2, time:1, transition:"easeInBack", _alpha:100, _yscale:100, _xscale:100});
		
		BroadCaster.register(this,"introFinished");
		BroadCaster.register(this,"onThumbRelease");
		BroadCaster.register(this,"updateThumbTitle");
		*/
	}
}