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
	private var _justify:String; // left or right
	
	
	
	private var mItem:MovieClip;
	
	private var bottom_tf_mc:MovieClip;
	private var top_tf_mc:MovieClip;
	private var bkg_mc:MovieClip;
	private var mask_mc:MovieClip;
	
	private var STARTX:Number;
	private var STARTY:Number;
	private var TF_HEIGHT:Number=15;
	public var fullWidth:Number=0;

	var itemArray:Array;
	
	public function menuItem(){  //_title:String, _mc:MovieClip, _justify:String

		STARTX = this._x;
		STARTY = this._y;
		mItem = this;
		if(_justify=="left"){
			parseTitle(_title);	
		}else if(_justify=="right"){
			parseTitleRight(_title);	
		}else if(_justify=="center"){
			parseTitleCenter(_title);
		}
	}
	
	
	private function parseTitle(_t:String){
		//trace("+++++++  "+_t);
		itemArray = _t.split(" ");	
		for(var i =0 ; i< itemArray.length; i++){
		
			mItem.attachMovie("menuItemWord", "menuItemWord"+i, mItem.getNextHighestDepth(), {_x:0, _y:0, _title:itemArray[i]}); // move it later;
			
			
			if(i!=0){	
				mItem["menuItemWord"+i]._x = mItem["menuItemWord"+(i-1)]._x +  mItem["menuItemWord"+(i-1)].top_tf_mc.tf._width;
			}
			
		}
		
		mItem.mask_mc._width = mItem.top_tf_mc.tf._width;
		
		popBKG();
	}
	 
	private function parseTitleCenter(_t:String){
		trace("CENTER ||||||||||| | | | |  "+_t);
		itemArray = _t.split(" ");	
		
			for(var i = 0 ; i<itemArray.length; i++){
			trace(i + "ARR ++++++++++++++  "+itemArray[i]);
			
			mItem.attachMovie("menuItemWordCenter", "menuItemWord"+i, mItem.getNextHighestDepth(), {_x:(mItem._width/2), _y:0, _title:itemArray[i]}); // move it later;
			
			mItem.mask_mc._width = mItem.top_tf_mc.tf._width;
			
			if(i!=0){	
				mItem["menuItemWord"+i]._x = mItem["menuItemWord"+(i-1)]._x - mItem["menuItemWord"+(i)].top_tf_mc.tf._width;
			}else{
				mItem["menuItemWord"+i]._x = mItem["menuItemWord"+i].top_tf_mc.tf._width;
			}
			
			
		}	
		
		
		popBKG();
	}
	
	
	private function parseTitleRight(_t:String){
		//trace("RIGHT +++++++  "+_t);
		itemArray = _t.split(" ");	
		itemArray.reverse();
		
			for(var i = 0 ; i<itemArray.length; i++){
			trace(i + "ARR ++++++++++++++  "+itemArray[i]);
			
			
			mItem.attachMovie("menuItemWordRight", "menuItemWord"+i, mItem.getNextHighestDepth(), {_x:0, _y:0, _title:itemArray[i]}); // move it later;
		
		
			mItem.mask_mc._width = mItem.top_tf_mc.tf._width;
			
			if(i!=0){	
				mItem["menuItemWord"+i]._x = mItem["menuItemWord"+(i-1)]._x - mItem["menuItemWord"+(i)].top_tf_mc.tf._width;
			}else{
				mItem["menuItemWord"+i]._x = 0 - mItem["menuItemWord"+i].top_tf_mc.tf._width;
				
			}
			
			
		}	
		
		
		popBKG();
	}
	
	private function popBKG(){
		for(var i =0 ; i< itemArray.length; i++){
			mItem.fullWidth += mItem["menuItemWord"+i].wordWidth;
		}
		// BUILD hitarea 
		mItem.attachMovie("bkg_mc", "bkg_mc", mItem.getNextHighestDepth(), {_x:0, _y:0, _width:fullWidth+25}); // move it later
			//trace("ATTACHED? ============ "+mItem.bkg_mc.getDepth());
		if(_justify=="right"){
			mItem.bkg_mc._x= 0-mItem.bkg_mc._width;
		}else if(_justify=="center"){
			mItem._x= 0-mItem.bkg_mc._width;
			
		}
		addEvents();
	}
	
	
   	private function addEvents(){
		//trace("	ADD EVENTS " +mItem.bkg_mc);
			for(var i =0 ; i< itemArray.length; i++){
				mItem.bkg_mc.onRollOver = Delegate.create(mItem, mRollOver);
				mItem.bkg_mc.onRollOut = Delegate.create(mItem, mRollOut);
				mItem.bkg_mc.onPress = Delegate.create(mItem, mPress);
				mItem.bkg_mc.onRelease = Delegate.create(mItem, mRelease);
			}
	}   
	

	
	private function mRollOver(){
		//trace("OVER "+this);
		rollEmOver();
		// broadcast
	//	BroadCaster.broadcastEvent("rollEmOver", this, true);
	}
	
	
	public function rollEmOver(){
		var count=0;
		//trace("R OVER+++++++++++++"+itemArray.length);
		var limit = itemArray.length;
		delete mItem.onEnterFrame;
		
		if(_justify =="left"){
			mItem.onEnterFrame = function(){
				mItem["menuItemWord"+count].gotoAndPlay("over");
				count++;
				if(count>=limit){
					delete mItem.onEnterFrame;
				}
			}
		}else{
			count = limit; // switch a roo
			limit = 0;
			mItem.onEnterFrame = function(){
				mItem["menuItemWord"+count].gotoAndPlay("over");
				count--;
				if(count<limit){
					delete mItem.onEnterFrame;
				}
			}
		}
		

		
		
	}
	
	public function rollEmOut(){
		//trace("R OUT+++++++++++++");
		
		delete mItem.onEnterFrame;
		for(var i =0 ; i< itemArray.length; i++){
			mItem["menuItemWord"+i].gotoAndPlay("off");
		}
		
	}
	
	
	private function mRollOut(){
		//trace("OUT "+this);
		rollEmOut();
		
	//	BroadCaster.broadcastEvent("rollEmOut", this, true);
	}   		
	
	
	private function mRelease(){
		//trace("BOO 2 "+this)
		/////// get some ACTIONS in here
	}
	
	private function mPress(){
		//trace("BOO "+this)
		/////// get some ACTIONS in here
		
	}
	
	 
	
}