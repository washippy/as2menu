//
//  menuItemWord :: each word rollover from a stack
//
//  Created by Bill Shippy on 2008-09-03.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//
import mx.utils.Delegate;
import caurina.transitions.*;
import utils.BroadCaster;



class menuItemWord extends MovieClip {
	
	private var _title:String;  // the text
	private var _mc:MovieClip; // menuItem
	
	private var bottom_tf_mc:MovieClip;
	private var top_tf_mc:MovieClip;
	public var wordWidth:Number;
	
	private var STARTX:Number;
	private var STARTY:Number;
	private var TF_HEIGHT:Number=15;

	
	public function menuItemWord(){  //_title:String, _mc:MovieClip
		popText(_title);
	}
	
	
	private function popText(_text:String){

		trace("wwwww  "+_text);
		this.top_tf_mc.tf.text = _text;
		this.bottom_tf_mc.tf.text = _text;
		this.top_tf_mc.tf.autoSize = true;
		this.bottom_tf_mc.tf.autoSize = true;
		wordWidth = this.top_tf_mc.tf._width;
		
	}
 }