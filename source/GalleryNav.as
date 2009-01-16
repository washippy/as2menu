//
//  galleryNav builds a stack of pics.  . i hope
//


import mx.utils.Delegate;
import utils.BroadCaster;
import flash.geom.ColorTransform;
import flash.geom.Transform;

class GalleryNav extends MovieClip {
	
	private var listArray:Array;	
	private var gNav:MovieClip;
	private var gallery:MovieClip;
		private var larger:MovieClip;

	private var image_mcl:MovieClipLoader;
	
	private var loader:MovieClip;
	private var clicker:MovieClip;
	
	private var TF_WIDTH:Number=105;
	private var startHere:Number;
	private var HOTPIC:Number;
	
	
	private var G_unselected:ColorTransform;
	private var G_selected:ColorTransform;
	
	
	public function GalleryNav(_list:Array, _mc:MovieClip){
		// trace("GalleryNav CONSTRUCTOR"+newline+"_______________"+newline)
		
		gNav=_mc;
		gallery = _mc._parent;
		loader = _mc._parent.empty_mc;
		
		// trace(loader._x+"<--------------------------------------");
		var x1 = loader._x;
		var y1 = loader._y;
		var x2 = loader._x + 533;
		var y2 = loader._y + 300;
		gallery.createEmptyMovieClip("clicker", gallery.getNextHighestDepth());
		gallery.clicker.beginFill(0xFF0000, 0);
		gallery.clicker.moveTo(x1, y1);
		gallery.clicker.lineTo(x2, y1);
		gallery.clicker.lineTo(x2, y2);
		gallery.clicker.lineTo(x1, y2);
		gallery.clicker.lineTo(x1, y1);
		gallery.clicker.endFill();
		
		gallery.clicker.onPress=function(){
			// trace(this)	
			BroadCaster.broadcastEvent("nextPic");
		}
		larger =  _mc._parent.larger_mc;
		image_mcl = new MovieClipLoader();
		
			
			G_unselected = new ColorTransform( 1,1,1,1,0,0,0,0); //greyed out
			G_selected = new ColorTransform(0, 0, 0, 1, 122, 25, 47, 0);
		
		// trace("LOADER X :: : : : : ::: : : :  "+_mc)
		//menuitem = new menuItem();
		//gMenulist = _mc.createEmptyMovieClip("gml", _mc.getNextHighestDepth());
		listArray = _list;		
		buildList(_mc);
		
		BroadCaster.register(this,"loadPic");
		BroadCaster.register(this,"nextPic");
		BroadCaster.register(this,"prevPic");
		BroadCaster.register(this,"enlargePic");
		
		/*galleryArray.push({
			filename:sXml.main.pic[i].attributes.filename,
			picdate:sXml.main.pic[i].attributes.date,
			caption:sXml.main.pic[i].attributes.caption});*/

	}
	
	private function buildList(_mc:MovieClip){
		
		gNav.attachMovie("menuItemGalleryButton", "back", gNav.getNextHighestDepth(), {_x:0, _y:0, _title:"BACK"});
		gNav.attachMovie("menuItemGalleryButton", "next", gNav.getNextHighestDepth(), {_x:30, _y:0, _title:"NEXT"});
		gNav.attachMovie("menuItemGalleryButton", "larger", gNav.getNextHighestDepth(), {_x:490, _y:0, _title:"LARGER"});
		
		startHere = gNav.next._x + 50;
		
		for(var num = 0; num<listArray.length ; num++){
			// trace("---------GGGGGGGGG---------" +listArray[num].filename);
			var _filenameObj:Object = new Object();
				_filenameObj = listArray[num].filename;
			
			var _dateObj:Object = new Object();
				_dateObj = listArray[num].picdate;
			
			var _capObj:Object = new Object();
				_capObj = listArray[num].caption;

				// attach all the pic num buttons
		gNav.attachMovie("menuItemGallery", "menuItemG"+num, gNav.getNextHighestDepth(), {_x:0, _y:0, _filename:_filenameObj, _date:_dateObj, _caption:_capObj, nameNum:(num+1)});
			
		}
		spaceEmOut();
	}


	private function spaceEmOut():Void {
		for(var num = 0; num<listArray.length ; num++){
			// trace("------- - -  - --------"+gNav["menuItemG"+num].fullWidth);
			if(num!=0){
				gNav["menuItemG"+num]._x = gNav["menuItemG"+(num-1)]._x + gNav["menuItemG"+(num-1)].fullWidth+4;
			}else{
					gNav["menuItemG"+num]._x = startHere;
			}
		}
		loadPic(); // load pic number one
	}
	
	public function loadPic(x:Object){
		// trace("LOAD PIC  : "+x.clip);
		
		if(x){
			//trace("LOAD PIC  : "+loader);
			image_mcl.loadClip(listArray[x.num].filename, loader);
			HOTPIC = x.num;

		}else{
			//trace("LOAD PIC 2 : "+listArray[0].filename+" :: "+loader);
			image_mcl.loadClip(listArray[0].filename, loader);
			HOTPIC = 0;
		}
		managePicNav();
		
	
	}
	
	
	private function nextPic(){
		// trace("NEXT ------------- "+HOTPIC);
		if(HOTPIC==(listArray.length-1)){
			HOTPIC=0;
		}else{
			HOTPIC++;
		}
		image_mcl.loadClip(listArray[HOTPIC].filename, loader);
		managePicNav();
		
	}
	
	private function prevPic(){
			if(HOTPIC==0){
				HOTPIC=(listArray.length-1);
			}else{
				HOTPIC--;
			}
		// trace("PREV ------------- "+HOTPIC);
		image_mcl.loadClip(listArray[HOTPIC].filename, loader);
		managePicNav();
		
	}
	private function enlargePic(){
		// trace("ENLARGE ------------- "+HOTPIC);
		var str = listArray[HOTPIC].filename;
		var strike=str.slice(0,-4);
		var newstr = strike+"lg.jpg";
		// trace("TEST STRING "+strike);
		//image_mcl.loadClip(newstr, larger);
//		getURL("http://www.mtzion.org"+newstr, "_blank")
		getURL(newstr, "_blank")



	}
	
	private function managePicNav(){
	
			
		// trace("MANAGE PIC NAV ------"+HOTPIC);
		for(var num = 0; num<listArray.length ; num++){
			if(HOTPIC==num){
				//menulist["menuItem"+num].SELECTED = true;	
				var trans:Transform = new Transform(gNav["menuItemG"+num]);
				trans.colorTransform = G_selected;
		
			}else{
				//menulist["menuItem"+num].SELECTED = false;
				var trans:Transform = new Transform(gNav["menuItemG"+num]);
				trans.colorTransform = G_unselected;
							
			}
		}
		
	}

	public function disable(){
		trace("GN  disable -------------");
		for(var num = 0; num<listArray.length ; num++){
			gNav["menuItemG"+num].removeMovieClip();
			}
		gNav.back.removeMovieClip();
		gNav.next.removeMovieClip();
		gNav.larger.removeMovieClip();
		image_mcl.unloadClip(loader);
		gallery.clicker.removeMovieClip();
		
		listArray = [];
	}

}