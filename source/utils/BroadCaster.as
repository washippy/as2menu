/**
* @author: Béla Korcsog
* @modifications:
* @date: Jan 2007
* @description: Simple Broadcaster
*
*/

class utils.BroadCaster {
	private static  var oSubscriptions:Object = {};
	private static  var nSubscriptions:Number = 0;
	private static  var currentIndex:Number = 0;
	private static  var currentEvent:String = "";
	private static  var currentArgs:Object = new Object();
	private static  var _instance:BroadCaster;
	private static  var _interval:Number = -1;

	public static function getInstance():BroadCaster {
		if (_instance == undefined) {
			_instance = new BroadCaster();
		}
		return _instance;
	}

	public static function register(objRecord:Object,strMessage:String):Void {
		if (oSubscriptions[strMessage] == undefined) {
			oSubscriptions[strMessage] = new Array();
		}

		var strIndex:Number = 0;
		var strLen:Number = oSubscriptions[strMessage].length;
		var found:Boolean = false;
		while (strIndex < strLen) {
			var objStored:Object = oSubscriptions[strMessage][strIndex];
			if (objStored == objRecord) {
				found = true;
				oSubscriptions[strMessage][strIndex] = objRecord;
				strIndex = strLen;
			} else {
				strIndex++;
			}
		}
		if (!found) {
			oSubscriptions[strMessage].push(objRecord);
			++nSubscriptions;
		}
	}

	public static function unregister(objRecord:Object,strMessage:String):Void {
		trace("unregister:"+objRecord+":"+strMessage);
		var arrSubscriptions:Array = new Array();

		var strIndex:Number = 0;
		var strLen:Number = oSubscriptions[strMessage].length;
		while (strIndex < strLen) {
			var objStored:Object = oSubscriptions[strMessage][strIndex];
			if (objStored != objRecord) {
				arrSubscriptions.push(objStored);
			}
			strIndex++;
		}
		oSubscriptions[strMessage] = arrSubscriptions;
	}

	public static function broadcastEvent(strMessage:String, objArgument:Object,delay:Boolean):Array {
		if (delay) {
			currentEvent = strMessage;
			currentArgs = objArgument;
			currentIndex = oSubscriptions[currentEvent].length-1;
			clear();
			_interval = setInterval(nextItem,20);
		} else {
			var results:Array = new Array();
			var strIndex:Number = 0;
			var strLen:Number = oSubscriptions[strMessage].length;
			while (strIndex < strLen) {
				var objRecord:Object = oSubscriptions[strMessage][strIndex];
				if (objRecord != undefined) {
					var result:Object = objRecord[strMessage].call(objRecord,objArgument);
					results.push(result);
					strIndex++;
				} else {
					strLen --;
					oSubscriptions[strMessage].splice([strIndex]);
				}
			}
			return results;
		}
	}

	public static function nextItem() {
		var objRecord:Object = oSubscriptions[currentEvent][currentIndex];
		if (objRecord != undefined) {
			//trace(currentEvent+" nextItem:"+currentIndex+"/"+oSubscriptions[currentEvent].length);
			objRecord[currentEvent].call(objRecord,currentArgs);
			currentIndex --;
			if (currentIndex <= 0) {
				clear();
			}
		} else {
			if (currentIndex == 0) {
				clear();
			} else {
				BroadCaster.nextItem();
			}
		}
	}

	public static function get numSubscriptions():Number {
		return nSubscriptions;
	}

	public static function clear() {
		clearInterval(_interval);
		_interval = -1;
	}
}
