//
//  menuList builds stack of menu items ...
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

import mx.utils.Delegate;

class menuList extends MovieClip {
	private var mc:MovieClip;
	private var listArray:Array;
	private var listHolder:MovieClip;

	public function menuList(_list:Array, _mc:MovieClip){
		mc=_mc;
		listHolder = mc.createEmptyMovieClip("lH", mc.getNextHighestDepth());
		listArray = _list;
		for(var item in listArray){trace(listArray[item])}
		buildList();
	}
	
	private function buildList(){
		for(var num = 0; num<listArray.length ; num++){
			//var menu:menuItem = new menuItem("HEY IT WORKED", this);
			trace(num+" :: " +listHolder._x);
			var _title:Object = new Object();
			_title = "BOB WAS HERE";
			
			var _mc:Object = new Object();
			_mc = mc;
			
			listHolder.attachMovie("menuItem", "menuItem"+num, 10+num, {_x:0, _y:(10 * num), _title:_title, _mc:_mc});
		}

	}
}