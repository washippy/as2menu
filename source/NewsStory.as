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
	private var style2:TextField.StyleSheet;
	
	private var newsWindow;
	
	private var TF_SHORT = 79;
	private var TF_EXTENDED;
	
	private var newspopper_mc:MovieClip;
	
	private function NewsStory(){
		 trace("NEWS STORY CONSTRUCTOR : "+this._parent._parent._parent.newspopper_mc+newline+"------------");//headline +newline+date+newline+bodyCopy+newline+link);
		// // trace("NEWS STORY CONSTRUCTOR :::::::: "+newline+bCopy);

		//if (_global.lang == "SPANISH"){// trace("SPAAAAANISH NEWS STORY")}else{}
			less_button._visible=false;
			newspopper_mc = this._parent._parent._parent.newspopper_mc;
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

			
				style2 = new TextField.StyleSheet();

				style2.setStyle("headline", {
				    color:'#7A192F', 
					fontFamily:'Univers 67 CondensedBold', 
				    fontSize:'14', 
				    fontWeight:'bold'
				});
				style2.setStyle("date", {
				    color:'#8EB8BF', 
					fontFamily:'Univers 57 Condensed', 
				    fontWeight:'bold', 
				    fontSize:'14'
				});
				style2.setStyle("copy", {
				    color:'#666666', 
					fontFamily:'Univers 57 Condensed', 
				    fontSize:'14'
				});

				style2.setStyle("a:link", {
				    color:'#7A192F'
				});
				style2.setStyle("a:hover", {
				    textDecoration:'underline'
				});
			
			
		more_button.onPress = Delegate.create(this, bOnPress);	
		less_button.onPress = Delegate.create(this, bLessOnPress);	
		
		popData();
	}
	private function bOnPress(){
		 trace(TF_EXTENDED + " :: "+ TF_SHORT);
		
		popNewsWindow();
		
		//Tweener.addTween(story_tf, {time:1.5, transition:"easeOut", _height:TF_EXTENDED, onUpdate:updateAllPositions});  /// fade in  news app
		//		less_button._visible=true;
		//		more_button._visible = false;
		//		popped = true; 

		
	/* 
		reportPosition = function() {
				// trace ("My _x is now " + this._x);
			};
			Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:reportPosition}); 
	Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:function() { // trace ("My _x is now " + this._x); }});
	*/

	
	}
		private function bLessOnPress(){
		Tweener.addTween(story_tf, {time:1.5, transition:"easeOut", _height:TF_SHORT, onUpdate:updateAllPositions});  /// fade in  news app
		less_button._visible=false;
		more_button._visible = true;
		popped = false;
	/* 
		reportPosition = function() {
				// trace ("My _x is now " + this._x);
			};
			Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:reportPosition}); 
	Tweener.addTween(myMovieClip, {_x:100, time:1, onUpdate:function() { // trace ("My _x is now " + this._x); }});
	*/

	
	}
	
	public function closeStory(){
		story_tf._height=TF_SHORT; 
		less_button._visible=false;
		more_button._visible = true;
		popped = false;
		updateAllPositions();
	}
	
	private function updateAllPositions(){
		// UPDATE SCROLLER TOO
		BroadCaster.broadcastEvent("updateScroller", this, false);
		BroadCaster.broadcastEvent("updatePositions", this, false);
		BroadCaster.broadcastEvent("updateMoreButton", this, false);
		
	}
	
	private function updateMoreButton(){
		// trace("GO ------------ -- - -- -- - - - -");
		less_button._y = more_button._y = story_tf._y + story_tf._height + 4;
	}


	private function popNewsWindow(){
		
		newspopper_mc.gotoAndPlay("IN");
	//	_root.attachMovie("newsWindow", "newsWindow", _root.getNextHighestDepth());
/* 
		newsWindow.beginFill(0xFFFFFF);
		newsWindow.lineStyle(5, 0x000000, 100);
		
		newsWindow.moveTo(10, 10);
		newsWindow.lineTo(100, 10);
		newsWindow.lineTo(100, 100);
		newsWindow.lineTo(10, 100);
		newsWindow.lineTo(10, 10);
		newsWindow.endFill(); 
*/


		
		
		//newspop_textboxes.newspop_header_tf
		
		newspopper_mc.newspop_textboxes.newspop_tf.styleSheet = style2;
	    newspopper_mc.newspop_textboxes.newspop_tf.htmlText = bCopy;
		newspopper_mc.newspop_textboxes.newspop_tf.autoSize=true;
				//newsWindow.bkg._height = newsWindow.story_tf._height+20; 
	
				//TF_EXTENDED =story_tf._height + 20;
				//story_tf.autoSize=false;
				
				//story_tf._height = TF_SHORT; 
	

		
		
	//	this.story_tf.htmlText = bodyCopy;
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