import mx.utils.Delegate;
import mx.events.EventDispatcher;
import caurina.transitions.*;
//import flash.filters.GlowFilter;
import utils.XMLObject;
import flash.geom.ColorTransform;
import flash.geom.Transform;

class VidPlayer extends MovieClip
{
//	private static var HOMEARROW_X_OFF:Number;
//	private static var HOMEARROW_X_AT:Number;
//	private static var ICONGLOW:GlowFilter = new GlowFilter(0xFFFFFF, 0.66, 8, 8, 5, 1, true);
//	private static var MCPLAYHEAD_MIN:Number;
//	private static var MCPLAYHEAD_MAX:Number;
//	private static var BUTTONGLOW:GlowFilter = new GlowFilter(0x80ABB2, 1, 18, 18, 5, 1, true);
//	GlowFilter([color:Number], [alpha:Number], [blurX:Number], [blurY:Number], [strength:Number], [quality:Number], [inner:Boolean], [knockout:Boolean])


	private var G_unselected:ColorTransform;
	private var G_selected:ColorTransform;


	private var vid_xml:XML;
	private var vXml:Object;
	private var myXmlObject:XMLObject;
	
	private var hotX:Number;
	private var _mc:MovieClip;
	private var XMLPATH:String; // 
	
	private var nc:NetConnection;
	private var ns:NetStream;
	private var sound:Sound;
	
	private var VIDPATH:String;

//	private var soundIsOn:Boolean = true;
	private var isPlaying:Boolean;
//	private var playheadDragging:Boolean = false;
	private var atPrompt:Boolean = true;
	private var threshholdCounter:Number = 0; // kludge thing
	private var vidDuration:Number = 0;	
	private var videoSet:Number = 0; // range: 0 or 1
	private var atMainVideo:Boolean = true;
	
//	var thumbLoader:Array = new Array();
//	var thumbLoaderListener:Array = new Array();
//	var promptLoader:Array = new Array();
//	var promptLoaderListener:Array = new Array();

	public function VidPlayer($path:String, $mc:MovieClip){
		
		_mc = $mc.media_app_mc.mcVideo;
		hotX = 7;
		_mc._x = 1500;
		_mc._alpha = 0;
		
			G_unselected = new ColorTransform( 1,1,1,1,0,0,0,0); 
			//G_selected = new ColorTransform(0, 0, 0, 1, 122, 25, 47, 0);// DARK RED
			G_selected = new ColorTransform(0, 0, 0, 1, 128, 171, 178, 0);// BLUE I HOPE
			
		
		
		XMLPATH = "xml/"+$path;
	//	_app = $app;
		getXML();
	}
	
	private function getXML():Void{
		
			// maybe cal_xml = null; ??
			vid_xml = new XML();
			vid_xml.ignoreWhite = true;
			vid_xml.load(XMLPATH); 

			vid_xml.onLoad = Delegate.create(this, onXmlLoad);

		}

	private function onXmlLoad($success:Boolean):Void{
				if ($success) {


				myXmlObject = new XMLObject();
				vXml = myXmlObject.parseXML(vid_xml);
				vXml = vXml.vidapp; // xmlObject = root node...

				VIDPATH = vXml.item.attributes.filePath;
				// trace("load cal data :"+ VIDPATH);
				
			} else {
				 // trace("load cal data died WHAA "+ $success);
			}
		
		
		init();	
	}

	
	private function init():Void{
		trace("I N I T  .................................");
		// set up stage elements
		
		_mc.mcPlayIcon._alpha = 100;
		_mc.mcPauseIcon._alpha =0;
	
//		_mc.mcPlayBgAt._visible = false;
//		_mc.mcPauseBgAt._visible = true;
//		_mc.mcVolBgAt._visible = false;
		
//		HOMEARROW_X_OFF = _mc.mcHome.mcArrow._x;
//		HOMEARROW_X_AT = HOMEARROW_X_OFF - 8;
//		MCPLAYHEAD_MIN = _mc.mcProgBarBg._x + 5; // NB "+ 5"
//		MCPLAYHEAD_MAX = _mc.mcProgBarBg._x + _mc.mcProgBarBg._width;
		
//		_mc.mcPlayhead._x = MCPLAYHEAD_MIN;
		
		// Video init
		
	//VIDPATH="assets/vids/VA_6_08.flv";
		
		nc = new NetConnection();
		nc.connect(null); // creates local streaming connection
		ns = new NetStream(nc);
		_mc.vid.attachVideo(ns); // attach the NetStream video feed to the Video object
		ns.setBufferTime(2); // set the buffer time
		ns.onStatus = Delegate.create(this, onNetStatus) 
		ns.onMetaData = Delegate.create(this, onMetaData);

		// Sound
		sound = new Sound();
		sound.setVolume(100);
		
		showPrompt();		
		addEvents();
		enable(_mc);

		// ... Note, events must be enable()'ed		
	}
	
	public function addEvents():Void{
		//_mc.onEnterFrame = Delegate.create(this, onEnterFrame);
		// trace("AE"+_mc.mcPrompt);
	//	_mc.mcPlayHit.onRollOver = Delegate.create(this, onPlayOver);
	//	_mc.mcPlayHit.onRollOut = Delegate.create(this, onPlayOut);
		_mc.mcPlayHit.onPress = Delegate.create(this, onPlayPress);
//		_mc.mcPauseHit.onRollOver = Delegate.create(this, onPauseOver);
//		_mc.mcPauseHit.onRollOut = Delegate.create(this, onPauseOut);
//		_mc.mcPauseHit.onRelease = Delegate.create(this, onPauseRelease);
		_mc.mcVolHit.onRollOver = Delegate.create(this, onVolOver);
		_mc.mcVolHit.onRollOut = Delegate.create(this, onVolOut);
//		_mc.mcVolHit.onRelease = Delegate.create(this, onVolRelease);
//		_mc.mcPlayhead.onPress = Delegate.create(this, onPlayheadPress);

//		_mc.mcNextVideo.onRelease = Delegate.create(this, onNextVideoRelease);		
//		_mc.mcNextVideo.onRollOver = Proxy.create(this, onButtonOver, _mc.mcNextVideo);
//		_mc.mcNextVideo.onRollOut = _mc.mcNextVideo.onDragOut = Proxy.create(this, onButtonOut, _mc.mcNextVideo);

		_mc.mcPrompt.onRelease = Delegate.create(this, onPromptMainButtonRelease);
		_mc.mcPrompt.onRollOver = Proxy.create(this, onButtonOver, _mc.mcPrompt);
		_mc.mcPrompt.onRollOut = _mc.mcPrompt.onDragOut = Proxy.create(this, onButtonOut, _mc.mcPrompt);
		
//		_mc.mcPrompt.mcAlt.mcButton1.onRelease = Delegate.create(this, onPromptAltButton1Release);
//		_mc.mcPrompt.mcAlt.mcButton1.onRollOver = Proxy.create(this, onButtonOver, _mc.mcPrompt.mcAlt.mcButton1);
//		_mc.mcPrompt.mcAlt.mcButton1.onRollOut = _mc.mcPrompt.mcAlt.mcButton1.onDragOut = Proxy.create(this, onButtonOut, _mc.mcPrompt.mcAlt.mcButton1);
//
	//	_mc.mcPrompt.mcAlt.mcButton2.onRelease = Delegate.create(this, onPromptAltButton2Release);
	//	_mc.mcPrompt.mcAlt.mcButton2.onRollOver = Proxy.create(this, onButtonOver, _mc.mcPrompt.mcAlt.mcButton2);
	//	_mc.mcPrompt.mcAlt.mcButton2.onRollOut = _mc.mcPrompt.mcAlt.mcButton2.onDragOut = Proxy.create(this, onButtonOut, _mc.mcPrompt.mcAlt.mcButton2);
	}
	
	private function onButtonOver($mc:MovieClip):Void{
		// trace("BLIP");
		//$mc.mcMain.vidStart.filters = [ BUTTONGLOW ];
		
			var trans:Transform = new Transform($mc.mcMain.vidStart);
			trans.colorTransform = G_selected;
		
		
	}
	private function onButtonOut($mc:MovieClip):Void{
		//$mc.mcMain.vidStart.filters = null;
		
			var trans:Transform = new Transform($mc.mcMain.vidStart);
			trans.colorTransform = G_unselected;
	}
	
	public function disable():Void{
			// trace("DISABLE  VIDEO"+ns);
		//	ns.pause(true);
		//	ns.seek(0);
		//	isPlaying = false;
		//	threshholdCounter = 0;
		//	updateIcons();
			_mc._x = 1500;
			_mc._alpha = 0;
			showPrompt();
	}
	
	public function enable(_go):Void{
		// trace("EN ABLE  VIDEO"+ _go );
		if(_go){
			_go._x = hotX;
			Tweener.addTween(_go, { _alpha:100, time:1, delay:2} );
		}else{
			_mc._x = hotX;
			Tweener.addTween(_mc, { _alpha:100, time:1, delay:2} );
		}
	}
	
	// EVENT HANDLERS

	private function onPromptMainButtonRelease():Void{
		playVideo();
	}
	
///////////// TURN THIS INTO PLAY PAUSE TOGGLE
	
	private function onPlayOver():Void{
		//	_mc.mcPlayBgAt._visible = true;
	}
	private function onPlayOut():Void{
	//	if (isPlaying) return;
		
	//	_mc.mcPlayBgAt._visible = false;
	}
	private function onPlayRelease():Void{
		if (isPlaying) return;
		
		_mc.mcPlayBgAt._visible = true;
		_mc.mcPauseBgAt._visible = false;

		if (atPrompt) 	playVideo();
		else 			unpauseVideo();
	}
	
	private function onPlayPress():Void{
		// trace(isPlaying)
		if (isPlaying == undefined){
			playVideo();
		}else if(isPlaying == true){
			pauseVideo();
		}else if(isPlaying == false){
			unpauseVideo();
		}
	}
	
	private function onPauseOver():Void{
		_mc.mcPauseBgAt._visible = true;
	}
	private function onPauseOut():Void{
		if (!isPlaying) return;
		
		_mc.mcPauseBgAt._visible = false;
	}
	private function onPauseRelease():Void{
		if (!isPlaying) return;
		
		_mc.mcPauseBgAt._visible = true;
		_mc.mcPlayBgAt._visible = false;
		
		pauseVideo();
	}
	private function onVolOver():Void{
		_mc.mcVolBgAt._visible = true;
	}
	private function onVolOut():Void{
		_mc.mcVolBgAt._visible = false;
	}
	


	
	private function onNetStatus(infoObject:Object):Void{
		// trace("status (" + ns.time + " seconds)" +  " Level: " + infoObject.level + " Code: " + infoObject.code);
		
		if (infoObject.code=="NetStream.Play.Stop") {
			_mc.mcPlayhead.stopDrag();
			showPrompt();
		}
	}
		
	private function onMetaData($o:Object){
		vidDuration = parseFloat( $o['duration'] );
		// trace('duration:'+vidDuration);
		if (isNaN(vidDuration)) vidDuration = 0;
	}
	
	
	// FUNCTIONS
	
	public function showPrompt():Void{
		// reset state
		atPrompt = true;
		vidDuration = 0;
		threshholdCounter = 0;
		ns.pause(true);
		ns.seek(0);
	
		// set up prompt
		_mc.mcPrompt._visible = true;
		_mc.mcPrompt._alpha = 50;
		_mc.mcPrompt.mcMain._visible = true;
		Tweener.addTween(_mc.mcPrompt, { _alpha:100, time:0.5 } );
		updateIcons();
	}
	
	private function updateIcons():Void{
		// trace("UA   "+isPlaying);
		if(isPlaying){
			_mc.mcPlayIcon._alpha = 0;
			_mc.mcPauseIcon._alpha =100;
		}else{
			_mc.mcPlayIcon._alpha = 100;
			_mc.mcPauseIcon._alpha =0;
		}		
	}
	

	private function hidePrompt():Void{
		var fn:Function = Delegate.create(this, hidePromptComplete);		
		Tweener.addTween(_mc.mcPrompt, { _alpha:0, time:0.3, onComplete: fn } );
		atPrompt = false;
	}
	private function hidePromptComplete():Void{
		_mc.mcPrompt._visible = false; 
		_mc.mcPromptHit._visible = false; 
	}
	
	public function playVideo():Void{
		// trace("PLAY VIDEO");
		hidePrompt();

		ns.play(VIDPATH);//oXmlNode().videoPath.data
		ns.seek(0);
		ns.pause(false);
		
		isPlaying = true;
		threshholdCounter = 0;
		updateIcons();
		
	}

	public function pauseVideo():Void{
		ns.pause(true);
		isPlaying = false;
		updateIcons();
	}
	private function unpauseVideo():Void{
		ns.pause(false);
		isPlaying = true;
		updateIcons();
	}
}