/*	CalendarApp.as:  
	
TO DO :
	
FIX SCROLLER 
			
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
	private var blocker_mc:MovieClip;
	
		private var FADEINDELAY:Number = 1.5; // seconds

	private var calArrow_right:MovieClip;
	private var calArrow_left:MovieClip;
	
    private var calendarTitle_tf:TextField;
	//private var MASKHEIGHT:Number = 186;
	//private var MASKY:Number = 14;
	
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
	
	
	private var sp_monthArray:Array;
	private var sp_weekArray:Array;
	private var sp_weekSArray:Array;
	                          
	private var tempDate:Date;	
	private var currentMonth;
	private var currentYear;
	private var curDay;
	private var curWDay;
	private var curMonth;
	private var curYear;

	private var current;
    private var currentLength;

	///// scroller stuff
	private var totalHops:Number;
	public var currentHop:Number;
	private var MASKHEIGHT:Number = 180;  // hard coded 
	private var firsttime=true;
	
	public var ready:Boolean=false;
	

	public function CalendarApp(passmealong:String, clip:MovieClip){
		 trace("Calendar APP CONSTRUCTOR");
		if (_global.lang == "SPANISH"){
			
		}else{
			
		}
		
		XMLPATH = "xml/"+passmealong;     /////  FIX THIS>?
		calApp = clip.calendar_app_mc;
		
		
		// start disabled
		calApp._visible=false;
		
		BroadCaster.register(this,"setEvents");
		BroadCaster.register(this,"writeScrollerEvents");
		BroadCaster.register(this,"incHop");
		BroadCaster.register(this,"decHop");
		BroadCaster.register(this,"removeEvents");

		
		
		monthArray = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
		weekArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		weekSArray = ["S", "M", "T", "W", "T", "F", "S"];
		
		sp_monthArray = ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AUGUSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];
		sp_weekArray = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sabado"];
		sp_weekSArray = ["D", "L", "Mt", "Mc", "J", "V", "S"];
		
		// grab current date info
		tempDate = new Date();	
		currentMonth = tempDate.getMonth();
		//trace("GOT MONTH "+ currentMonth);
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
	//	calApp.blocker_mc._alpha=100;
		//calApp._visible=false;
		
	}
	
	private function getEventList():Void{
		// maybe cal_xml = null; ??
		cal_xml = new XML();
		cal_xml.ignoreWhite = true;
		cal_xml.load(XMLPATH); 

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
	
	public function reLoadCalendar(passmealong:String){
		// for spanish... new xmlpath
		XMLPATH = "xml/"+passmealong;  
		getEventList();
		
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
		 trace("HIT ME!!" +month+" "+year)
			
	        var d = new Date (); /// date object used to build calendar
	
			/// get DAY NAME of first day of the month to build calendar
			
	        var yspan = 1;        
	        d.setFullYear(year, month, 1);
	        var firstDay = d.getDay() +1;
		 trace("first day is "+firstDay);
			trace("1st day of "+monthArray[currentMonth] +" is "+ weekArray[firstDay]);
			
			
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
						mc["sDate" + z]._visible=false;  // to be re visified later
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
				trace(dayCounter+" : "+x)
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
			 trace("dim"+ dim+" :: ::" +dayCounter);
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
				trace(gg+"BINGO : "+ mc["date" +gg ]);
				if(mc["date" +gg]!=undefined){
				/*   	mc["date" +gg].onRollOver =function(){
						trace(this.date);
						trace(this._parent._parent.app.calendarApp.content_tf_STARTY)
					}
					mc["date" +gg].onRollOut =function(){
						trace(this.date);
						trace(this._parent._parent.app.calendarApp.content_tf_STARTY)
					}   */
					mc["date" + gg]._visible=false; // make all boxes invisible
				
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
	 
	        current = (monthArray[month] + " - ") + year;

			// populate curent day item once, then dont until a date is clicked
			if(firsttime){
				
					var cDate:Object = curDay;
					trace("FT::::::::" + curDay)
				
					BroadCaster.broadcastEvent("setEvents", cDate, true);
					firsttime=false;
			}
			
		//	calApp._alpha=100;        		// FADE MAYBE??
		
	
		calApp.blocker_mc.swapDepths(calApp.getNextHighestDepth());
		
		
		
		///  MOVED TO ENABLE
	// enable from app after deep link   	enable();
	
	this.ready = true;
	
//	enable();
	 
	//	Tweener.addTween(calApp, {delay:1.5, _x:279}); // its loading off stage so put it back when the bkg is done transitioning
	//		Tweener.addTween(calApp.blocker_mc, {time:1, delay:FADEINDELAY, transition:"easeOut", _alpha:0}); // fade it in
			
			
				for(var ff=0; ff<=42; ff++){	// re visible all the boxes
					mc["sDate" + ff]._visible=true;
					mc["date" + ff]._visible=true;
				} 
	

	
	}
	
	
	private function setEvents(__date:Number){ 	
			trace("SET EVENTS : "+ curMonth+" :: "+ currentMonth);
		
		/// run thru events array
		/// get events for passed DAY __date
		/// send em to text field and enable scroller
		var dString:String =  (currentMonth+1)+ "." + __date + "." +  currentYear;  // curMonth

	//var dString:String =  (curMonth+1)+ "." + curDay + "." +  curYear;
		trace("SET EVENTS ::::::::::: "+ dString); //9.19.2008
		trace("SET EVENTS ::::::::::: "+ __date); //19
				
		var counter=0;
		var tempArr = new Array();
		///// this aint workin . .. . . maybe an array by ID
		var g:Number=0;
		
		for(var x=0; x<eventsArray.length; x++){ 
			if(dString==eventsArray[x].id){
				trace("WHOA "+eventsArray[x].id)
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

		calApp.currentDay_tf.htmlText = monthArray[currentMonth]+" "+__date + ", "+ currentYear; // changes Date above scroller

		var tAlen = tempArr.length;
		
		for (var z=0; z<tAlen; z++){
			trace("? ? ? ? "+tempArr[z].headline);
			var boldMe = "<B>"+tempArr[z].headline +"</B>" ; //cXml.item[z].attributes.headline; 
			var cData = tempArr[z].description;
			if (cData == undefined || cData == null){
				var pile:String = boldMe + "\r"+tempArr[z].eventTime +"\r";
			}else{
				var pile:String = boldMe + "\r"+tempArr[z].eventTime + "\r"+cData +"\r";
			}
		
			if(z!=(tAlen-1)){ // if youre at the last one, skip this extra return... its messing up the spacing
				pile+="\r";
			}
			
			trace("PILE :"+pile);
			calApp.calscroller_mc.content_tf.htmlText += pile;

		}
		
		
		
		if(tempArr.length<=0){
			calApp.calscroller_mc.content_tf.htmlText = "No events scheduled."; 
		}
		trace(calApp.calscroller_mc.content_tf._height);
		trace("PRESTOOOO");
		
		calApp.calscroller_mc.content_tf.autoSize = "left";
		
		trace(calApp.calscroller_mc.content_tf._height);
		
		var diff = Math.abs(calApp.calscroller_mc.content_tf._height - MASKHEIGHT)
		if(diff >= 5){
		//if(calApp.calscroller_mc.content_tf._height > MASKHEIGHT){
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
			
		calApp.calscroller_mc.moreDOWN.onPress=function(){
		// nuthin
						
		};
	}
	
	private function enableScroller(h:Number){
		// trace("ENABLE SCROLLER : scroller tf height = "+h);
		// MASKHEIGHT = 178
		currentHop=1;
		
		var tH = calApp.calscroller_mc.content_tf._height;
		var REM = tH % MASKHEIGHT;
		// trace(tH + " : MOD :"+REM);
	//	// trace("REMAINDER  :"+ (tH-(178*2)));
// trace(Math.round( tH / MASKHEIGHT));
		if(REM > 0){
			// take round +1
			totalHops = Math.floor( tH / MASKHEIGHT)+1;

		}else{
			// take round 
			totalHops = Math.floor( tH / MASKHEIGHT);	
		}

		trace("TOTALHOPS : "+totalHops);
		trace("C HOP : "+currentHop);
		
		writeScrollerEvents();
		
	}
	
	private function incHop(){
		// trace("INC")
		currentHop++;
	}
	private function decHop(){
		// trace("DEC")
		currentHop--;
	}
	
 
	private function addEvents(where:String){
		// trace("ADDED")
		var fn:Function = function(){
					// trace("WORKED");
					BroadCaster.broadcastEvent("writeScrollerEvents");
				}
				
		switch(where){
			case "both":
				calApp.calscroller_mc.moreUP.onPress=function(){
					// trace("UP");
					BroadCaster.broadcastEvent("removeEvents");
					BroadCaster.broadcastEvent("incHop");
					Tweener.addTween(this._parent.content_tf, {time:0.5, transition:"easeOut", _y:this._parent.content_tf._y-177, onComplete:fn});
				};
				
				calApp.calscroller_mc.moreDOWN.onPress=function(){
					// trace("DN");
					BroadCaster.broadcastEvent("removeEvents");
					BroadCaster.broadcastEvent("decHop");	
					Tweener.addTween(this._parent.content_tf, {time:0.5, transition:"easeOut", _y:this._parent.content_tf._y+177, onComplete:fn});
				};
			break;
			
			
			case "upOnly":
				calApp.calscroller_mc.moreUP.onPress=function(){
					// trace("UP");
					BroadCaster.broadcastEvent("removeEvents");
					BroadCaster.broadcastEvent("incHop");
					Tweener.addTween(this._parent.content_tf, {time:0.5, transition:"easeOut", _y:this._parent.content_tf._y-177, onComplete:fn});
				};
				
			break;
			
			case "downOnly":
				calApp.calscroller_mc.moreDOWN.onPress=function(){
					// trace("DN");
					BroadCaster.broadcastEvent("removeEvents");
					BroadCaster.broadcastEvent("decHop");
					Tweener.addTween(this._parent.content_tf, {time:0.5, transition:"easeOut", _y:this._parent.content_tf._y+177, onComplete:fn});
				};
			break;
	
		}
	} 

	private function removeEvents():Void{
		// trace("REMOVED :::::: "+calApp.calscroller_mc.moreUP)
		calApp.calscroller_mc.moreUP.onPress=function(){};
		calApp.calscroller_mc.moreDOWN.onPress=function(){};
	}

	
	private function writeScrollerEvents(){	
		// trace("WSE ::::::::::::::::");		
		// MASKHEIGHT = 178
	
//		this stinks		
/* 
		
		//if the Y of the tf is near start y  - height 
		var tf = calApp.calscroller_mc.content_tf._y;					trace("tf Y: "+tf)
		var topY = 16.8 -calApp.calscroller_mc.content_tf._height;		trace("topY: "+topY)
		var bottomY =  14;												trace("bottomY: "+bottomY)
		var deltaTOP = tf+Math.abs(topY);								trace("delta top :"+deltaTOP);
		var deltaBTM = Math.abs(bottomY-tf);							trace("delta bottom :"+deltaBTM);
		 
*/

		if(currentHop < totalHops && currentHop > 1  ){   // if there are HOPS above and below ... [not first or last]
	
			// enable both
			trace("A")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;
			
			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=true;
			
			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
			addEvents("both");
	  
		}else if(currentHop == 1 && currentHop != totalHops){ // if we're at the first HOP    on TOP ...  and there are other HOPS to get to
	
	
			//disable DOWN
			//enable UP
			trace("B")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=false;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=20;
			
			addEvents("upOnly");
		

			
		}else if(currentHop == totalHops && totalHops > 1){ // if we're at the bottom and there are some above..
	
	
			//disable UP
			//enable DOWN
			trace("C")
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=false;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=20;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
			addEvents("downOnly");
		
		
		}else{
			trace("UH... NONE OF THE ABOVE")
			disableScroller();
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
		trace("HEY RIGHT "+this.currentMonth);
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
		trace("HEY LEFT "+this.currentMonth);
		
			    cleanUp();
			    if (currentMonth == 0) {
			        currentMonth = 11;
			        currentYear--;
			    } else {
			        currentMonth--;
			    }		   
			displayMonth(currentMonth, currentYear);
   	}
	
	public function disable():Void{ 
	//	calApp.blocker_mc.swapDepths(calApp.getNextHighestDepth())
		
	// this fades in a white blocker mc and then _visible = false to disable clicks.
		trace(calApp.blocker_mc);
	//	calApp.blocker_mc.swapDepths(calApp.getNextHighestDepth())
		var invisify:Function = function(_ob:Object){
			trace("I I :"+_ob);
			_ob._visible=false;
			}
			
		Tweener.addTween(calApp.blocker_mc, {time:1, transition:"easeOut", _alpha:100, onComplete:invisify, onCompleteParams:[calApp]});
		
	}
	
	public function enable(mc):Void{ 
		calApp._visible=true;
		Tweener.addTween(calApp, {delay:1.5, _x:279}); // its loading off stage so put it back when the bkg is done transitioning
		Tweener.addTween(calApp.blocker_mc, {time:1, delay:FADEINDELAY, transition:"easeOut", _alpha:0}); // fade it in


		for(var ff=0; ff<=42; ff++){	// re visible all the boxes
			calApp["sDate" + ff]._visible=true;
			calApp["date" + ff]._visible=true;
		}
		
		
						
		//Tweener.addTween(calApp.blocker_mc, {time:1, transition:"easeOut", _alpha:0});
	}

}