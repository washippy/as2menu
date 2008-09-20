/*		Promo

*/

class Promo extends MovieClip{
	private var promo:String;
	private var headline:String;
	private var bodyCopy:String;
	
	private var headline_tf:TextField;
	private var bodycopy_tf:TextField;


	function Promo(){
		trace("PROMO CONSTRUTCOR "+headline+" : "+bodyCopy);
		headline_tf.text = headline;
		bodycopy_tf.text = bodyCopy;
	}
	
}