/*	CalendarApp.as:  
	
TO DO :

BUG when you change MONTHS with little arrows, data doesnt change. .  . it keeps current month	
	
SCROLLER sucks
		
SPANISH SWITCH

*/ 

import utils.XMLObject;
import mx.utils.Delegate;
import utils.BroadCaster;
import caurina.transitions.*;



class CalendarApp extends MovieClip {

	private var XMLPATH:String="";
	private var cal_xml:XML;
	private var cXml:Object;
	private var myXmlObject:XMLObject;
	private var calApp:MovieClip;
	
	private var calArrow_right:MovieClip;
	private var calArrow_left:MovieClip;
	
    private var calendarTitle_tf:TextField;
	private var MASKHEIGHT:Number = 186;
	private var MASKY:Number = 14;
	
	//
	private var currentDay_tf:TextField;
	private var calscroller_mc:MovieClip;
	private var content_tf:TextField;
	private var content_tf_STARTY:Number =150;

	private var eventsArray:Array;

	private var startx:Number;
	private var starty:Number;
	
	private var w:Number;
	private var h:Number;		
	private var monthArray:Array;
	private var weekArray:Array;
	private var weekSArray:Array;
	                          
	private var tempDate:Date;	
	private var currentMonth;
	private var currentYear;
	private var curDay;
	private var curWDay;
	private var curMonth;
	private var curYear;

	private var current;
    private var currentLength;


	public function CalendarApp(passmealong:String, clip:MovieClip){
		 trace("Calendar APP CONSTRUCTOR");
		if (_global.lang = "SPANISH"){
			
		}else{
			
		}
		
		XMLPATH = "xml/"+passmealong;     /////  FIX THIS>?
		calApp = clip.calendar_app_mc;
		BroadCaster.register(this,"setEvents");
		BroadCaster.register(this,"writeScrollerEvents");
		
		monthArray = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
		weekArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		weekSArray = ["S", "M", "T", "W", "T", "F", "S"];
		
		// grab current date info
		tempDate = new Date ();	
		currentMonth = tempDate.getMonth();
		currentYear = tempDate.getFullYear();
		
		curDay = tempDate.getDate();
		curWDay = tempDate.getDay();
		curMonth = tempDate.getMonth();
		curYear = tempDate.getFullYear();
		
		// trace("today is: "+ weekArray[curWDay]+", " + monthArray[curMonth]+" "+curDay + " "+ curYear);
		
		getEventList();
		
		calApp.calArrow_right.onRelease = Delegate.create(this, rightArrowRelease);
		calApp.calArrow_left.onRelease = Delegate.create(this, leftArrowRelease);
		
		calApp.calscroller_mc.moreUP._visible=false;
		calApp.calscroller_mc.moreDOWN._visible=false;
		
	}
	
	private function getEventList():Void{

		cal_xml = new XML();
		cal_xml.ignoreWhite = true;
		cal_xml.load(XMLPATH); ////////////// add espANOL func later

		cal_xml.onLoad = Delegate.create(this, onXmlLoad);
		
	}
	
	private function onXmlLoad($success:Boolean):Void{
			if ($success) {
			
			// trace("load cal data :"+ $success);
							
			myXmlObject = new XMLObject();
			cXml = myXmlObject.parseXML(cal_xml);
			cXml = cXml.calendar; // xmlObject = root node...
			
			// trace("calendar data :" +cXml.item[0].data);
			
			startx = Number(cXml.settings.attributes.startx);
			starty = Number(cXml.settings.attributes.starty);
			w = Number(cXml.settings.attributes.width);
			h = Number(cXml.settings.attributes.height);
			
			//calApp.currentDay_tf.htmlText = monthArray[curMonth]+" "+curDay + ", "+ curYear; // KILLED for later
			content_tf_STARTY = calApp.calscroller_mc.content_tf._y; // grab the Y pos of the scrollable tf for later replacement
			
			eventsArray = new Array();
			buildEventsObject();			
			displayMonth(currentMonth, currentYear);
			
		} else {
			 trace("load cal data died WHAA "+ $success);
		}
		

		/* 
  		datum_btn.onRelease = function() {
			for (i=0; i<t_xml.length; i++) {		
				if (deingabe_txt.text == t_xml[i].attributes.datum) {
					_level1.playSFX("Transfer");
					currentD =  t_xml[i].attributes.datum.split('.')[0];
					currentMonth = t_xml[i].attributes.datum.split('.')[1]-1;			
					currentYear = t_xml[i].attributes.datum.split('.')[2];
					cleanUp();       
		    		displayMonth(currentMonth, currentYear);
					anzeige_txt.text = this._parent["date"+currentD].weekday+"\n"+(((((currentD+" ")+monthArray[currentMonth])+" - ")+curYear));
					news_txt.htmlText = "<font color='#ff0000'>"+t_xml[i].attributes.titel+"</font><br><br>";
					news_txt.htmlText += t_xml[i].firstChild+"<br><br>";
					if (t_xml[i].attributes.links != undefined) {
						news_txt.htmlText += "<p align='right'><font color='#ff3300'>[ <a href='"+t_xml[i].attributes.links+"'>Jump</font> ]</a></p>";
					}
					deingabe_txt.text = "";
					break;
				} else {			
					news_txt.htmlText = "Kein Termin!";			
				}
			}
		};   */

			
	}
	
	
	private function buildEventsObject(){
		var cLen = cXml.item.length;
		
		for(var c=0; c<cLen;c++){ /// this is just the whole list. . . . 
					
			eventsArray.push({
				id:cXml.item[c].attributes.id,
				headline:cXml.item[c].attributes.headline,
				eventTime:cXml.item[c].attributes.eventTime,
				description:cXml.item[c].data
			});
		}	
	}			
	
	

	public function leapYear(Year):Boolean {
	        if (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0)) {
	            return (true);
	        } else {
	            return (false);
	         }
	}
	
	private function daysInMonth(month, year):Number {
	        var daysinmonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	        if (leapYear(year) == true) {
	            daysinmonth[1] = 29;
	        }
	        return (daysinmonth[month]);
	}
	
	private function displayMonth(month, year):Void {
		// trace("HIT ME!!" +month+" "+year)
			
	        var d = new Date (); /// date object used to build calendar
	
			/// get DAY NAME of first day of the month to build calendar
			
	        var yspan = 1;        
	        d.setFullYear(year, month, 1);
	        var firstDay = d.getDay() +1;
		// trace("first day is "+firstDay);
		//	trace("1st day of "+monthArray[currentMonth] +" is "+ weekArray[firstDay]);
			
			
			var mc = calApp;
			
			
			var dayCounter=1;
			var dim = daysInMonth(month, year);
			
			
			// set month title  ie AUGUST 2008
			mc.calendarTitle_tf.text = monthArray[currentMonth]+ " " + year; 
			
			/// SETS WEEK ABBREVIATIONS on top of calendar S M T W T F S
				for (var z=0; z<=6; z++){
						mc.attachMovie("day", "sDate"+z, z+50);   				 	
					 	mc["sDate" + z]._x = startx + (w * (z+1));             
			            mc["sDate" + z]._y = starty + (h * yspan)-27;  
			            mc["sDate" + z].date = weekSArray[z];
						mc["sDate" + z].gotoAndStop(4);
						
				}
			
			
			
			/// make six weeks and start at firstDay
			// change d date object every increment dayCounter ... and set parts for later
			for (var x=1; x<=7; x++){
				d.setDate(dayCounter);
				
				if(x>=firstDay){
					mc.attachMovie("day", "date" + dayCounter, dayCounter);   				 	
				 	mc["date" + dayCounter]._x = startx + (w * x);             
		            mc["date" + dayCounter]._y = starty + (h * yspan);  
		            mc["date" + dayCounter].date = d.getDate();
		            mc["date" + dayCounter].weekday = weekArray[d.getDay()];
		            mc["date" + dayCounter].year = d.getFullYear();
		            mc["date" + dayCounter].month = monthArray[month];
				
					 doIhaveEvents(dayCounter, d);
					
					if( isitToday(dayCounter, d)){
					     mc["date" + dayCounter].gotoAndStop(2);  //// yes its the current day -- mark it	
					}
					
					dayCounter++;

				}
			}
		
			
  			
			for (var x=8; x<=14; x++){
				d.setDate(dayCounter);
					mc.attachMovie("day", "date" + dayCounter, dayCounter);   					
				 	mc["date" + dayCounter]._x = startx + (w * (x-7));             
		            mc["date" + dayCounter]._y = starty + (h * yspan)+h;  
		            mc["date" + dayCounter].date = d.getDate();
		            mc["date" + dayCounter].weekday = weekArray[d.getDay()];
		            mc["date" + dayCounter].year = d.getFullYear();
		            mc["date" + dayCounter].month = monthArray[month];
					 doIhaveEvents(dayCounter, d);
				
		
					if( isitToday(dayCounter, d)){
					     mc["date" + dayCounter].gotoAndStop(2);  //// yes its the current day -- mark it	
					}
					
					dayCounter++;
			}
			
			for (var x=15; x<=21; x++){
				d.setDate(dayCounter);
					mc.attachMovie("day", "date" + dayCounter, dayCounter);   
				 	mc["date" + dayCounter]._x = startx + (w * (x-14));             
		            mc["date" + dayCounter]._y = starty + (h * yspan)+(h*2);  
		            mc["date" + dayCounter].date = d.getDate();
		            mc["date" + dayCounter].weekday = weekArray[d.getDay()];
		            mc["date" + dayCounter].year = d.getFullYear();
		            mc["date" + dayCounter].month = monthArray[month];
					 doIhaveEvents(dayCounter, d);
		
					if( isitToday(dayCounter, d)){
					     mc["date" + dayCounter].gotoAndStop(2);  //// yes its the current day -- mark it	
					}

				dayCounter++;
			}
			
			
			
			
			for (var x=22; x<=28; x++){
				// trace(dayCounter+" : "+x)
				d.setDate(dayCounter);
					mc.attachMovie("day", "date" + dayCounter, dayCounter);   
				 	mc["date" + dayCounter]._x = startx + (w * (x-21));             
		            mc["date" + dayCounter]._y = starty + (h * yspan)+(h*3);  
		            mc["date" + dayCounter].date = d.getDate();
		            mc["date" + dayCounter].weekday = weekArray[d.getDay()];
		            mc["date" + dayCounter].year = d.getFullYear();
		            mc["date" + dayCounter].month = monthArray[month];
		
					 doIhaveEvents(dayCounter, d);
		
					if( isitToday(dayCounter, d)){
					     mc["date" + dayCounter].gotoAndStop(2);  //// yes its the current day -- mark it	
					}		
				dayCounter++;
			}
			  

			
			
	  		
				
			for (var x=29; x<=35; x++){
				// trace("dim"+ dim+" :: ::" +dayCounter);
				d.setDate(dayCounter);
				
				if(dayCounter>dim){
					// trace("DIM bailed "+x);
					//return;
				}else{
					mc.attachMovie("day", "date" + dayCounter, dayCounter);   
				 	mc["date" + dayCounter]._x = startx + (w * (x-28));             
		            mc["date" + dayCounter]._y = starty + (h * yspan)+(h*4);  
		            mc["date" + dayCounter].date = d.getDate();
		            mc["date" + dayCounter].weekday = weekArray[d.getDay()];
		            mc["date" + dayCounter].year = d.getFullYear();
		            mc["date" + dayCounter].month = monthArray[month];
		
					 doIhaveEvents(dayCounter, d);
		
					if( isitToday(dayCounter, d)){
					     mc["date" + dayCounter].gotoAndStop(2);  //// yes its the current day -- mark it	
					}		
					dayCounter++;
				}
			}
			  
	
			
			
		
		
  			
			for (var x=36; x<=42; x++){
				if(dayCounter>dim){
					// trace("bailed");
				}else{
					d.setDate(dayCounter);
					mc.attachMovie("day", "date" + dayCounter, dayCounter);   
				 	mc["date" + dayCounter]._x = startx + (w * (x-35));             
		            mc["date" + dayCounter]._y = starty + (h * yspan)+(h*5);  
		            mc["date" + dayCounter].date = d.getDate();
		            mc["date" + dayCounter].weekday = weekArray[d.getDay()];
		            mc["date" + dayCounter].year = d.getFullYear();
		            mc["date" + dayCounter].month = monthArray[month];
				//	mc["date" + dayCounter].eventData:Object;
					 doIhaveEvents(dayCounter, d);
		
						if( isitToday(dayCounter, d)){
						     mc["date" + dayCounter].gotoAndStop(2);  //// yes its the current day -- mark it	
						}		
					dayCounter++;
				}
			}
		   
		
		/// ADD EVENTS 
			for(var gg=1; gg<=42; gg++){		
				//trace(gg+"BINGO : "+ mc["date" +gg ]);
				if(mc["date" +gg]!=undefined){
				/*   	mc["date" +gg].onRollOver =function(){
						//trace(this.date);
						trace(this._parent._parent.app.calendarApp.content_tf_STARTY)
					}
					mc["date" +gg].onRollOut =function(){
						//trace(this.date);
						trace(this._parent._parent.app.calendarApp.content_tf_STARTY)
					}   */
				
			 		mc["date" +gg].blank.onPress =function(){
						var cDate:Object = this._parent.date;
						BroadCaster.broadcastEvent("setEvents", cDate, true);
						//tween
						var clip = this._parent._parent.calscroller_mc.content_tf;
						var yVal = this._parent._parent._parent.app.calendarApp.content_tf_STARTY;
						Tweener.addTween(clip, {time:1, transition:"easeOut", _y:yVal}); 
					}   
			
					
				}
			}
							
			// GET EVENTS from XML
			// populate curent day item 
	 
	        current = (monthArray[month] + " - ") + year;
	
			var cDate:Object = curDay;
		 	
			///////////////////////////////////////////
			//var cDate:Object = 19;  // TEST ONLY ///////////////////////////////////////////
			///////////////////////////////////////////
			
			
			BroadCaster.broadcastEvent("setEvents", cDate, true);
			
			calApp._alpha=100;        		// FADE MAYBE??
	}
	
	
	private function setEvents(__date:Number){ 
		//		trace(calApp["date" + curDay].eventData);
		
		/// run thru events array
		/// get events for passed DAY __date
		/// send em to text field and enable scroller
		
		var dString:String =  (curMonth+1)+ "." + __date + "." +  curYear;

	//var dString:String =  (curMonth+1)+ "." + curDay + "." +  curYear;
		//trace("SET EVENTS ::::::::::: "+ dString); //9.19.2008
		//trace("SET EVENTS ::::::::::: "+ __date); //19
				
		var counter=0;
		var tempArr = new Array();
		///// this aint workin . .. . . maybe an array by ID
		var g:Number=0;
		
		for(var x=0; x<eventsArray.length; x++){ 
			if(dString==eventsArray[x].id){
				//trace("WHOA "+eventsArray[x].id)
				tempArr[g] = eventsArray[x];
				g++;
				
			}
		/*   		for(var item in tempArr){
					for(var obj in tempArr[item]){
						trace(item+" "+obj +" ~ "+tempArr[item][obj]);
					}
				}	   */
		
		}
		calApp.calscroller_mc.content_tf.htmlText =""; 
		calApp.currentDay_tf.htmlText = monthArray[curMonth]+" "+__date + ", "+ curYear; // changes Date above scroller
		var tAlen = tempArr.length;
		
		for (var z=0; z<tAlen; z++){
			//trace("? ? ? ? "+tempArr[z].headline);
			var boldMe = "<B>"+tempArr[z].headline +"</B>" ; //cXml.item[z].attributes.headline; 
			var cData = tempArr[z].description;
			if (cData == undefined || cData == null){
				var pile:String = boldMe + "\r"+tempArr[z].eventTime +"\r\r";
			}else{
				var pile:String = boldMe + "\r"+tempArr[z].eventTime + "\r"+cData +"\r\r";
			}
			
					//trace("PILE :"+pile);
					calApp.calscroller_mc.content_tf.htmlText += pile;

		}
		
		
		
		if(tempArr.length<=0){
			calApp.calscroller_mc.content_tf.htmlText = "No events scheduled.";
		}
		calApp.calscroller_mc.content_tf.autoSize = true;
		
	
		
		if(calApp.calscroller_mc.content_tf._height >=MASKHEIGHT){
			enableScroller(calApp.calscroller_mc.content_tf._height);
		}else{
			disableScroller();
		}
		

	//	trace(pile);
		
		/// ADD STYLE SHEETS FOR CLICKABLE TEXT
		
	}
	   
	
	private function disableScroller(){
		calApp.calscroller_mc.moreUP._visible=false;
		calApp.calscroller_mc.moreDOWN._visible=false;

		calApp.calscroller_mc.moreUP.enabled=false;
		calApp.calscroller_mc.moreDOWN.enabled=false;
		
	
		calApp.calscroller_mc.moreUP.onPress=function(){
		// nuthin
		};
			
		calApp.calscroller_mc.moreDOWN.	onPress=function(){
		// nuthin
						
		};
	}
	
	private function enableScroller(h:Number){
		//trace("scroller tf height = "+h);
		// mask height = 186
		
		writeScrollerEvents();
		
	}
	
	private function shipIt(){
		//trace("SHIPPED");
		BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
	}
	
	private function writeScrollerEvents(){
	//	trace(calApp.calscroller_mc.content_tf._height);
	//	trace(calApp.calscroller_mc.content_tf._y);
		//trace("WSE ::::::::::::::::");
		
		// MASKHEIGHT = 186
		
		
		
		
		//if the Y of the tf is near start y  - height 
		var tf = calApp.calscroller_mc.content_tf._y;
		//trace("tf Y: "+tf)
		var topY = 14 -calApp.calscroller_mc.content_tf._height;
		//trace("topY: "+topY)
		var bottomY =  14;
		//trace("bottomY: "+bottomY)
		var deltaTOP = tf+Math.abs(topY);
		//trace("delta top :"+deltaTOP);
		
		var deltaBTM = Math.abs(bottomY-tf);
		//trace("delta bottom :"+deltaBTM);
		
		
		
		if(tf > topY && tf < bottomY){
			// enable both
			//trace("A")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
			//	this._parent.content_tf._y-=10;
		////	if delta top is greater than 100, use 100,  else use delta top
				Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y-100, onCompleteEvent:calApp.shipIt});
				
			//	BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
				
			};
				
			calApp.calscroller_mc.moreDOWN.onPress=function(){
				////	if delta bottom is less than 100 use delta bottom else use 100
				
				Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y+100, onCompleteEvent:calApp.shipIt});
				
				//this._parent.content_tf._y+=10;		
				//BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
							
			};
			
			
		}else if(tf > topY && tf >= bottomY){
			//disable DOWN
			//enable UP
			//trace("B")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=false;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=50;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
			//	this._parent.content_tf._y-=10;
			
	
			Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y-100, onCompleteEvent:shipIt});
				
			//	BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
				
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
			//	this._parent.content_tf._y+=10;					
			};
			
			
			
			
		}else if(tf <= topY && tf < bottomY){
			//disable UP
			//enable DOWN
			//trace("C")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=false;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=50;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
				//this._parent.content_tf._y-=10;
				Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y-100, onCompleteEvent:shipIt});
				
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
			//	this._parent.content_tf._y+=10;
			Tweener.addTween(this._parent.content_tf, {time:1, transition:"easeOut", _y:this._parent.content_tf._y+100, onCompleteEvent:shipIt});
			
				//BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
									
			};
			
			
			
		}
		
		

	}
	
	
	private function doIhaveEvents(dC:Number, d:Date) {

		//	trace("length ::"+ cXml.item.length);

		//trace("HERE IT IS :" +dC)

	var itemLen:Number = cXml.item.length;
	var dString:String =  (d.getMonth()+1)   + "." + d.getDate() + "." +  d.getFullYear();

		for (var k = 0; k<itemLen; k++) {	 /// fly thru xml obj and find events to mark
		//	trace(k)
		//	trace(cXml.item[k].attributes.id);
		  	if (dString == cXml.item[k].attributes.id) { /// if theres data for this day, mark it
		//		trace("YO "+ k+" || | | | ||"+dC);
				calApp["date" + dC].events_mc._alpha=100;
			 /*    	calApp["date" + dC].eventData.push({
							headline:cXml.item[k].attributes.headline,
							eventDate:cXml.item[k].attributes.eventDate,
							description:cXml.item[k].data
						});   */
			 
				// do something with data			
			}
		}
    }



    private function isitToday(dC:Number, d:Date):Boolean {
	    if (curDay == d.getDate() && curMonth == d.getMonth() && curYear == d.getFullYear()) {
			return true;
		}else{
			return false;
			}
    }
	
	
    private function cleanUp () {
		for (var i =1 ; i<=42;i++) {  
			// trace("C U :: " +calApp["date"+i]._y);			      
            calApp["date" + i].removeMovieClip();
          //  removeMovieClip ("lastghost" + i);
           // removeMovieClip ("firstghost" + i);            
        }
    }


		
	private function rightArrowRelease(){
			// trace("HEY "+this.currentMonth);
			 cleanUp();
			    if (currentMonth == 11) {
			        currentMonth = 0;
			        currentYear++;
			    } else {
			        currentMonth++;
		     	}
			   displayMonth(currentMonth, currentYear);
	}

	private function leftArrowRelease(){
		 //	back button
			    cleanUp();
			    if (currentMonth == 0) {
			        currentMonth = 11;
			        currentYear--;
			    } else {
			        currentMonth--;
			    }		   
			displayMonth(currentMonth, currentYear);
   	}
}