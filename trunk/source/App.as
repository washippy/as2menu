/*
	App.as:
*/ 
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.*;
import StructureApp;

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
	
	private var PAGE:String="HOME"; // HOME, SUB
	
	private var INIT:Boolean=false; // have the app instances been created?
	
	private var structurePath:String;
	private var structure:StructureApp;
	
	private var promoBarArray:Array;
// GLOBAL private var leftColumnPicPath:String;
	private var newsAppXMLPath:String;
	private var calendarAppXMLPath:String;
	private var videoannouncementsAppXMLPath:String;
	
	private var subPageApp:SubPageApp;

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
		
		BroadCaster.register(this,"launchNewPage");
		
		
		distributeData();
		initEvents();		
		_mc.play();
	}
	
	public function reDistributeData($oXml:Object):Void{
	 // when ESP is hit, a new data obj will be passed here, 
		_oXml = $oXml;
		// get current PAGE
	
		// data re distributed
		distributeData();
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
	
		structurePath=_oXml.structureapp.attributes.XMLpath;

		newsAppXMLPath=_oXml.newsapp.attributes.XMLpath;
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
		
		if(INIT){
				// APPS are already initiated
				reloadDisplayElements();
		}else{
				// initiate
				initDisplayElements();
		}		
	}
	
	private function initDisplayElements():Void{
		// LAUNCH SUB APPS which should be ALPHA zero to fade in when loaded
		//trace("what is this "+ newsAppXMLPath)
	
		
				//structure = new StructureApp();
				trace(" HEY OOOOOO   ::: "+StructureApp.getInstance().getPath()); 	
				calendarApp = new CalendarApp(calendarAppXMLPath, _mc);
				navbarApp = new Navbar(navBarArray, _mc);
				mainImageApp = new MainImage(mainImagePath, _mc);
				promoApp = new PromoBar(promoBarArray, _mc);
				newsApp = new NewsApp(newsAppXMLPath, _mc);
				
				subPageApp = new SubPageApp();
	}
	
	private function reloadDisplayElements():Void{
			trace("RELOAD current PAGE :"+ PAGE);
			switch(PAGE){
				case "HOME" :
				/* 
					calendarApp.enable();
									navbarApp.enable();
									mainImageApp.enable();
									promoApp.enable();
									newsApp.enable();
									
									subPageApp.disable(); 
				*/

				
				break;
				case "SUB" :
				/* 
					calendarApp.disable();
									navbarApp.disable();
									mainImageApp.disable();
									promoApp.disable();
									newsApp.disable();
									
									subPageApp.enable();
								 
				*/

				
				break;
			}
			

	}
	
	private function launchNewPage(_obj:Object):Void{
		trace("LAUNCH "+_obj);
		// fade out existing apps
		if(PAGE=="HOME"){
			calendarApp.disable();
		//	buttonbar.disable();
		//	mediaplayerstuff.disable();
			promoApp.disable();
			newsApp.disable();
 			BroadCaster.broadcastEvent("pastorPicDisable");
			
			// LAUNCH THE SUB APP using structure
			//trace(" HEY OOOOOO   ::: "+StructureApp.getInstance().getPath()); 	
			
		}
		
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