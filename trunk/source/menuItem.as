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

	private var intervalId:Number;
	private var count:Number = 0;
	private var maxCount:Number = 10;
	private var duration:Number = 20;
	
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
			mc.attachMovie("menuitem", "menuItem"+i, 10+i, {_x:0, _y:0}); // move it later
			
			mc["menuItem"+i].top_tf_mc.tf.text = itemArray[i];
			mc["menuItem"+i].bottom_tf_mc.tf.text = itemArray[i];
			
			mc["menuItem"+i].top_tf_mc.tf.autoSize = true;
			mc["menuItem"+i].bottom_tf_mc.tf.autoSize = true;
			
		//	trace(mc["menuItem"+i].bkg_mc._width);
			
			mc["menuItem"+i].bkg_mc._width = mc["menuItem"+i].top_tf_mc.tf._width;
			
		//	trace(mc["menuItem"+i].bkg_mc._width);
			
			if(i!=0){
				mc["menuItem"+i]._x = mc["menuItem"+(i-1)]._x + mc["menuItem"+(i-1)].bkg_mc._width; //move it if it aint the first
			}
		//	trace("mc width :"+mc["menuItem"+i]._y);
			
		}

		// widen hitarea and mask
		 mc["menuItem"+i].mask_mc._width = mc["menuItem"+i].bkg_mc._width;
	
		addEvents();
		
	}
	 
	private function addEvents(){
		for(var i =0 ; i< itemArray.length; i++){
			mc["menuItem"+i].onRollOver = Delegate.create(mc, mRollOver);
			mc["menuItem"+i].onRollOut = Delegate.create(mc, mRollOut);
			mc["menuItem"+i].onPress = Delegate.create(mc, mPress);
			mc["menuItem"+i].onRelease = Delegate.create(mc, mRelease);
		}
	}
	
	private function mRollOver(){
		trace(this);
		var mL = this.menu.itemArray.length;
	//	clearInterval(intervalId);
		intervalId = setInterval(this, "mRGP", 200);
	}
	
	
	public function mRGP(){
		trace("RGP+++++++++++++"+intervalId);
	//	clip.gotoAndPlay("over");
		if(count >= itemArray.length) {
		 	clearInterval(intervalId);
		 }
		 count++;
		
	}
	
	private function mAnimFinished(mc:Array){
		trace(mc._name);
		for(var i =0 ; i< itemArray.length; i++){
		
		}
	//	mc.setTextFormat(over_FMT);
	}
	
	private function mRollOut(){
		
		this.gotoAndPlay("off");
		
		/*   	for(var i =0 ; i< itemArray.length; i++){
				//mc["menuItemTFbottom"+i].setTextFormat(off_FMT);
				Tweener.removeAllTweens();
				
				mc["menuItemTF"+i]._y = 0;
				mc["menuItemTFbottom"+i]._y = 10;
			}
			*/
			
	}   		
	
	
	
	private function mRelease(){
		
	}
	
	private function mPress(){
		
	}
	
	 
	
}