//
//  menuItem :: takes a string and makes it a menu item with rollover
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.BroadCaster;



class menuItemHoriz extends MovieClip {
	
	private var _title:String;
	private var _link:String;
	private var nameNum:Number;
	
	private var _mc:MovieClip; // listHolder
	
	private var mItemH:MovieClip;
	
	private var bottom_tf_mc:MovieClip;
	private var top_tf_mc:MovieClip;
	private var bkg_mc:MovieClip;
	private var mask_mc:MovieClip;
	
	private var STARTX:Number;
	private var STARTY:Number;
	private var TF_HEIGHT:Number=15;
	public var fullWidth:Number=0;

	private var itemArray:Array;
	
	public function menuItemHoriz(){  //_title:String, _pagename:Obj, _mc:MovieClip, _justify:String

		STARTX = this._x;
		STARTY = this._y;
		mItemH = this;
		
		trace(_title + " ::::::: ::::::: ::::: "+ nameNum)
	
		parseTitleHoriz(_title);
			
 	}
	
	

	 
	private function parseTitleHoriz(_t:String){
		trace("HORIZ       +++++++  "+_t);
		itemArray = _t.split(" ");	
		trace("HORIZ       +++++++  "+itemArray[0]);
		
		for(var i =0 ; i< itemArray.length; i++){
		
			mItemH.attachMovie("menuItemWord", "menuItemWord"+i, mItemH.getNextHighestDepth(), {_x:0, _y:0, _title:itemArray[i]}); // move it later;
			
			
			if(i!=0){	
				mItemH["menuItemWord"+i]._x = mItemH["menuItemWord"+(i-1)]._x +  mItemH["menuItemWord"+(i-1)].top_tf_mc.tf._width;
			}
			fullWidth +=mItemH["menuItemWord"+(i)].top_tf_mc.tf._width;
			
		}
		
		mItemH.mask_mc._width =fullWidth;
		trace("BLAAAAAAAH "+fullWidth);
	
		popBKG();
	}
	

	
	private function popBKG(){
	/* 
		for(var i =0 ; i< itemArray.length; i++){
				mItemH.fullWidth += mItemH["menuItemWord"+i].wordWidth;
			} 
	*/

	
		// BUILD hitarea 
		mItemH.attachMovie("bkg_mc", "bkg_mc", mItemH.getNextHighestDepth(), {_x:0, _y:0, _width:fullWidth+25}); // move it later
		mItemH.bkg_mc._x= 0;
			 

			
		addEvents();
	}
	
	
   	private function addEvents(){
		//trace("	ADD EVENTS " +mItemH.bkg_mc);
			for(var i =0 ; i< itemArray.length; i++){
				mItemH.bkg_mc.onRollOver = Delegate.create(mItemH, mRollOver);
				mItemH.bkg_mc.onRollOut = Delegate.create(mItemH, mRollOut);
				mItemH.bkg_mc.onPress = Delegate.create(mItemH, mPress);
				mItemH.bkg_mc.onRelease = Delegate.create(mItemH, mRelease);
			}
	}   
	

	
	private function mRollOver(){
		trace("OVER "+this);
		rollEmOver();
		// broadcast
	//	BroadCaster.broadcastEvent("rollEmOver", this, true);
	}
	
	
	public function rollEmOver(){
		var limit = itemArray.length;
		trace("OY"+limit)
		
		var count=0;		
		var timer=3;
		
		delete mItemH.onEnterFrame;
		
			mItemH.onEnterFrame = function(){
				if(timer<3){
					timer++;
				}else{
					timer=0;
					mItemH["menuItemWord"+count].gotoAndPlay("over");
					count++;
					if(count>=limit){
						delete mItemH.onEnterFrame;
					}
				}
			}			
		
	}
	
	public function rollEmOut(){
		//trace("R OUT+++++++++++++");
		
		delete mItemH.onEnterFrame;
		for(var i =0 ; i< itemArray.length; i++){
			mItemH["menuItemWord"+i].gotoAndPlay("off");
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
		trace("BOO "+ this._link);
		getURL(this._link, "_blank");
	//	var _obj:Object = new Object();
	//	_obj.pageName = _pagename;
	//	_obj.nameNum = nameNum;
	//	BroadCaster.broadcastEvent("loadASubSection", _obj , false);
	/// JUST RELOAD TEXT AREA
		/////// get some ACTIONS in here
	//	manageList(   ???  );
	}
	
	 
	
}