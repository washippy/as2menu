/*
//
//  Created by William Shippy on 2008-09-28.
//  Pastor Pic
//

TO DO

GLOBAL FADE IN TIMING

*/
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.BroadCaster;


class PastorPic extends MovieClip{
	
	private var pastorphoto_mc:MovieClip;
	private var pastorpic_mc:MovieClip;
	
		private var FADEINDELAY:Number = 1; // seconds
		
		public var ready:Boolean=false;
		
	private var __mcImageLoader:MovieClipLoader;
	private var loadImageListener:Object = new Object();	

	public function PastorPic(_leftColumnPicPath:String, _mc:MovieClip){
		pastorphoto_mc = _mc.pastorphoto_mc;
		pastorpic_mc = _mc.pastorphoto_mc.pastorpic_mc;
		trace("PASTOR PIC "+pastorphoto_mc);
		
		pastorphoto_mc._alpha=0;		
		
		loadImageListener = new Object();
		__mcImageLoader = new MovieClipLoader();
		setUpImage();
		
		__mcImageLoader.loadClip(_global.assetPath + _leftColumnPicPath, pastorpic_mc);
	}
	
	
	private function setUpImage():Void {

		loadImageListener.onLoadStart = function(target_mc:MovieClip, httpStatus:Number):Void {}		
		loadImageListener.onLoadComplete = function(target_mc:MovieClip, httpStatus:Number):Void {
			trace("PASTOR PIC COMPLETE "+target_mc);
			} 
		loadImageListener.onLoadInit = Delegate.create(this, imageLoaded);
		
		loadImageListener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
				trace("progress "+bytesLoaded);
		}
		__mcImageLoader.addListener(loadImageListener);
	}
	
	private function imageLoaded():Void {
		trace("PASTOR IMAGE LOADED"+this.ready);
		this.ready=true;
	//	Tweener.addTween(pastorphoto_mc, {_alpha:100, delay:FADEINDELAY, time:1.1, transition:"easeOut"});
	}
	
	
	public function disable():Void{
		// trace(pastorpic_mc);
		var invisify:Function = function(_ob:Object){
			// trace("I I :"+_ob);
			_ob._visible=false;
			}
			
		Tweener.addTween(pastorphoto_mc, {time:1, transition:"easeOut", _alpha:0, onComplete:invisify, onCompleteParams:[this]});
		
	}
	public function enable():Void{
	
		this._visible=true;	
			Tweener.addTween(pastorphoto_mc, {_alpha:100, delay:FADEINDELAY, time:1.1, transition:"easeOut"});
	//	Tweener.addTween(pastorphoto_mc, {time:1, transition:"easeOut", _alpha:100});
		
	}
	
/* 
	private function onRollOver(){
		//this.headline_tf.setTextFormat(OVER);
		gotoAndPlay("over");
		//trace(this._name+" over");
	}
	private function onRollOut(){
		//this.headline_tf.setTextFormat(OFF);
		gotoAndPlay("off");
		
		//trace(this._name+" and out");
	}
	private function onPress(){
		//trace(this._name+" press");
	}
	private function onRelease(){
		//trace(this._name+" release");
	} 
*/


	
}