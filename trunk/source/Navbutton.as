/*	NAVBUTTON

	
	
*/
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;
import Navbar;



class Navbutton extends MovieClip {

	private var nameID:String;
	public var selectedstate:Boolean = false;
	
	public function Navbutton(){
		trace("NAVBUTTON CONSTRUCTOR");	
	}
	
	
		

	public function Select(){
		this.gotoAndPlay("selected");
		selectedstate=true;
	} 

	public function unSelect(){
		this.gotoAndPlay("off");
		selectedstate=false;
	}
	
	
	private function onRollOver(){
		trace("OVER");
		if(!selectedstate){
			this.gotoAndPlay("over");		
		}
	}
	
	private function onRollOut(){
		//trace("OFF "+this);
		if(!selectedstate){
			this.gotoAndPlay("off");
		}		
	}
	
	private function onRelease(){
	//	manageEvents();
			
	}

	private function onPress(){
		if(selectedstate){
			return;
		}
		
		var testObj:Object = new Object(); // TESTING == FIX THIS
		testObj = this.nameID;
		BroadCaster.broadcastEvent("updateHotSection", testObj, false);
		
		BroadCaster.broadcastEvent("launchNewPage", testObj, false);
	}

}