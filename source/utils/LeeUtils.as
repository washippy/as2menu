import flash.external.ExternalInterface;

class utils.LeeUtils
{
	
	public static function LinkOut($url1:String, $newWindow1:Boolean, $url2:String, $newWindow2:Boolean)
	{
		if (System.capabilities.playerType=="External") {
			trace("LeeUtils.LinkOut: " + $url1 + ", " + $newWindow1 + " " + $url2 + " " + $newWindow2);
			return;
		}
		
		var s:String = ($newWindow1) ? "_new" : "_self"; 
		trace(s);

		getURL($url1, s);

		/*		
			// NO IMPPROVEMENT:
			
			// if url doesn't use 'javascript', use ExternalInterface, else use getURL
			if ($url1.indexOf("javascript") == -1) {
				trace('using ExtInt');
				ExternalInterface.call("window.open", $url1, s, '');
			} else {
				getURL($url1, s);
			}
			
		*/

		if ($url2 != null) _global.setTimeout(LinkOut, 30, $url2, $newWindow2);

		// var params:String = 'resizable=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,toolbar=no,left=0,top=0,width='+ popWidth +',height='+ popHeight;
	}

	public static function hitTest($o:Object, $x:Number, $y:Number)
	{
		return ($x >= 0 && $x <= $o._width && $y >= 0 && $y <= $o._height);
	}

	public static function FlashPlayerVersion():Object
	{
		var o:Object = new Object();
		
		var a1:Array = System.capabilities.version.split(" ");
		var a2:Array = a1[ a1.length-1 ].split(",");
		
		o.majorVersion = parseInt(a2[0]);
		o.minorVersion = parseInt(a2[1]);
		o.revision = parseInt(a2[2]);
		o.buildNumber = parseInt(a2[3]);

		return o;
	}
}