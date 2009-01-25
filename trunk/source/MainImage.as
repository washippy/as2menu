/*		MainImage

TO DO:
 	ROTATE?
	TIMING
	SPANISH

*/
import utils.BroadCaster;

class MainImage extends MovieClip{
	private var MAINIMAGEPATH:String;
	
	private var mainimage_mc:MovieClip;
	private var CLIP:MovieClip;
	public var ready:Boolean=false;

	public function MainImage(_MIP:String, _clip:MovieClip){
		
		BroadCaster.register(this,"reloadMainImage");
		
		MAINIMAGEPATH = _MIP;
		CLIP = _clip;
		trace("MAIN IMAGE AS LOAD : "+ CLIP.mainimage_mc._y +" :: "+ ready);
		//loadMainImage();
		ready = true;
	}
	
	public function loadMainImage(){
		CLIP.mainimage_mc.loadMovie(MAINIMAGEPATH);
	}
	
	public function reloadMainImage(){
		if(MAINIMAGEPATH != _global.mainImagePath){
			CLIP.mainimage_mc.loadMovie(_global.mainImagePath);
			MAINIMAGEPATH = _global.mainImagePath;
		}
	}
	
	public function enable(){
		loadMainImage();
	}
}