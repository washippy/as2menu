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
import flash.geom.ColorTransform;
import flash.geom.Transform;

class menuList extends MovieClip {
	
	static private var  _instance:menuList; 
	
	private var listArray:Array;
	private var mc:MovieClip;
	private var justify:String; // left or right
	
	private var menulist:MovieClip;
	
	private var TF_HEIGHT:Number=15;
	
	private var MI_unselected:ColorTransform;// = { ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0}; //greyed out
	private var MI_selected:ColorTransform;// = { ra: 0, rb: 122, ga: 0, gb: 25, ba: 0, bb: 47, aa: 100, ab: 0};

	private function menuList(){}
	
	static function getInstance():menuList{
		if(_instance == null){_instance=new menuList}
		return _instance;
	}
		
	public function init(_list:Array, _mc:MovieClip, _justify:String):Void{
		disable();
			listArray = [];
			listArray = new Array();
			listArray = _list;
			mc = _mc;
			justify = _justify;
			
			
			MI_unselected = new ColorTransform( 1,1,1,1,0,0,0,0); //greyed out
			MI_selected = new ColorTransform(0, 0, 0, 1, 122, 25, 47, 0);

			// (redMultiplier=1, greenMultiplier=1, blueMultiplier=1, alphaMultiplier=1, redOffset=0, greenOffset=0, blueOffset=0, alphaOffset=0)
			
			menulist = mc.createEmptyMovieClip("mI", mc.getNextHighestDepth());
			buildList();
	}

	//_list:Array, _mc:MovieClip, _justify:String

/* 
	public function getAmount():Number 
	{ 
	return _currentAmount; 
	} 


	public function setAmount(newAmount:Number):Void 
	{ 
	_currentAmount = newAmount 
	} 
 
*/


/* 


	static function set listArray(x:String){
		 _listArray = x;
	}
	static function get listArray(){
		return _listArray;
	} 
	
	static function set mc(x:MovieClip){
		 _mc = x;
	}
	static function get mc(){
		return _mc;
	}
	
	static function set justify(x:String){
		 _justify = x;
	}
	static function get justify(){
		return _justify;
	}
	 
*/

	
	private function buildList(){
		// trace( mc + " BBBB BBBB BBBB BBBB BBB BB BB B BB "+ justify);
		
		for(var num = 0; num<listArray.length ; num++){
			//var menu:menuItem = new menuItem("HEY IT WORKED", this);
			//trace(num+" :: " +listHolder._x);
			var _titleObj:Object = new Object();
			_titleObj = listArray[num].title;
			
			var _linkObj:Object = new Object();
				_linkObj = listArray[num].link;
		trace( num + " DDDDDDDDDDDDDDDDDDDDDDDD "+ listArray[num].link);
		
			var _pageNameObj:Object = new Object();
				_pageNameObj = listArray[num].name;
		//	trace( num + " DDDDDDDDDDDDDDDDDDDDDDDD "+ listArray[num].title);
			
			var _mcObj:Object = new Object();
			_mcObj = menulist;

				
			menulist.attachMovie("menuItem", "menuItem"+num, menulist.getNextHighestDepth(), {_x:0, _y:(TF_HEIGHT * num), _title:_titleObj, _link:_linkObj, _pagename:_pageNameObj, _mc:_mcObj, _justify:justify, nameNum:num});
			
		}

	}

	public function unselectList(_exceptthisone):Void {
		// trace("UNSELECT ======= =====");

		for(var num = 0; num<listArray.length ; num++){
			
			if(_exceptthisone == menulist["menuItem"+num].nameNum){
				menulist["menuItem"+num].SELECTED = true;
				var trans:Transform = new Transform(menulist["menuItem"+num]);
				trans.colorTransform = MI_selected;
			}else{
				menulist["menuItem"+num].SELECTED = false;
				var trans:Transform = new Transform(menulist["menuItem"+num]);
				trans.colorTransform = MI_unselected;
			}
		}
	}

	
	public function disable():Void{
		// trace("menu list disable -------------");
		for(var num = 0; num<listArray.length ; num++){
			menulist["menuItem"+num].removeMovieClip();
			}

	}

}