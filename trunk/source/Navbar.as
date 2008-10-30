/*	NAVBAR
	TO DO:
	SEND onclicks to main app
*/
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;
import StructureApp;



class Navbar extends MovieClip {

	private var navData:Object;
	private var navbar:MovieClip; 
	private var navbar_button_mc:MovieClip;
	private var navArray:Array;
	
	private var sectionArray:Array;
	
	private var navLength:Number;
	private var nameString:String;
	private var nameId:String;	
	private var nameNum:Number;
	
	// added 
	private var TF_HEIGHT:Number=15;
	private var justify:String = "center";
	
	
	public function Navbar(clip:MovieClip){
		navbar=clip.navbar_mc;
		
		trace("NAVBAR CONSTRUCTOR");
		BroadCaster.register(this,"navBarGetData");
		BroadCaster.register(this,"buildButtons");
		
		navbar._alpha=0;	
	}
	
	public function navBarGetData():Void{
		sectionArray = new Array();
		
		var sectionArray = StructureApp.getInstance().getNavArray();
		var saLen = sectionArray.length;
		trace("section GET DATA "+sectionArray);
	
		navArray = new Array();
		
		for(var o=0; o<saLen; o++){
			if(sectionArray[o].navNum != 0){
				var nObj:Object = new Object();
				nObj.name = sectionArray[o].name;
				nObj.eng = sectionArray[o].eng;
				nObj.esp = sectionArray[o].esp;
				navArray[sectionArray[o].navNum]=nObj;
				trace(" B  "+this);
				trace(" BOOOO  "+navArray[o].eng);
			
			}
		}
		
		BroadCaster.broadcastEvent("buildButtons");	
	
	}
	
	private function buildButtons():Void{
	trace("BB -----------------"+navArray.length);
			navLength = navArray.length;
			
		var bWidth = Math.floor((navbar._width - 3) / (navLength-1)); // button width = total width / number of buttons
		var bHeight = navbar._height;
		//trace("WW : "+navbar._width+" :: "+ navLength+" :: "+bWidth);
		for(var i=1;i<navLength;i++){
			
			navbar.attachMovie("navbar_button_mc", "nb"+i, navbar.getNextHighestDepth(), {_x:0, _y:-2});	
			
			// switch this to a super rollover menuItem
		/* 

			var _titleObj:Object = new Object(); // new stuff
			_titleObj = navArray[i]; 
			var _mcObj:Object = new Object();
			_mcObj = navbar;
				
		navbar.attachMovie("menuItem", "nb"+i, navbar.getNextHighestDepth(), {_title:_titleObj, _mc:_mcObj, _justify:justify});//(TF_HEIGHT * i)
		 
		*/
		trace(navArray[i].eng+" OYOYOY "+navArray[i].name);
		
			navbar["nb"+i].nameNum = i+1;
			navbar["nb"+i].nameString = navArray[i].eng;
			navbar["nb"+i].nameId = navArray[i].name;
			navbar["nb"+i].top_tf_mc.tf.text = navbar["nb"+i].bottom_tf_mc.tf.text = navArray[i].eng;
			navbar["nb"+i].top_tf_mc.tf.autoSize = navbar["nb"+i].bottom_tf_mc.tf.autoSize = "center";
			
			navbar["nb"+i].bkg_mc._width = bWidth;
			navbar["nb"+i].mask_mc._width = bWidth;
			
			navbar["nb"+i].bkg_mc._height = bHeight;
			navbar["nb"+i].mask_mc._height = bHeight-10;

			navbar["nb"+i]._y = bHeight/2;
			navbar["nb"+i]._x = bWidth/2;
		
		
			if(i!=0){
				navbar["nb"+i]._x = navbar["nb"+(i-1)]._x + bWidth+1;	
			} 
	

		
		} 
			addEvents();
		/// tween it in
		navbar._y+=15;
		Tweener.addTween(navbar, {delay:0, time:1, transition:"easeOut", _alpha:100, _y:navbar._y-15});
		
	}
	
	private function addEvents(){
			for(var i=0;i<navLength;i++){
				navbar["nb"+i].bkg_mc.onRollOver = Delegate.create(navbar["nb"+i], nbRollOver);
				navbar["nb"+i].bkg_mc.onRollOut = Delegate.create(navbar["nb"+i], nbRollOut);
				navbar["nb"+i].bkg_mc.onRelease = Delegate.create(navbar["nb"+i], nbRelease);
				navbar["nb"+i].bkg_mc.onPress = Delegate.create(navbar["nb"+i], nbPress);
			}
	}
	
	private function nbRollOver(){
		trace("OVER "+this.nameId);
		this.gotoAndPlay("over");		
	}
	
	private function nbRollOut(){
		//trace("OFF "+this);		
		this.gotoAndPlay("off");
	}
	
	private function nbRelease(){
		//trace("release "+this);		
	}
	
	private function nbPress(){
			var testObj:Object = new Object(); // TESTING == FIX THIS
			testObj = this.nameId;
			BroadCaster.broadcastEvent("launchNewPage", testObj, true);
	}

}