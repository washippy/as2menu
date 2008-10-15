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
import utils.BroadCaster;


class PastorPic extends MovieClip{
	
	private var pastorpic_mc:MovieClip;
	
	private var pastorphoto_mc:MovieClip;
	
	
	private var __mcImageLoader:MovieClipLoader;
	private var loadImageListener:Object = new Object();	

	private function PastorPic(){
		this._alpha=0;		
		trace("PASTOR PIC");
		BroadCaster.register(this,"pastorPicDisable");
		BroadCaster.register(this,"pastorPicEnable");
		
		
		
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
	
	
	public function pastorPicDisable():Void{
		trace(pastorpic_mc);
		var invisify:Function = function(_ob:Object){
			trace("I I :"+_ob);
			_ob._visible=false;
			}
			
		Tweener.addTween(this, {time:1, transition:"easeOut", _alpha:0, onComplete:invisify, onCompleteParams:[this]});
		
	}
	public function pastorPicEnable():Void{
		var visify:Function = function(_ob:Object){
			trace(_ob);
			_ob._visible=true;
			}
			
		Tweener.addTween(this, {time:1, transition:"easeOut", _alpha:100, onComplete:visify, onCompleteParams:[this]});
		
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