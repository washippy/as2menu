
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.BroadCaster;



class MenuItemGalleryButton extends MovieClip {
	
	private var _title:String;

	
	private var nameNum:Number;
	
	private var _mc:MovieClip; // listHolder
	
	private var mItemGB:MovieClip;
	
	private var bottom_tf_mc:MovieClip;
	private var top_tf_mc:MovieClip;
	private var bkg_mc:MovieClip;
	private var mask_mc:MovieClip;
	
	private var STARTX:Number;
	private var STARTY:Number;
	private var TF_HEIGHT:Number=15;
	public var fullWidth:Number=0;

	private var itemArray:Array;
	
	public function MenuItemGalleryButton(){  // _title

		STARTX = this._x;
		STARTY = this._y;
		mItemGB = this;
		
		// trace(_title + " ::::::: ::: M I G B :::: ::::: ")
	
		parseTitleHoriz(_title);
			
 	}
	
	

	 
	private function parseTitleHoriz(_t:String){
	//	trace("HORIZ       +++++++  "+_t);
		itemArray = _t.split(" ");	
	//	trace("HORIZ       +++++++  "+itemArray[0]);
		
		for(var i =0 ; i< itemArray.length; i++){
				// trace("THIS ONES GONNA POP       +++++++  "+i);
		
			mItemGB.attachMovie("menuItemWord", "menuItemWord"+i, mItemGB.getNextHighestDepth(), {_x:0, _y:0, _title:itemArray[i]}); // move it later;
			
			
			if(i!=0){	
				mItemGB["menuItemWord"+i]._x = mItemGB["menuItemWord"+(i-1)]._x +  mItemGB["menuItemWord"+(i-1)].top_tf_mc.tf._width;
			}
			
			mItemGB["menuItemWord"+(i)].top_tf_mc.tf.autoSize="left";
			fullWidth +=mItemGB["menuItemWord"+(i)].top_tf_mc.tf._width;
			
		}
		
		mItemGB.mask_mc._width =fullWidth;
	
		popBKG();
	}
	

	
	private function popBKG(){
	
		// BUILD hitarea 
		mItemGB.attachMovie("bkg_mc", "bkg_mc", mItemGB.getNextHighestDepth(), {_x:0, _y:0, _width:fullWidth}); // move it later
		mItemGB.bkg_mc._x= 0;
			 

			
		addEvents();
	}
	
	
   	private function addEvents(){
		//trace("	ADD EVENTS " +mItemGB.bkg_mc);
			for(var i =0 ; i< itemArray.length; i++){
				mItemGB.bkg_mc.onRollOver = Delegate.create(mItemGB, mRollOver);
				mItemGB.bkg_mc.onRollOut = Delegate.create(mItemGB, mRollOut);
				mItemGB.bkg_mc.onPress = Delegate.create(mItemGB, mPress);
				mItemGB.bkg_mc.onRelease = Delegate.create(mItemGB, mRelease);
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
		// trace("MIGB ROLL EM "+limit)
		
		var count=0;		
		var timer=3;
		
		delete mItemGB.onEnterFrame;
		
			mItemGB.onEnterFrame = function(){
				if(timer<3){
					timer++;
				}else{
					timer=0;
					mItemGB["menuItemWord"+count].gotoAndPlay("over");
					count++;
					if(count>=limit){
						delete mItemGB.onEnterFrame;
					}
				}
			}			
		
	}
	
	public function rollEmOut(){
		//trace("R OUT+++++++++++++");
		
		delete mItemGB.onEnterFrame;
		for(var i =0 ; i< itemArray.length; i++){
			mItemGB["menuItemWord"+i].gotoAndPlay("off");
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
		// trace("BOO "+ this._name);
		
		switch(this._name){
					case "next":
						BroadCaster.broadcastEvent("nextPic");
					break;
					
					case "back":
						BroadCaster.broadcastEvent("prevPic");
					break;
					
					case "larger":
						BroadCaster.broadcastEvent("enlargePic");
					break;
				}	
	}
	
	 
	
}