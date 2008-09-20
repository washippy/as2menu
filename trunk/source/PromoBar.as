/*		PromoBar	*/
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;


class PromoBar extends MovieClip{
	
	private var promoArray:Array;
//	private var promo_mc:MovieClip;
	private var promo_app_mc:MovieClip;
	private var promomask_mc:MovieClip;
	
	private var CLIP:MovieClip;

	function PromoBar(_promoArray:Array, _clip:MovieClip){
		CLIP = _clip;
		promoArray = _promoArray;
		trace("PROMO BAR CONSTRUCTOR");
		
		fireItUp();
	}
	
	public function fireItUp(){
				trace("FIRE IT UP "+CLIP.promo_app_mc);

		
		var promoholder:MovieClip = CLIP.promo_app_mc.createEmptyMovieClip("promoholder", this.getNextHighestDepth());
		promoholder._x +=17;
		/*
		promoBarArray.push({
			headline:_oXml.promobar.item[z].attributes.headline,
			assetname:_oXml.promobar.item[z].attributes.assetname,
			copy:_oXml.promobar.item[z].data
			});
		*/
		
		
		for(var i=0;i<promoArray.length; i++){
			
			var _headlineObj = promoArray[i].headline;
			var _bodyCopyObj = promoArray[i].copy;
			var _assetName = promoArray[i].assetname;  ////////// PUT THESE IN
			
			trace(i+"promo"+promoArray[i].headline);
			promoholder.attachMovie("promo_mc", "promo_mc"+i, promoholder.getNextHighestDepth(), {_x:(260*i)+ (15*i), _y:15, headline:_headlineObj, bodyCopy:_bodyCopyObj, assetName:_assetName});
			
		} 
		
		
		
 

		promoholder.setMask(CLIP.promo_app_mc.promomask_mc);
		//theMaskee_mc.setMask(circleMask_mc);
	}
}