/*	NewsStory.as:  
	
TO DO :	


*/ 

import utils.XMLObject;
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;



class NewsStory extends MovieClip {


//	{headline:_hObj, date:_dObj, bodyCopy:_bcObj, link:_lObj});

//	private var headline:String;
//	private var date:String;
//	private var bodyCopy:String;
//	private var link:String;
	private var bCopy:String;	
	private var story_tf:TextField;
	private var more_button:Button;
	private var less_button:Button;
	public var popped:Boolean=false;
	private var styles:TextField.StyleSheet;
	private var TF_SHORT = 79;
	private var TF_EXTENDED;
	private function NewsStory(){
		// trace("NEWS STORY CONSTRUCTOR : "+this+newline+headline +newline+date+newline+bodyCopy+newline+link);
		// trace("NEWS STORY CONSTRUCTOR :::::::: "+newline+bCopy);

		//if (_global.lang == "SPANISH"){trace("SPAAAAANISH NEWS STORY")}else{}
			less_button._visible=false;
			
			BroadCaster.register(this,"updateMoreButton");
		
			styles = new TextField.StyleSheet();
			
			styles.setStyle("headline", {
			    color:'#7A192F', 
				fontFamily:'Univers 67 CondensedBold', 
			    fontSize:'11', 
			    fontWeight:'bold'
			});
			styles.setStyle("date", {
			    color:'#8EB8BF', 
				fontFamily:'Univers 57 Condensed', 
			    fontWeight:'bold', 
			    fontSize:'11'
			});
			styles.setStyle("copy", {
			    color:'#666666', 
				fontFamily:'Univers 57 Condensed', 
			    fontSize:'11'
			});
		
			styles.setStyle("a:link", {
			    color:'#7A192F'
			});
			styles.setStyle("a:hover", {
			    textDecoration:'underline'
			});


		more_button.onPress = Delegate.create(this, bOnPress);	
		less_button.onPress = Delegate.create(this, bLessOnPress);	
		
		popData();
	}
	private function bOnPress(){
		trace(TF_EXTENDED + " :: "+ TF_SHORT);
		Tweener.addTween(story_tf, {time:1.5, transition:"easeOut", _height:TF_EXTENDED, onUpdate:updateAllPositions});  /// fade in  news app
		less_button._visible=true;
		more_button._visible = false;
		popped = true;
	/* 
		reportPosition = function() {
				trace ("My _x is now " + this._x);
			};
			Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:reportPosition}); 
	Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:function() { trace ("My _x is now " + this._x); }});
	*/

	
	}
		private function bLessOnPress(){
		Tweener.addTween(story_tf, {time:1.5, transition:"easeOut", _height:TF_SHORT, onUpdate:updateAllPositions});  /// fade in  news app
		less_button._visible=false;
		more_button._visible = true;
		popped = false;
	/* 
		reportPosition = function() {
				trace ("My _x is now " + this._x);
			};
			Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:reportPosition}); 
	Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:function() { trace ("My _x is now " + this._x); }});
	*/

	
	}
	private function updateAllPositions(){
		// UPDATE SCROLLER TOO
		BroadCaster.broadcastEvent("updateScroller", this, false);
		BroadCaster.broadcastEvent("updatePositions", this, false);
		BroadCaster.broadcastEvent("updateMoreButton", this, false);
		
	}
	
	private function updateMoreButton(){
		trace("GO ------------ -- - -- -- - - - -");
		less_button._y = more_button._y = story_tf._y + story_tf._height + 4;
	}

	private function popData(){
		
		story_tf.styleSheet = styles;
	    story_tf.htmlText = bCopy;
		story_tf.autoSize=true;
		TF_EXTENDED =story_tf._height + 20;
		story_tf.autoSize=false;
		
		story_tf._height = TF_SHORT;
		
	//	this.story_tf.htmlText = bodyCopy;
	}
	
}