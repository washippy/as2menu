/*		Promo

*/
import caurina.transitions.*;
import caurina.transitions.properties.*;

class Promo extends MovieClip{
	private var promo:String;
	private var headline:String;
	private var bodyCopy:String;
	
	private var headline_tf:TextField;
	private var bodycopy_tf:TextField;
	private var OVER:TextFormat;
	private var OFF:TextFormat;


	private function Promo(){
		TextShortcuts.init();
		
		//trace("PROMO CONSTRUTCOR "+headline+" : "+bodyCopy);
		//headline_tf.text = headline;
		//bodycopy_tf.text = bodyCopy;
		OFF = new TextFormat(); 
		OVER = new TextFormat(); 
		OFF.color = 0x7A192F;
		OVER.color = 0x000000;
		this.headline_tf.setTextFormat(OFF);

	}
	
	private function onRollOver(){
		//this.headline_tf.setTextFormat(OVER);
		gotoAndPlay("over");
		trace(this._name+" over");
	}
	private function onRollOut(){
		//this.headline_tf.setTextFormat(OFF);
		gotoAndPlay("off");
		
		trace(this._name+" and out");
	}
	private function onPress(){
		trace(this._name+" press");
	}
	private function onRelease(){
		trace(this._name+" release");
	}
	
}