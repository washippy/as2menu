/*		ButtonBar	*/
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;
import SWFAddress;


class ButtonBar extends MovieClip{
	
	private var rbbArray:Array;
	private var buttonbar_mc:MovieClip;
	private var TOTALBUTTONS:Number = 10;
	private var FADEINDELAY:Number = 1.5; // seconds
	private var CLIP:MovieClip;
	public var ready:Boolean=false;
	
	
	
	public function ButtonBar(_rbbArray:Array, _clip:MovieClip){
		CLIP = _clip;
		rbbArray = _rbbArray;
	//	fireItUp();
		ready = true;
	}
	
	public function fireItUp(){	
		trace("RBB FIRED UP   |||||||||||   |||||||||||||  "+CLIP)
		CLIP.buttonbar_mc.gotoAndPlay("IN");
		
		if (_global.lang == "SPANISH") {
		    	for (var x=1; x<=TOTALBUTTONS; x++) {
					CLIP.buttonbar_mc["b"+x].gotoAndStop("spanish");
				}
		} else {
				for (var x=1; x<=TOTALBUTTONS; x++) {
					CLIP.buttonbar_mc["b"+x].gotoAndStop("english");
				}
		}
		addEvents();
	}
	

	private function addEvents(){
		trace("AE "+CLIP.buttonbar_mc.b1._x)
		var rbbA:Array = rbbArray;
			for (var x=1; x<=TOTALBUTTONS; x++) {
				trace(x)
				CLIP.buttonbar_mc["b"+x].nameNum=x;
				
				CLIP.buttonbar_mc["b"+x].onRollOver = function() {
					this.bkg.gotoAndPlay("OVER");
				};

				CLIP.buttonbar_mc["b"+x].onRollOut = function() {
					this.bkg.gotoAndPlay("OFF");
				};

				CLIP.buttonbar_mc["b"+x].onPress = function() {
					this.bkg.gotoAndPlay("OFF");
					
					//trace(this.nameNum+" :: "+ rbbA[this.nameNum-1].section)
					if(rbbA[this.nameNum-1].section!=undefined && rbbA[this.nameNum-1].section!=""){ // if theres a section defined, go to it and leave
					
					//	_global.SUBLAUNCH = false; 
						SWFAddress.setValue(rbbA[this.nameNum-1].section);
						
						return;
					}
						//trace(this.nameNum+" :: "+ rbbA[this.nameNum-1].url)
					if(rbbA[this.nameNum-1].url!=undefined && rbbA[this.nameNum-1].url!=""){ // if theres a url defined, launch it
						SWFAddress.href(rbbA[this.nameNum-1].url, '_blank');
					}
				};
				
				

			}
	

		
		
	}
	private function removeEvents(){
		for(var x=1;x<=TOTALBUTTONS;x++){

			delete CLIP.buttonbar_mc["b"+x].onRollOver;
			delete CLIP.buttonbar_mc["b"+x].onRollOut;
			delete CLIP.buttonbar_mc["b"+x].onPress;

			}
	}
	

	public function disable():Void{
		removeEvents();	
		CLIP.buttonbar_mc.gotoAndStop(1);
	}

	public function enable():Void{
		fireItUp();
		CLIP.buttonbar_mc._visible=true;
	}
	
}