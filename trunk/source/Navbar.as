/*	NAVBAR
	TO DO:
	SEND onclicks to main app
*/
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;



class Navbar extends MovieClip {

	private var navData:Object;
	private var navbar:MovieClip; 
	private var navbar_button_mc:MovieClip;
	private var navArray:Array;
	private var navLength:Number;
	private var nameString:String;
	private var nameNum:Number;
	
	// added 
	private var TF_HEIGHT:Number=15;
	private var justify:String = "center";
	
	
	public function Navbar(_navdata:Object, clip:MovieClip){
		navbar=clip.navbar_mc;
		//trace("NAVBAR CONSTRUCTOR ");
		
		navbar._alpha=0;
		navArray = new Array();
		navLength = _navdata.length;
		
		for(var i=0;i<navLength;i++){
			
			navArray[i] = _navdata[i].title;
			//trace(navArray[i]);
		}
		buildButtons();
	}
	
	private function buildButtons():Void{	
		var bWidth = Math.floor((navbar._width - 3) / navLength); // button width = total width / number of buttons
		var bHeight = navbar._height;
		
		//trace("WW : "+navbar._width+" :: "+ navLength+" :: "+bWidth);
		for(var i=0;i<navLength;i++){
			
			navbar.attachMovie("navbar_button_mc", "nb"+i, navbar.getNextHighestDepth(), {_x:0, _y:-2});	
			
			// switch this to a super rollover menuItem
		/* 

			var _titleObj:Object = new Object(); // new stuff
			_titleObj = navArray[i]; 
			var _mcObj:Object = new Object();
			_mcObj = navbar;
				
		navbar.attachMovie("menuItem", "nb"+i, navbar.getNextHighestDepth(), {_title:_titleObj, _mc:_mcObj, _justify:justify});//(TF_HEIGHT * i)
		 
		*/

		
			navbar["nb"+i].nameNum = i+1;
			navbar["nb"+i].nameString = navArray[i];
			
			navbar["nb"+i].top_tf_mc.tf.text = navbar["nb"+i].bottom_tf_mc.tf.text = navArray[i];
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
		trace("OVER "+this.nameString);
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
			var testObj:Object = new Object(); // new stuff
			testObj = this.nameString;
			BroadCaster.broadcastEvent("launchNewPage", testObj, true);
	}

}