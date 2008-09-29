/*		PromoBar	*/
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;


class PromoBar extends MovieClip{
	
	private var promoArray:Array;
//	private var promo_mc:MovieClip;
	private var promo_app_mc:MovieClip;
	private var promomask_mc:MovieClip;
	
	private var promoarrow_right:MovieClip;
	private var promoarrow_left:MovieClip;
	
	private var CLIP:MovieClip;
	private var PROMOTOTAL:Number;
	private var CURRENTLEFTPROMO:Number=1;
	function PromoBar(_promoArray:Array, _clip:MovieClip){
		CLIP = _clip;
		promoArray = _promoArray;
		trace("PROMO BAR CONSTRUCTOR :"+PROMOTOTAL);
		PROMOTOTAL=promoArray.length;
		fireItUp();
	}
	
	public function fireItUp(){
		trace("FIRE IT UP "+CLIP.promo_app_mc);

		
		var promoholder:MovieClip = CLIP.promo_app_mc.createEmptyMovieClip("promoholder", this.getNextHighestDepth());
		promoholder._x +=20;
		/*
		promoBarArray.push({
			headline:_oXml.promobar.item[z].attributes.headline,
			assetname:_oXml.promobar.item[z].attributes.assetname,
			copy:_oXml.promobar.item[z].data
			});
		*/
	
		for(var i=0;i<PROMOTOTAL; i++){
			
			var _headlineObj = promoArray[i].headline;
			var _bodyCopyObj = promoArray[i].copy;
			var _assetName = promoArray[i].assetname;  ////////// PUT THESE IN
			
			trace(i+"promo"+promoArray[i].headline);
			promoholder.attachMovie("promo_mc", "promo_mc"+i, promoholder.getNextHighestDepth(), {_x:(260*i)+ (10*i), _y:15, headline:_headlineObj, bodyCopy:_bodyCopyObj, assetName:_assetName});
			
		} 
		
		
	
		promoholder.setMask(CLIP.promo_app_mc.promomask_mc);
	
		manageArrows();
		}
	
	private function manageArrows(){
		trace("MANAGE ARR");
	
	/* 
		var pw =promoholder._width;
			var chunk = pw / PROMOTOTAL;
			var leftX = promoholder._x;
			var rightX = pw - ((chunk *3) + (20)); // total width - 3 : (the 3 that are showing +  2 buffers?) 
	*/
		/// account for buffer
		if(CURRENTLEFTPROMO == 1){
			addREvents();
			removeLEvents();
		} else if(CURRENTLEFTPROMO<=PROMOTOTAL-3){
			addREvents();
			addLEvents();
			
		}else{
			removeREvents();
			addLEvents();
		}
		
		
		
	}
	
	private function addREvents(){
		trace("ADD R EV"+CLIP.promo_app_mc.promoarrow_right._alpha);
		CLIP.promo_app_mc.promoarrow_right._alpha=100; // tween
		CLIP.promo_app_mc.promoarrow_right.onRollOver = Delegate.create(this, rArrowRollOver);
		CLIP.promo_app_mc.promoarrow_right.onRollOut = Delegate.create(this, rArrowRollOut);
		CLIP.promo_app_mc.promoarrow_right.onPress = Delegate.create(this, rArrowPress);
		CLIP.promo_app_mc.promoarrow_right.useHandCursor = true;
		
		
	}
	private function removeREvents(){
		trace("R REMOVED");
		CLIP.promo_app_mc.promoarrow_right._alpha=50; // tween
		delete CLIP.promo_app_mc.promoarrow_right.onRollOver;
		delete CLIP.promo_app_mc.promoarrow_right.onRollOut;
		delete CLIP.promo_app_mc.promoarrow_right.onPress;
		CLIP.promo_app_mc.promoarrow_right.useHandCursor = false;
	}
	
	
	
	private function addLEvents(){
		trace("ADD L EV"+CLIP.promo_app_mc.promoarrow_left._alpha);
		CLIP.promo_app_mc.promoarrow_left._alpha=100; // tween
		CLIP.promo_app_mc.promoarrow_left.onRollOver = Delegate.create(this, lArrowRollOver);
		CLIP.promo_app_mc.promoarrow_left.onRollOut = Delegate.create(this, lArrowRollOut);
		CLIP.promo_app_mc.promoarrow_left.onPress = Delegate.create(this, lArrowPress);
		CLIP.promo_app_mc.promoarrow_left.useHandCursor = true;
	}
	private function removeLEvents(){
		trace("L REMOVED");
		CLIP.promo_app_mc.promoarrow_left._alpha=50; // tween
		delete CLIP.promo_app_mc.promoarrow_left.onRollOver;
		delete CLIP.promo_app_mc.promoarrow_left.onRollOut;
		delete CLIP.promo_app_mc.promoarrow_left.onPress;
		CLIP.promo_app_mc.promoarrow_left.useHandCursor = false;
	}
	
	
	private function lArrowPress(){
		var newX = CLIP.promo_app_mc.promoholder._x  - (CLIP.promo_app_mc.promoholder._width/PROMOTOTAL); //FUZZY MATH
		Tweener.addTween(CLIP.promo_app_mc.promoholder, {time:1, transition:"linear", _x:newX});
		CURRENTLEFTPROMO++;
		manageArrows();
	}
	private function lArrowRollOver(){
		
	}
	private function lArrowRollOut(){
		
	}
	
	private function rArrowPress(){
		var newX = CLIP.promo_app_mc.promoholder._x  + (CLIP.promo_app_mc.promoholder._width/PROMOTOTAL); //FUZZY MATH
		Tweener.addTween(CLIP.promo_app_mc.promoholder, {time:1, transition:"easeOut", _x:newX});
		CURRENTLEFTPROMO++;
		manageArrows();
		
	}
	private function rArrowRollOver(){
	trace("ARR OVER");	
	}
	private function rArrowRollOut(){
		
	}
}