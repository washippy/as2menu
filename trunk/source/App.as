/*
	App.as:
	
	TO DO 

	DEEP LINK
	
	
		
		vid.pauseVideo();
		vid.disable();
		
		vid.enable();
		vid.playVideo();
		
		vid = new BtsVidPlayer(_mc.mcVideo, _oXml, this);
		
		vid.setVideo($i, true);
	
	
	
	
*/ 
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.*;
import StructureApp;
import SWFAddress;

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
	
	private var PAGE:String;//="home"; // home or nuthin
	
	private var INIT:Boolean=false; // have the app instances been created?
	private var FIRSTTIMETHRU:Boolean=true; // first time just wait and store values
	private var FIRSTTIMETHRUDROP:String; // first time just wait and store values
	
	
	
	private var structurePath:String;
	private var structure:StructureApp;
	
	private var promoBarArray:Array;
	private var leftColumnPicPath:String;
	private var newsAppXMLPath:String;
	private var calendarAppXMLPath:String;
	
	private var vidPlayerXMLPath:String;
	
	private var _esp:MovieClip; // spanish button
	
	
	private var subPageApp:SubPageApp;

	private var vidPlayer:VidPlayer;
	private var buttonbar_mc:MovieClip;
	private var pastorPic:PastorPic;

	private var newsApp:NewsApp;
	private var calendarApp:CalendarApp;
	private var navbarApp:Navbar;
	private var mainImageApp:MainImage;
	private var promoApp:PromoBar;
	
		private var buttonBar:ButtonBar;

//	private var sideButtonBarArray:Array;
	
	private var redButtonBarArray:Array;

	private var launchinterval:Number;
	

	public function App($mc:MovieClip, $oXml:Object){
		trace("APP CONSTRUCTOR "+ 	_global.lang);
		$mc.tracer.text+= "APP CONSTRUCTOR ::: >>" + 	_global.lang
		
		_mc = $mc;
		_oXml = $oXml;
	
		_esp=_mc.esp;
	
	//	_global.SUBLAUNCH
	//	_global.SUBLAUNCH = false; // THIS SWITCH GETS FLIPPED DEPENDING ON WHICH PAGE IS LOADED .. FOR DEEP LINKING
	//	_global.SUBLAUNCHNUM;

//		trace(_mc+" :: "+_oXml.appvalues.attributes.assetpath);
		
		BroadCaster.register(this,"launchNewPage");
		BroadCaster.register(this,"traceMe");
		BroadCaster.register(this,"navbarEnable");

		distributeData();
		
        
		_mc.play(); //frame tween fade in
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
		_global.homeImagePath=_oXml.mainimage.attributes.swfName; // permanent for returning home
		_global.mainImagePath=_oXml.mainimage.attributes.swfName; // this one changes w sections
		
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
		
		leftColumnPicPath=_oXml.leftcolumnpic.attributes.assetname;
	
		structurePath=_oXml.structureapp.attributes.XMLpath;

		newsAppXMLPath=_oXml.newsapp.attributes.XMLpath;
		calendarAppXMLPath=_oXml.calendarapp.attributes.XMLpath;
		vidPlayerXMLPath=_oXml.vidapp.attributes.XMLpath;
	
	
/* 
		sideButtonBarArray = new Array();
			var sLen = _oXml.sidebuttonbar.item.length;
			
			for(var s=0;s<sLen;s++){
				sideButtonBarArray.push({
					title:_oXml.sidebuttonbar.item[s].attributes.title,
					url:_oXml.sidebuttonbar.item[s].attributes.url
					});
			}	 
	 
*/



	
		
		// RED BUTTONS ON BOTTOM RIGHT
		redButtonBarArray = new Array();
		var rLen = _oXml.redboxnav.item.length;
		for(var r=0;r<rLen;r++){
			redButtonBarArray.push({
				id:_oXml.redboxnav.item[r].attributes.id,
				section:_oXml.redboxnav.item[r].attributes.section,
				url:_oXml.redboxnav.item[r].attributes.url
				});
		}	
	
		trace("BBB "+redButtonBarArray[5].section)
		
		
	
		if(INIT){
					// APPS are already initiated
					reloadDisplayElements();
			}else{
					// initiate
					initDisplayElements();
					INIT = true;
			}		 
	}
	
	private function traceMe(doohicky){
		trace(_mc);
		_mc.tracer.text+=doohicky;
	}
	
    public function handleChange(e:SWFAddressEvent):Void {
		trace("HANDLE CHANGE +++++++++++++++++" + e.value +" >>> "+FIRSTTIMETHRU);
	//	_mc.tracer.text +="HANDLE CHANGE +++++++++++++++++" + e.value +" >>> "+FIRSTTIMETHRU+newline;


	//	on the first time thru, set the status check interval and wait for the apps to be ready
	// then split for 
/* 
		if(FIRSTTIMETHRU){
			FIRSTTIMETHRU=false;
			FIRSTTIMETHRUDROP = e.value;
			launchinterval = setInterval(this, "statusCheck", 200);
			return;
		} 
*/


		
		
	//	then call load sub page
		
		
		
	//	on the 2+ time thru, split for home or sub
		
		













		//_mc.tracer.text+= "H C :    ";
	
	// check value of event to change button statuses
	
    //    _mc.home_mc.label_txt.textColor = (e.value == '/') ? 0xCCCCCC : 0xFFFFFF;
    //  _mc.about_mc.label_txt.textColor = (e.value == '/about/') ? 0xCCCCCC : 0xFFFFFF;
     // _mc.contact_mc.label_txt.textColor = (e.value == '/contact/') ? 0xCCCCCC : 0xFFFFFF;
	
	
	// change browser window title
	var title = 'Mt. Zion';
        for (var i = 0; i < e.pathNames.length; i++) {
            title += ' / ' + e.pathNames[i].substr(0,1).toUpperCase() + e.pathNames[i].substr(1);
        }
        SWFAddress.setTitle(title);

	//	_mc.tracer.text +=  "H C  e.value is  >>>>  " +e.value +newline;
		
	//	for (var i = 0; i < e.pathNames.length; i++) {
      //   	_mc.tracer.text+= "H C ++++++++ PATHNAME is  >>>>  " +e.pathNames[i] + newline;
      // }

		
		
	

		
	/* 
		if(!INIT){ // if handle change is hit before initDisplayElements is called, wait and call it again;
				launchinterval = setInterval(this, "handleChange", 20);
				
			}else{
				clearInterval(launchinterval);
			} 
	*/

	


			if(e.value == "/" || e.value == undefined){
				//load home page
				reloadDisplayElements("home");
				return;
			}  


//_mc.tracer.text+= "INIT IS : "+INIT + newline+"----------------"+newline;







//	_mc.tracer.text+= "E PATHNAMES len : "+e.pathNames.length + newline;
	
//	_mc.tracer.text+= "E VALUE : " +e.value+newline;
/* 

		var testObj:Object = new Object(); 
		testObj = e.value.substr(1);
	
	BroadCaster.broadcastEvent("launchNewPage", testObj, false);
	
	
	 
*/


	

				if(e.pathNames.length >1){
						trace("YO")
						_mc.tracer.text+= "H C ++++++++ SUB TRUE" +e.pathNames[1]+newline;
						
						var testObj:Object = new Object(); 
						testObj.sect = e.pathNames[0] // grab the 1st one
						testObj.subsect = e.pathNames[1] // grab the 2nd one
						BroadCaster.broadcastEvent("loadADeepSubSection", testObj, false);
				}else{
			
					trace("YO AAUGH " +e.value.substr(1))
//					_mc.tracer.text+= "H C ++++++++  SUB FALSE" +e.value.substr(1)+newline;
			
					var testObj:Object = new Object(); 
					testObj = e.value.substr(1);
				 
				//	if(testObj == '') {
				//					trace("TEST OBJ WAS BLANK == GOIGN TO HOME ");
				//					testObj ='home'
				//					}; 
				

				
					BroadCaster.broadcastEvent("launchNewPage", testObj, false);
				}
			 
	

	
		
    }


	public function delegater(target:Object, handler:Function):Function {
	        var f = function() {
	            var context:Function = arguments.callee;
	            var args:Array = arguments.concat(context.initial);
	            return context.handler.apply(context.target, args);
	        }
	        f.target = target;
	        f.handler = handler;
	        f.initial = arguments.slice(2);
	        return f;
	 }
	
	private function initDisplayElements():Void{
		// LAUNCH SUB APPS which should be ALPHA zero to fade in when loaded
	 trace("APP :: INIT DISPLAY ELEMENTS "+_mc)
//_mc.tracer.text+= "APP :: INIT DISPLAY ELEMENTS "+newline;
	
				StructureApp.getInstance().setPath(structurePath);
				
				//// trace(" HEY OOOOOO   ::: "+StructureApp.getInstance().getPath()); 	
				calendarApp = new CalendarApp(calendarAppXMLPath, _mc);
				navbarApp = new Navbar(_mc);//navBarArray
				navbarApp.hotSection = "home" // GET FROM DEEP LINK
				vidPlayer = new VidPlayer(vidPlayerXMLPath, _mc);
				mainImageApp = new MainImage(_global.mainImagePath, _mc);
				promoApp = new PromoBar(promoBarArray, _mc);
				newsApp = new NewsApp(newsAppXMLPath, _mc);
				buttonBar = new ButtonBar(redButtonBarArray, _mc);
				pastorPic = new PastorPic(leftColumnPicPath, _mc);
				subPageApp = new SubPageApp(_mc);
				
				launchinterval = setInterval(this, "statusCheck", 200);
	
	}
	
	public function statusCheck():Void{
		trace("S check"+ calendarApp.ready);
		
			if(!calendarApp.ready){return;}
			trace("CAL");
			if(!navbarApp.ready){return;}
			trace("NAVBAR");
			if(!vidPlayer.ready){return;}
			trace("V");
			if(!mainImageApp.ready){return;}
			trace("IMG");
			if(!promoApp.ready){return;}
			trace("PROMO");
			if(!newsApp.ready){return;}
			trace("NEWS");
			if(!buttonBar.ready){return;}
			trace("BBAR");
			if(!pastorPic.ready){return;}
			trace("PPIC");
			if(!subPageApp.ready){return;}
			trace("SPA");
			
			
			clearInterval(launchinterval);
			trace("CLEAR FOR TAKEOFF ........."+typeof(FIRSTTIMETHRUDROP)+" is "+FIRSTTIMETHRUDROP); 
			//_mc.tracer.text+="CLEAR FOR TAKEOFF ........."+typeof(FIRSTTIMETHRUDROP)+" is >>>"+FIRSTTIMETHRUDROP+"<<<"+newline;
			
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, delegater(this, handleChange));
	
	}
	
	
	public function reloadDisplayElements(_sendPAGE:String):Void{
		
		var p = String(PAGE);
			 trace("RELOAD DISPLAY ELEMENTS :: currentPAGE ::"+ p+"  :: "+_sendPAGE);
		//	_mc.tracer.text+="RELOAD DISPLAY ELEMENTS :: currentPAGE ::"+ p+"  :: "+_sendPAGE + newline;
			
			if(p==_sendPAGE){
				return;
			}
			switch(PAGE){  // if the current page is home; kill all the apps, otherwise we're loading a subpage
				case "home" :
						calendarApp.disable();
						navbarApp.disable();
						//mainImageApp.disable();
						vidPlayer.disable();
						promoApp.disable();
						newsApp.disable();
						buttonBar.disable();
						pastorPic.disable();
					//	subPageApp.loadASubPage();
					PAGE = "home";
					
				break;
				default :
				
					subPageApp.disable("RELOAD"); 
					calendarApp.enable();
					navbarApp.enable();
					mainImageApp.enable();
					vidPlayer.enable();
					promoApp.enable();
					newsApp.enable(true);
					pastorPic.enable();
					// set main image back to default here /////////////////////////////////
				
					buttonBar.enable();
					
					_global.mainImagePath = _global.homeImagePath;
					BroadCaster.broadcastEvent("reloadMainImage");
					PAGE = "home";
				break;
			}
			

	}
	
	private function navbarEnable(){
		navbarApp.enable();
	}
	
	private function launchNewPage(_obj:Object):Void{ // splits HOME vs PAGE
				trace("LAUNCH "+_obj);


					if(_obj=="home"){ // not home but home is clicked

						var sendPAGE=String(_obj);
						reloadDisplayElements(sendPAGE);
						return;
					}


				calendarApp.disable();
				vidPlayer.disable();
				promoApp.disable();
				newsApp.disable();
				buttonBar.disable();
				navbarApp.enable();
				pastorPic.disable();

				PAGE=String(_obj);
				BroadCaster.broadcastEvent("loadASubPage", _obj , false);

		
	}
	
	
}