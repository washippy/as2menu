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
	private var styles:TextField.StyleSheet;
	
	private function NewsStory(){
		// trace("NEWS STORY CONSTRUCTOR : "+this+newline+headline +newline+date+newline+bodyCopy+newline+link);
		// trace("NEWS STORY CONSTRUCTOR :::::::: "+newline+bCopy);

		//if (_global.lang = "SPANISH"){trace("SPAAAAANISH NEWS STORY")}else{}
		
		
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


		
		
		
		popData();
	}
	private function popData(){
		
		story_tf.styleSheet = styles;
	    story_tf.htmlText = bCopy;
		
	//	this.story_tf.htmlText = bodyCopy;
	}
	
	
}