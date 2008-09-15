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
	
	private var assetPath:String;
	private var mainImagePath:String;
	
	private var navBarArray:Array;
	
	private var promoBarArray:Array;
	
	private var leftColumnPicPath:String;
	
	private var newsAppXMLPath:String;
	private var calendarAppXMLPath:String;
	private var videoannouncementsAppXMLPath:String;
	
//	private var newsApp:newsApp;
	private var calendarApp:CalendarApp;
//	private var videoannouncementsApp:videoannouncementsApp;
	private var navbarApp:Navbar;
	private var mainImageApp:MainImage;
	
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
		assetPath=_oXml.appvalues.attributes.assetpath;

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
				copy:_oXml.promobar.item[z].data
				});
		}
		
		leftColumnPicPath=_oXml.leftcolumnpic.attributes.assetname;

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
/*   
		for(var z in sideButtonBarArray){	
			for (var stuff in sideButtonBarArray[z]){
				trace(z+" :: "+stuff+" :: "+sideButtonBarArray[z][stuff]);
			}
		}        */
 

	}
	
	private function initDisplayElements():Void{
		// LAUNCH SUB APPS which should be ALPHA zero to fade in when loaded
		//trace("what is this "+ _mc)
		calendarApp = new CalendarApp(calendarAppXMLPath, _mc);
		navbarApp = new Navbar(navBarArray, _mc);
		mainImageApp = new MainImage(mainImagePath, _mc);
		
		
		
		/*
		for (var i:Number = 0; i < 2; i++) {
			THUMBPOS[i] = new Point( _mc["mcThumb"+i]._x, _mc["mcThumb"+i]._y );
			trace(i + " " + THUMBPOS[i].x + " " + THUMBPOS[i].y);
		}
		THUMBFRAME_WIDTH =	_mc.mcThumb0.mcFrame._width;
		THUMBFRAME_HEIGHT =	_mc.mcThumb0.mcFrame._height;
		THUMBIMAGE_WIDTH = 	_mc.mcThumb0.mcMask._width;
		THUMBIMAGE_HEIGHT =	_mc.mcThumb0.mcMask._height;
		
		
		_mc.mcCopyArea.mcTitle.tf.text = _oXml.copyArea.title.data;
		_mc.mcCopyArea.mcCopy.tf1.autoSize = true;
		_mc.mcCopyArea.mcCopy.tf1.htmlText = _oXml.copyArea.paragraph1.data;
		_mc.mcCopyArea.mcCopy.tf2.autoSize = true;
		_mc.mcCopyArea.mcCopy.tf2.htmlText = _oXml.copyArea.paragraph2.data;		
		_mc.mcCopyArea.mcCopy.tf2._y = _mc.mcCopyArea.mcCopy.tf1._y + _mc.mcCopyArea.mcCopy.tf1._height + 10;

	//	_mc.mcButton._y = _mc.mcCopyArea.mcCopy._y + _mc.mcCopyArea.mcCopy._height + 15;
		_mc.mcButton.tf.text = _oXml.copyArea.buttonLabel.data;
				
	//	_mc.mcThumb0.mcImage1._visible = false;
	//	_mc.mcThumb0.mcButton.tf.text = _oXml.thumb0.button.data;
		_mc.mcThumbTitle.tf.text = _oXml.thumb0.title.data;
		

	//	_mc.mcThumb1.mcImage0._visible = false;
	//	_mc.mcThumb1.mcButton.tf.text = _oXml.thumb1.button.data;
	//	_mc.mcThumb1.mcTitle.tf.text = _oXml.thumb1.title.data;
		
		// set state - thumbnail 0 is 'at'
	//	_mc.mcThumb1.mcImage1.filters = [new BlurFilter(BLUR_MAX, BLUR_MAX)];
	//	_mc.mcThumb0.mcButton.filters = [BUTTONGLOW];		
		_mc.mcVideo._visible = false;	*/	
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