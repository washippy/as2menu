//
//  menuList builds stack of menu items ...
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

class menuList extends MovieClip {
	
	private var listArray:Array;
	private var justify:String; // left or right
	
	private var menulist:MovieClip;
	private var TF_HEIGHT:Number=15;
	
	
	private var MI_unselected:Object = { ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0}; //greyed out
	private var MI_selected:Object = { ra: 0, rb: 122, ga: 0, gb: 25, ba: 0, bb: 47, aa: 100, ab: 0};
	
			

	public function menuList(_list:Array, _mc:MovieClip, _justify:String){
		//mc=_mc;
		//menuitem = new menuItem();
		menulist = _mc.createEmptyMovieClip("mI", _mc.getNextHighestDepth());
		justify = _justify; // send this on to the menu items
		trace("menu List trace this :: "+_list+" :: "+justify);
		listArray = _list;
		
				BroadCaster.register(this,"unselectList");

		BroadCaster.register(this,"horizSpacer");
		
		buildList(_mc);

	}
	
	private function buildList(_mc:MovieClip){
		for(var num = 0; num<listArray.length ; num++){
			//var menu:menuItem = new menuItem("HEY IT WORKED", this);
			//trace(num+" :: " +listHolder._x);
			var _titleObj:Object = new Object();
			_titleObj = listArray[num].title;
			
			var _pageNameObj:Object = new Object();
				_pageNameObj = listArray[num].name;
			trace( num + " DDDDDDDDDDDDDDDDDDDDDDDD "+ listArray[num].title);
			
			var _mcObj:Object = new Object();
			_mcObj = menulist;

				
			menulist.attachMovie("menuItem", "menuItem"+num, menulist.getNextHighestDepth(), {_x:0, _y:(TF_HEIGHT * num), _title:_titleObj, _pagename:_pageNameObj, _mc:_mcObj, _justify:justify, nameNum:num});
			
		}

	}

	private function unselectList(_exceptthisone):Void {
							trace("UNSELECT ======= =====" + listArray.length);




// listArray needs to be emptied out  .. .  multiple instances of this list are hangin around








		for(var num = 0; num<listArray.length ; num++){

			if(_exceptthisone == menulist["menuItem"+num].nameNum){
				menulist["menuItem"+num].SELECTED = true;
				
				var mi1color:Color = new Color(menulist["menuItem"+num]);

				mi1color.setTransform(MI_selected);
				
				
				
			}else{
				menulist["menuItem"+num].SELECTED = false;
				
				var mi2color:Color = new Color(menulist["menuItem"+num]);
				mi2color.setTransform(MI_unselected);

				
			}
		}
	}

	
	public function disable(){
		trace("menu list disable -------------");
		for(var num = 0; num<listArray.length ; num++){
			menulist["menuItem"+num].removeMovieClip();
			}

	}

}