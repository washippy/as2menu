//
//  menuItem :: takes a string and makes it a menu item with rollover
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.BroadCaster;



class menuItem extends MovieClip {
	
	private var _title:String;
	
	private var _mc:MovieClip;
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
	
	public function menuItem(){  //_title:String, _mc:MovieClip
		mc = _mc; 
		STARTX = this._x;
		STARTY = this._y;
		mItem = this;
		trace("MENU ITEM ::: "+mItem+" :: "+_title);
		//title = _title;"FREAK BOY IS GONE FOREVER";
		BroadCaster.register(this,"rollEmOver");
		BroadCaster.register(this,"rollEmOut");
		parseTitle(_title);
	}
	
	
	private function parseTitle(_t:String){

		trace("+++++++++++++++++++++++"+mc)
		var fullWidth:Number=0;
		
		itemArray = _t.split(" ");
		for(var i =0 ; i< itemArray.length; i++){
			//mc.attachMovie("menuitem", "menuItem"+i, 10+i, {_x:0, _y:0}); // move it later
			mItem.   HOLY COW    top_tf_mc.tf.text = itemArray[i];
			mItem.bottom_tf_mc.tf.text = itemArray[i];
			mItem.top_tf_mc.tf.autoSize = true;
			mItem.bottom_tf_mc.tf.autoSize = true;
			trace("TF WIDTH = "+ mItem.top_tf_mc.tf._width);
			fullWidth += mItem.top_tf_mc.tf._width;
			trace("FULL W ="+ fullWidth);
			mItem.mask_mc._width = mItem.top_tf_mc.tf._width;
			
		//	trace(mItem.bkg_mc._width);
			
			if(i!=0){
				trace(i);
				mc.lH["menuItem"+i]._x = mc.lH["menuItem"+(i-1)]._x +  mc.lH["menuItem"+(i-1)].top_tf_mc.tf._width;

			}
		//	trace("mc width :"+mc["menuItem"+i]._y);
			
		}

		// BUILD hitarea 
		mc.lH.attachMovie("bkg_mc", "bkg_mc", 5, {_x:0, _y:0}); // move it later
		mc.lH.bkg_mc._width = fullWidth;
		addEvents();
		
	}
	 
	private function addEvents(){
		for(var i =0 ; i< itemArray.length; i++){
			mc.lH.bkg_mc.onRollOver = Delegate.create(mc, mRollOver);
			mc.lH.bkg_mc.onRollOut = Delegate.create(mc, mRollOut);
			mc.lH.bkg_mc.onPress = Delegate.create(mc, mPress);
			mc.lH.bkg_mc.onRelease = Delegate.create(mc, mRelease);
		}
	}
	
	private function mRollOver(){
		trace(this);
		// broadcast
		BroadCaster.broadcastEvent("rollEmOver", this, true);
		
	}
	
	
	public function rollEmOver(){
		var count=0;
	//	trace("R OVER+++++++++++++"+itemArray.length);
		var limit = itemArray.length;
		delete mc.engine.onEnterFrame;
		
		mc.engine.onEnterFrame = function(){
			
			this._parent["menuItem"+count].gotoAndPlay("over");
			count++;
			if(count>=limit){
				delete mc.engine.onEnterFrame;
			}
		}
	}
	
	public function rollEmOut(){
	//	trace("R OUT+++++++++++++");
		delete mc.engine.onEnterFrame;
		for(var i =0 ; i< itemArray.length; i++){
			mc.lH["menuItem"+i].gotoAndPlay("off");
		}
	}
	
	
	private function mRollOut(){
		BroadCaster.broadcastEvent("rollEmOut", this, true);
	}   		
	
	
	private function mRelease(){
		trace("BOO 2")
		
	}
	
	private function mPress(){
		trace("BOO")
	}
	
	 
	
}