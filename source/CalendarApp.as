/*	CalendarApp.as:  */ 
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
		// trace("Calendar APP :" + clip.calendar_app_mc._y);
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
			
			calApp.currentDay_tf.htmlText = monthArray[curMonth]+" "+curDay + ", "+ curYear;
			
			
			eventsArray = new Array();
			buildEventsObject();			
			displayMonth(currentMonth, currentYear);
			
		} else {
			// trace("load cal data died WHAA "+ $success);
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
		for (var stuff in cXml.item){
			for (var things in cXml.item[stuff]){
			
			trace("FOOBAR : "+stuff+" :: "+things+" :: "+cXml.item[stuff][things]);
		}
		
		}
		for(var c =0; c<cLen;c++){
			
			
			eventsArray.push({
				id:cXml.item[c].attributes.id,
				headline:cXml.item[c].attributes.headline,
				eventDate:cXml.item[c].attributes.eventDate,
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
		   

			
						
			// GET EVENTS from XML
			// populate curent day item 
			
	
		
			/*   	
  		for (var k = 0;k < t_xml.length;k++) {	 ////// fix xml references			
			if (d.getDate() + "." + (d.getMonth()+1) + "." + d.getFullYear() == t_xml[k].attributes.datum) { /// if theres data for this day, mark it
				mc["date" + i].gotoAndStop(3);
				mc["date" + i].nr = k;				
			}
		}   
		   */
	
		
		 
	        current = (monthArray[month] + " - ") + year;
	        //currentLength = daysInMonth(month, year);
			
			// SET EVENTS
			//setEvents();
			var cDate:Object = curDay;
			BroadCaster.broadcastEvent("setEvents", cDate, true);
			
			calApp._alpha=100;        		
	}
	
	
	private function setEvents(__date:Number){
		//		trace(calApp["date" + curDay].eventData);
		
		var dString:String =  (curMonth+1)+ "." + curDay + "." +  curYear;
		trace("SET EVENTS ::::::::::: "+ dString); 
		
		var counter=0;
		var tempArr = new Array();
		
		for(var x=0; x<eventsArray.length; x++){
			trace("WHOA"+eventsArray[x].id)
			if(dString==eventsArray[x].id){
				tempArr[x]=eventsArray[x];
				}
		}
		calApp.calscroller_mc.content_tf.htmlText ="";
		
		for (var z=0; z<=(tempArr.length-1); z++){
			trace("? ? ? ? "+tempArr[z].headline);
			var boldMe = "<B>"+cXml.item[z].attributes.headline +"</B>" ; //cXml.item[z].attributes.headline; 
			var cData = cXml.item[z].data;
			if (cData == undefined || cData == null){
				var pile:String = boldMe + "\r"+cXml.item[z].attributes.eventTime +"\r\r";
			}else{
				var pile:String = boldMe + "\r"+cXml.item[z].attributes.eventTime + "\r"+cData +"\r\r";
			}
			
					trace("PILE :"+pile);
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
		trace("scroller tf height = "+h);
		// mask height = 186
		
		writeScrollerEvents();
		
	}
	private function writeScrollerEvents(){
	//	trace(calApp.calscroller_mc.content_tf._height);
	//	trace(calApp.calscroller_mc.content_tf._y);
		trace(":::::::::");
		
		
		
		
		//if the Y of the tf is near start y  - height 
		var tf = calApp.calscroller_mc.content_tf._y;
		var topY = 14 - calApp.calscroller_mc.content_tf._height;
		var bottomY =  14;
		if(tf > topY && tf < bottomY){
			// enable both
			
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
				this._parent.content_tf._y-=10;
				BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
				
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
				this._parent.content_tf._y+=10;		
				BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
							
			};
			
			
		}else if(tf > topY && tf >= bottomY){
			//disable DOWN
			//enable UP
			
			
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=true;
			calApp.calscroller_mc.moreDOWN.enabled=false;

			calApp.calscroller_mc.moreUP._alpha=100;
			calApp.calscroller_mc.moreDOWN._alpha=50;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
				this._parent.content_tf._y-=10;
				BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
				
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
			//	this._parent.content_tf._y+=10;					
			};
			
			
			
			
		}else if(tf <= topY && tf < bottomY){
			//disable UP
			//enable DOWN
			
			calApp.calscroller_mc.moreUP._visible=true;
			calApp.calscroller_mc.moreDOWN._visible=true;

			calApp.calscroller_mc.moreUP.enabled=false;
			calApp.calscroller_mc.moreDOWN.enabled=true;

			calApp.calscroller_mc.moreUP._alpha=50;
			calApp.calscroller_mc.moreDOWN._alpha=100;
			
		
			calApp.calscroller_mc.moreUP.onPress=function(){
				//this._parent.content_tf._y-=10;
			};
				
			calApp.calscroller_mc.moreDOWN.	onPress=function(){
				this._parent.content_tf._y+=10;
				BroadCaster.broadcastEvent("writeScrollerEvents", this, false);
									
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