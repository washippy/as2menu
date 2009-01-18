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

	function MainImage(_MIP:String, _clip:MovieClip){
		
		BroadCaster.register(this,"reloadMainImage");
		
		MAINIMAGEPATH = _MIP;
		CLIP = _clip;
		trace("MAIN IMAGE AS LOAD : "+ CLIP.mainimage_mc._y);
		loadMainImage();
	}
	
	public function loadMainImage(){
		CLIP.mainimage_mc.loadMovie(MAINIMAGEPATH);
		
	}
	
	public function reloadMainImage(){
		CLIP.mainimage_mc.loadMovie(_global.mainImagePath);
	}
	
}