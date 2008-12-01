//
//  menuList builds stack of menu items ...
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

/*

var suckerArray:Array = new Array();
suckerArray[0]= "CHILDREN";
suckerArray[1]= "YOUTH";

suckerArray[2]= "YOUNG ADULT";
suckerArray[3]= "SINGLES";
suckerArray[4]= "GENERATION LIFE";
suckerArray[5]= "HILLTOPPERS";
suckerArray[6]= "CREATIVE ARTS";
suckerArray[7]= "MARRIAGE & FAMILY";
suckerArray[8]= "ESPANOL";


var ML:menuList= new menuList(suckerArray, this);

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
		
	/* 
		for(var i=0;i< _list.length;i++){
			   listArray[i] = _list[i].title;	
			} 
	*/

	
		
	//	for(var item in listArray){trace(listArray[item])}
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
			/*
			
			if its justify right or center
			
			
			else if horizontal
			
			*/
			
			if(justify=="horizontal"){
				
				menulist.attachMovie("menuItem", "menuItem"+num, menulist.getNextHighestDepth(), {_x:(num * 30), _y:0, _title:_titleObj, _pagename:_pageNameObj, _mc:_mcObj, _justify:justify, nameNum:num});
			}else{
				
					menulist.attachMovie("menuItem", "menuItem"+num, menulist.getNextHighestDepth(), {_x:0, _y:(TF_HEIGHT * num), _title:_titleObj, _pagename:_pageNameObj, _mc:_mcObj, _justify:justify, nameNum:num});
			}
			
		
		}

	}
	
	public function horizSpacer(clip:MovieClip){
		trace("H SPACER  -------------"+clip+newline+newline);
		
		for(var num = 1; num< clip.listArray.length; num++){
			clip.menulist["menuItem"+num]._x = clip.menulist["menuItem"+(num-1)]._x + clip.menulist["menuItem"+(num-1)]._width +10;
		}
	}
	
	public function disable(){
		trace("menu list disable -------------");
		for(var num = 0; num<listArray.length ; num++){
			menulist["menuItem"+num].removeMovieClip();
			}

	}

}