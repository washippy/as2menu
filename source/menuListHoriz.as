//
//  menuListHoriz builds stack of menu items ...
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

/*

menuList 
	menuItem
		menuItemWord
			tf
			mask
		bkg_mc

*/

import mx.utils.Delegate;
import utils.BroadCaster;

class menuListHoriz extends MovieClip {
	
	private var listArray:Array;	
	private var menulistH:MovieClip;
	private var TF_WIDTH:Number=105;


	public function menuListHoriz(_list:Array, _mc:MovieClip){
		//mc=_mc;
		//menuitem = new menuItem();
		menulistH = _mc.createEmptyMovieClip("mIH", _mc.getNextHighestDepth());
		// trace("menu List // trace this :: "+_list+" :: ");
		listArray = _list;
		
		
	//	BroadCaster.register(this,"horizSpacer");
		
		buildList(_mc);

	}
	
	private function buildList(_mc:MovieClip){
		for(var num = 0; num<listArray.length ; num++){
			//var menu:menuItem = new menuItem("HEY IT WORKED", this);
			// trace("----------||||||||||---------" +listArray[num].link);
			var _titleObj:Object = new Object();
			_titleObj = listArray[num].title;
			
			var _linkObj:Object = new Object();
				_linkObj = listArray[num].link;
			
			var _mcObj:Object = new Object();
			_mcObj = menulistH;

				
			menulistH.attachMovie("menuItemHoriz", "menuItemH"+num, menulistH.getNextHighestDepth(), {_x:0, _y:0, _title:_titleObj, _link:_linkObj, _mc:_mcObj, nameNum:num});
			
		}
		spaceEmOut();
	}

	 
	 
	private function spaceEmOut():Void {
		for(var num = 0; num<listArray.length ; num++){
			// trace("------- - -  - --------"+menulistH["menuItemH"+num].fullWidth);
			if(num!=0){
				menulistH["menuItemH"+num]._x = menulistH["menuItemH"+(num-1)]._x + menulistH["menuItemH"+(num-1)].fullWidth+10;
			}
		}
	}
	
	public function disable(){
		// trace("menu list disable ------------- ");
		for(var num = 0; num<listArray.length ; num++){
			menulistH["menuItemH"+num].removeMovieClip();
			}

	}

}