/*		MainImage

TO DO:
 	ROTATE?
	TIMING
	SPANISH

*/

class MainImage extends MovieClip{
	private var MAINIMAGEPATH:String;
	private var mainimage_mc:MovieClip;
	private var CLIP:MovieClip;

	function MainImage(_MIP:String, _clip:MovieClip){
		MAINIMAGEPATH = _MIP;
		CLIP = _clip;
		trace("MAIN IMAGE AS LOAD : "+ CLIP.mainimage_mc._y);
		loadMainImage();
	}
	
	public function loadMainImage(){
		CLIP.mainimage_mc.loadMovie(MAINIMAGEPATH);
		
	}
}