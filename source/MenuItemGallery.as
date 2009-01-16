
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.BroadCaster;



class MenuItemGallery extends MovieClip {
	
	private var _filename:String;
	private var _date:String;
	private var _caption:String;
	
	private var nameNum:Number;
	
	private var _mc:MovieClip; // listHolder
	
	private var mItemG:MovieClip;
	
	private var bottom_tf_mc:MovieClip;
	private var top_tf_mc:MovieClip;
	private var bkg_mc:MovieClip;
	private var mask_mc:MovieClip;
	
	private var STARTX:Number;
	private var STARTY:Number;
	private var TF_HEIGHT:Number=15;
	public var fullWidth:Number=0;

	private var itemArray:Array;
	
	public function MenuItemGallery(){  // _filename:_filenameObj, _date:_dateObj, _caption:_capObj, nameNum:num

		STARTX = this._x;
		STARTY = this._y;
		mItemG = this;
		
		// trace(_filename + " ::::::: ::: M I G :::: ::::: "+ nameNum)
	
		parseTitleHoriz(nameNum.toString());
			
 	}
	
	

	 
	private function parseTitleHoriz(_t:String){
	//	trace("HORIZ       +++++++  "+_t);
		itemArray = _t.split(" ");	
	//	trace("HORIZ       +++++++  "+itemArray[0]);
		
		for(var i =0 ; i< itemArray.length; i++){
		
			mItemG.attachMovie("menuItemWord", "menuItemWord"+i, mItemG.getNextHighestDepth(), {_x:0, _y:0, _title:itemArray[i]}); // move it later;
			if(i!=0){	
				mItemG["menuItemWord"+i]._x = mItemG["menuItemWord"+(i-1)]._x +  mItemG["menuItemWord"+(i-1)].top_tf_mc.tf._width;
			}
			mItemG["menuItemWord"+(i)].top_tf_mc.tf.autoSize="left";
			fullWidth +=mItemG["menuItemWord"+(i)].top_tf_mc.tf._width;
			
		}
		
		mItemG.mask_mc._width =fullWidth;
		// trace("BLAAAAAAAH "+fullWidth);
	
		popBKG();
	}
	

	
	private function popBKG(){
	/* 
		for(var i =0 ; i< itemArray.length; i++){
				mItemG.fullWidth += mItemG["menuItemWord"+i].wordWidth;
			} 
	*/

		// BUILD hitarea 
		mItemG.attachMovie("bkg_mc", "bkg_mc", mItemG.getNextHighestDepth(), {_x:0, _y:0, _width:fullWidth+2}); // move it later
		mItemG.bkg_mc._x= 0;
			
		addEvents();
	}
	
	
   	private function addEvents(){
		//trace("	ADD EVENTS " +mItemG.bkg_mc);
			for(var i =0 ; i< itemArray.length; i++){
				mItemG.bkg_mc.onRollOver = Delegate.create(mItemG, mRollOver);
				mItemG.bkg_mc.onRollOut = Delegate.create(mItemG, mRollOut);
				mItemG.bkg_mc.onPress = Delegate.create(mItemG, mPress);
				mItemG.bkg_mc.onRelease = Delegate.create(mItemG, mRelease);
			}
	}   
	

	
	private function mRollOver(){
		// trace("OVER "+this);
		rollEmOver();
		// broadcast
		//	BroadCaster.broadcastEvent("rollEmOver", this, true);
	}
	
	
	public function rollEmOver(){
		var limit = itemArray.length;
	//	trace("ROLL EM OVER"+limit)
		
		var count=0;		
		var timer=3;
		
		delete mItemG.onEnterFrame;
		
			mItemG.onEnterFrame = function(){
				if(timer<3){
					timer++;
				}else{
					timer=0;
					mItemG["menuItemWord"+count].gotoAndPlay("over");
					count++;
					if(count>=limit){
						delete mItemG.onEnterFrame;
					}
				}
			}			
		
	}
	
	public function rollEmOut(){
		//trace("R OUT+++++++++++++");
		
		delete mItemG.onEnterFrame;
		for(var i =0 ; i< itemArray.length; i++){
			mItemG["menuItemWord"+i].gotoAndPlay("off");
		}
		
	}
	
	
	private function mRollOut(){
		//trace("OUT "+this);
		rollEmOut();
		
	//	BroadCaster.broadcastEvent("rollEmOut", this, true);
	}   		
	
	
	private function mRelease(){
		// trace("BOO MIG BUTTON "+this);
		//this._parent.loadPic(this.nameNum);
		var _obj:Object = new Object();
			_obj.num = this.nameNum-1;
			_obj.clip = this;
		BroadCaster.broadcastEvent("loadPic", _obj , false);
		
	}
	
	private function mPress(){
	//	trace("BOO "+ this._link);
	//	getURL(this._link, "_blank");
	//	var _obj:Object = new Object();
	//	_obj.pageName = _pagename;
	//	_obj.nameNum = nameNum;
	//	BroadCaster.broadcastEvent("loadASubSection", _obj , false);
	/// JUST RELOAD TEXT AREA
		/////// get some ACTIONS in here
	//	manageList(   ???  );
	}
	
	 
	
}