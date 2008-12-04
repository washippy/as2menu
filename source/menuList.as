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


	public function menuList(_list:Array, _mc:MovieClip, _justify:String){
		//mc=_mc;
		//menuitem = new menuItem();
		menulist = _mc.createEmptyMovieClip("mI", _mc.getNextHighestDepth());
		justify = _justify; // send this on to the menu items
		trace("menu List trace this :: "+_list+" :: "+justify);
		listArray = _list;
		
		
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

	
	public function disable(){
		trace("menu list disable -------------");
		for(var num = 0; num<listArray.length ; num++){
			menulist["menuItem"+num].removeMovieClip();
			}

	}

}