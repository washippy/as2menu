//
//  menuItem
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//
import mx.utils.Delegate;
//import caurina.transitions.properties.TextShortcuts;
import caurina.transitions.*;



class menuItem extends MovieClip {
	
	private var title:String;
	
	private var mc:MovieClip;
	private var mItem:MovieClip;

	
	private var bottom_tf_mc:MovieClip;
	private var top_tf_mc:MovieClip;
	private var bkg_mc:MovieClip;
	private var mask_mc:MovieClip;
	
	private var STARTX:Number;
	private var STARTY:Number;
	private var TF_HEIGHT:Number=15;

	var itemArray:Array;
	
	public function menuItem(_title:String, _mc:MovieClip){

		mc = _mc; 
		STARTX = this._x;
		STARTY = this._y;
		mItem = this;

		trace("MENU ITEM ::: ");
		title = "BILL WAS HERE FOO";
		 
		parseTitle(title);
	}
	
	
	private function parseTitle(_t:String){
		//itemArray= new Array();
		itemArray = _t.split(" ");
		
		for(var i =0 ; i< itemArray.length; i++){
			mc.attachMovie("menuItem", "menuItem"+i, 10+i, {_x:0, _y:0}); // move it later
			
			mc["menuItem"+i].top_tf_mc.tf.text = itemArray[i];
			mc["menuItem"+i].bottom_tf_mc.tf.text = itemArray[i];
			
			mc["menuItem"+i].top_tf_mc.tf.autoSize = mc["menuItem"+i].bottom_tf_mc.tf.autoSize = true;
			if(i!=0){
				mc["menuItem"+i]._x = mc["menuItem"+(i-1)]._x + mc["menuItem"+(i-1)]._width; //move it if it aint the first
			}
		}
		
		trace("mc width :"+mc._width);
		// widen hitarea and mask
		mc["menuItem"+i].bkg_mc._width = mc["menuItem"+i].mask_mc._width = mc._width;
	
	//	addEvents();
		
	}
	/* 
	private function addEvents(){
		mc.bkg_mc.onRollOver = Delegate.create(this, mRollOver);
		mc.bkg_mc.onRollOut = Delegate.create(this, mRollOut);
		mc.bkg_mc.onPress = Delegate.create(this, mPress);
		mc.bkg_mc.onRelease = Delegate.create(this, mRelease);
	}
	
	private function mRollOver(){
		trace(this+"  ::  "+itemArray.length);
			//_mc.mcPauseHit.onRollOver = Delegate.create(this, onPauseOver);
		//	Tweener.addTween(mc.menuItemTF1, {_y:-10, time:1, transition:"easeOutBounce"});
			
	  	for(var i =0 ; i< itemArray.length; i++){
						
			var clip:Array = Array(mc["menuItemTF"+i]);
			//trace(clip[0])
			//Tweener.addTween(myMovieClip, {_x:10, time:0.5});
		//	Tweener.addTween(mc["menuItemTF"+i], {_y:-10, time:1});

			
			Tweener.addTween(mc["menuItemTF"+i], { time:1, _y:-10, delay:(i*0.1), transition:"easeOut", onComplete:mAnimFinished});
			Tweener.addTween(mc["menuItemTFbottom"+i], { time:.25, _y:0, delay:(i*0.1), transition:"easeOut"});
			//mc["menuItemTF"+i].setTextFormat(over_FMT);
		}   
	
		//	Tweener.addTween(this["__thumb"+x], {_y:newY, time:1, delay:delaytime, transition:"easeOutBounce", onComplete:fAnimFinished});
			
	}
	private function mAnimFinished(mc:Array){
		trace(mc._name);
		for(var i =0 ; i< itemArray.length; i++){
		
		}
		mc.setTextFormat(over_FMT);
	}
	
	private function mRollOut(){
			for(var i =0 ; i< itemArray.length; i++){
				//mc["menuItemTFbottom"+i].setTextFormat(off_FMT);
				Tweener.removeAllTweens();
				
				mc["menuItemTF"+i]._y = 0;
				mc["menuItemTFbottom"+i]._y = 10;
			}
	}
	
	
	
	private function mRelease(){
		
	}
	
	private function mPress(){
		
	}
	
	 */
	
}