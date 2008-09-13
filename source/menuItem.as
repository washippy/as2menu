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
	private var _mc:MovieClip; // listHolder
	
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

		STARTX = this._x;
		STARTY = this._y;
		mItem = this;
		trace("MENU ITEM ::: "+mItem);
		
		//title = _title;"FREAK BOY IS GONE FOREVER";
		BroadCaster.register(this,"rollEmOver");
		BroadCaster.register(this,"rollEmOut");
		parseTitle(_title);
	}
	
	
	private function parseTitle(_t:String){

		trace("+++++++  "+_t);
		
		var fullWidth:Number=0;
		
		itemArray = _t.split(" ");
		for(var item in itemArray){trace("----- "+itemArray[item])};
		
		
		for(var i =0 ; i< itemArray.length; i++){
			
		///if(i!=0){
			mItem.attachMovie("menuItemWord", "menuItemWord"+i, 10+i, {_x:0, _y:0, _title:itemArray[i]}); // move it later;
			
			/// GET THESE SIZED and BKG MC AND MASKED;
			
			
		///}
		/*   	mItem.top_tf_mc.tf.text = itemArray[i];
			mItem.bottom_tf_mc.tf.text = itemArray[i];
			mItem.top_tf_mc.tf.autoSize = true;
			mItem.bottom_tf_mc.tf.autoSize = true;   */
		
			trace("TF WIDTH = "+ mItem["menuItemWord"+i]._width);
			fullWidth += mItem.top_tf_mc.tf._width;
			
			//trace("FULL W ="+ fullWidth);
			mItem.mask_mc._width = mItem.top_tf_mc.tf._width;
			
		//	trace(mItem.bkg_mc._width);
			
			if(i!=0){
			//	trace(i+" :: "+_mc);
				_mc["menuItem"+i]._x = _mc["menuItem"+(i-1)]._x +  _mc["menuItem"+(i-1)].top_tf_mc.tf._width;

			}
		//	trace("_mc width :"+_mc["menuItem"+i]._y);
		//	 trace(newline+newline+"+++++++++++++++++++++++"+newline+newline);
			
		}

		// BUILD hitarea 
		_mc.attachMovie("bkg_mc", "bkg_mc", 5, {_x:0, _y:0}); // move it later
		_mc.bkg_mc._width = fullWidth;
		addEvents();
		
	}
	 
	private function addEvents(){
		for(var i =0 ; i< itemArray.length; i++){
			_mc.bkg_mc.onRollOver = Delegate.create(_mc, mRollOver);
			_mc.bkg_mc.onRollOut = Delegate.create(_mc, mRollOut);
			_mc.bkg_mc.onPress = Delegate.create(_mc, mPress);
			_mc.bkg_mc.onRelease = Delegate.create(_mc, mRelease);
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
		delete _mc.engine.onEnterFrame;
		
		_mc.engine.onEnterFrame = function(){
			
			this._parent["menuItem"+count].gotoAndPlay("over");
			count++;
			if(count>=limit){
				delete _mc.engine.onEnterFrame;
			}
		}
	}
	
	public function rollEmOut(){
	//	trace("R OUT+++++++++++++");
		delete _mc.engine.onEnterFrame;
		for(var i =0 ; i< itemArray.length; i++){
			_mc["menuItem"+i].gotoAndPlay("off");
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