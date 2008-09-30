/*
//
//  Created by William Shippy on 2008-09-28.
//  Pastor Pic
//

TO DO
SPANISH RELOAD
GLOBAL FADE IN TIMING

*/
import mx.utils.Delegate;
import caurina.transitions.*;

class PastorPic extends MovieClip{
	
	private var pastorpic_mc:MovieClip;
	private var __mcImageLoader:MovieClipLoader;
	private var loadImageListener:Object = new Object();	

	private function PastorPic(){
		this._alpha=0;		
		trace("PASTOR PIC");

		loadImageListener = new Object();
		__mcImageLoader = new MovieClipLoader();
		setUpImage();
		
		__mcImageLoader.loadClip(_global.assetPath + _global.leftColumnPicPath, pastorpic_mc);
	}
	
	
	private function setUpImage():Void {

		loadImageListener.onLoadStart = function(target_mc:MovieClip, httpStatus:Number):Void {}		
		loadImageListener.onLoadComplete = function(target_mc:MovieClip, httpStatus:Number):Void {
			//trace("PASTOR PIC COMPLETE "+target_mc);
			} 
		loadImageListener.onLoadInit = Delegate.create(this, imageLoaded);
		
		loadImageListener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
				//trace("progress "+bytesLoaded);
		}
		this.__mcImageLoader.addListener(loadImageListener);
	}
	
	private function imageLoaded():Void {
		//trace("PASTOR IMAGE LOADED");
		Tweener.addTween(this, {_alpha:100, delay:2.5, time:1.1, transition:"easeOut"});
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