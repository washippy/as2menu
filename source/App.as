/*
	App.as:
	
	TO DO 

	DEEP LINK
	
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
//  GLOBAL private var mainImagePath:String;
	private var navBarArray:Array;
	
	private var PAGE:String="home"; // home or nuthin
	
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
		trace("APP CONSTRUCTOR")
		_mc = $mc;
		_oXml = $oXml;
		
//		trace(_mc+" :: "+_oXml.appvalues.attributes.assetpath);
		
		BroadCaster.register(this,"launchNewPage");
		
		
		/////////////////////////
		// GET DEEP LINK VALUES // 
		
		////////// UNCOMMENT THIS FOR LOCAL TESTING /////////////

	/* 
		        var ooo:Object = new Object();
			        ooo.path = "xml/mustang09_360.xml";
			        ooo.asset = "_coupe";
			        ooo.exterior = 1;
			        ooo.interior = 0;
			        ooo.background = "_env";
			        gettingXML(ooo); 
	*/

	

		    //////////////////////////////////////////////////////
		
		
		/////////////////////////
		
		distributeData();
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

		_global.mainImagePath=_oXml.mainimage.attributes.swfName;
		
	/* 
		navBarArray = new Array();
			var nLen = _oXml.navbar.item.length;
			for(var n=0;n<nLen;n++){
				navBarArray.push({
					title:_oXml.navbar.item[n].attributes.title,
					navName:_oXml.navbar.item[n].attributes.navName				
					}); 					 //////// change this to a structure thing maybe
			} 
	*/

	
		
		promoBarArray = new Array();
		var pLen = _oXml.promobar.item.length;
		for(var z=0;z<pLen;z++){
			promoBarArray.push({
				headline:_oXml.promobar.item[z].attributes.headline,
				assetname:_oXml.promobar.item[z].attributes.assetname,
				assetType:_oXml.promobar.item[z].attributes.type,
				launchType:_oXml.promobar.item[z].attributes.launchType,
				launchName:_oXml.promobar.item[z].attributes.launchName,     				
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
					INIT = true;
			}		 
	

	
	}
	
/* 
	private function gettingXML(oData){
	     //   var xmlData = oData.path == undefined ? "xml/mustang09_360.xml" : oData.path;
	       // threeSixtyModel.initXML(xmlData);

	        trace("XXXXXXXXXXXXXXXXXXX "+oData.asset+ ":: "+oData.exterior+ ":: "+oData.interior+ ":: "+oData.background);


	      //  Controller.trimVar = oData.asset;
	      //  Controller.dExt =oData.exterior;
	      //  Controller.dInt =oData.interior;
	      //  Controller.bkgVar =oData.background;

	    }
 
*/

	
	
	
	
	private function initDisplayElements():Void{
		// LAUNCH SUB APPS which should be ALPHA zero to fade in when loaded
	trace("APP :: INIT DISPLAY ELEMENTS "+structurePath)
	
				StructureApp.getInstance().setPath(structurePath);
				
				//trace(" HEY OOOOOO   ::: "+StructureApp.getInstance().getPath()); 	
				calendarApp = new CalendarApp(calendarAppXMLPath, _mc);
				navbarApp = new Navbar(_mc);//navBarArray
				navbarApp.hotSection = "home" // GET FROM DEEP LINK
				
				mainImageApp = new MainImage(_global.mainImagePath, _mc);
				promoApp = new PromoBar(promoBarArray, _mc);
				newsApp = new NewsApp(newsAppXMLPath, _mc);
				
				subPageApp = new SubPageApp(_mc);
	}
	
	public function reloadDisplayElements(_sendPAGE:String):Void{
		
		var p = String(PAGE);
			trace("RELOAD DISPLAY ELEMENTS :: currentPAGE ::"+ p+"  :: "+_sendPAGE);
			if(p==_sendPAGE){
				return;
			}
			switch(PAGE){  // if the current page is home; kill all the apps, otherwise we're loading a subpage
				case "home" :
						calendarApp.disable();
						//navbarApp.disable();
						//mainImageApp.disable();
						promoApp.disable();
						newsApp.disable();
					//	subPageApp.loadASubPage();
					PAGE = "home";
					
				break;
				default :
				
					subPageApp.disable(); 
					calendarApp.enable();
				//	navbarApp.enable();
				//	mainImageApp.enable();
					promoApp.enable();
					newsApp.enable(true);
					BroadCaster.broadcastEvent("pastorPicEnable");
					// set main image back to default here /////////////////////////////////
					
					BroadCaster.broadcastEvent("reloadMainImage");
					PAGE = "home";
				break;
			}
			

	}
	
	private function launchNewPage(_obj:Object):Void{
		trace("LAUNCH "+_obj);
		// fade out existing apps
		//if(PAGE=="home" && _obj=="home"){  // at home and home is clicked
		if(PAGE==_obj){  // at 
			trace("LAUNCH ::: PAGE=_obj :: "+ PAGE +" :: "+_obj);
			return;
			}
		
		if(_obj=="home"){ // not home but home is clicked
			
			var sendPAGE=String(_obj);
			reloadDisplayElements(sendPAGE);
			return;
		}
		
	//	if(PAGE=="home"){
			calendarApp.disable();
		//	buttonbar.disable();
		//	mediaplayerstuff.disable();
			promoApp.disable();
			newsApp.disable();
 			BroadCaster.broadcastEvent("pastorPicDisable");
			
			// LAUNCH THE SUB APP using structure
			//trace(" HEY OOOOOO   ::: "+StructureApp.getInstance().getPath()); 	
			
			PAGE=String(_obj);
			BroadCaster.broadcastEvent("loadASubPage", _obj , false);

	//	}
		
	}
	
	
}