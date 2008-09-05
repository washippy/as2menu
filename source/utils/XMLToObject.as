﻿/*** GNU GENERAL PUBLIC LICENSE*		       Version 2, June 1991** Copyright (C) 1989, 1991 Free Software Foundation, Inc.,* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA* Everyone is permitted to copy and distribute verbatim copies* of this license document, but changing it is not allowed.* * Created and Distributed by Robert Taylor* Flash Extensions, LLC* flashextensions.com - Extend Flash. Extend Skills. Extend Possibilities!\* * This is code is distributed under the GNU license agreement as found* at http://www.gnu.org/copyleft/gpl.html*/class utils.XMLToObject  //      .toolbox.{		/**	* Duplicates Objects into appropriate format	* @param	item	*/	private static function clone(item:Object)	{		var ret;				if (item.__proto__.constructor == XMLNode)			ret = new XML(item.toString());		else		{			ret = new item['__proto__'].constructor();			for (var n in item)			{				if (item[n].__proto__.constructor == XMLNode)					ret[n] = new XML(item[n].toString());				else if (typeof (item[n]) == 'object')					ret[n] = clone(item[n]);				else					ret[n] = item[n];			}		}				return ret;	};			/**	* Automatically formats strings to appropriate data types	* @param	value	*/	private static function format(value)				// converts to literal value	{		if(isNaN(value))								// if the item is not a numeric value		{												// test to see if it is a boolean			if(value == "true")							// if it is true				return true;							// set bool true			else if(value == "false")					// if it is false				return false;							// set bool false			return value;								// otherwise treat it as a string		}		else											// otherwise it is a number			return Number(value);						// cast as number	}		/**	* Check XMLNode to see if it has any attributes	* @param	node	*/	private static function hasAttributes(node:XMLNode)	{		for(var e in node.attributes)			return true;		return false;	}		/**	* Checks Object to see if it has any properties	* @param	obj	*/	private static function hasProperties(obj:Object)	{		for(var e in obj)			return true;		return false;	}		/**	* Converts nodes into objects and arrays. If there is only one node type it will	* be assumed as an object. If there are more than one node type, it will automatically	* be converted into a array of objects. Attributes become properties of the object.	* TextNodes become the property of text.	* @param	node	* @param	obj	*/	private static function parseNode(node, obj)		// parses node to and object	{		var na = node.attributes;						// pointer to node attributes		for(var a in na)								// for each attribute			obj[a] = format(na[a]);						// apply prop and value to our object		var len = node.childNodes.length;				// get the number of nodes		var i;		for(i=0;i<len;i++)								// loop through the nodes		{			var cn = node.childNodes[i];				// reference to current node			var name = cn.nodeName;						// get the name of the node			if(cn.nodeType == 1)						// if the node is a child type			{				var o = {};								// create a new object to represent the node				if(obj[name] == null)					// if an object does not exist				{										// well will assume that there will only be one					parseNode(cn, o);					// call the parser with xml node and newly create object					if(o.text != null)				// 4.4.05 // Added to fix nodeValue bug					{						if(cn.childNodes.length > 1 || hasAttributes(cn))							obj[name] = o;						else							obj[name]  = o.text											}					else						obj[name] = o;					// add node object to this one with node name as reference				}				else									// otherwise the object does exist (meaning needs to be an array)				{											if(obj[name].length == null)		// if it is not an array					{						var item = obj[name];			// create a temporary reference to the object						obj[name] = [];					// turn the named reference to an array						if(item.text != null && !hasProperties(item))							obj[name].push(item.text);	// if the item is a nodeValue, push the nodeValue directly onto the array						else							obj[name].push(item);			// add the object to the array					}					parseNode(cn, o);						// call the parser with the xml node and newly created object					if(o.text != null && !hasProperties(o))						obj[name].push(o.text);		// if the item is a nodeValue, push the nodeValue directly onto the array					else						obj[name].push(o);					// add the object to the array				}			}			else											// otherwise the node is a text node				obj.text = format(cn.nodeValue);		// set temporary "nodeValue" with the value		}		return obj;											// return object	}	// Serializing Functionality	/**	* 	* @param	value	*/	private static function validate(value)	{		return new XML(value.toString().split("<").join("&lt;").split(">").join("&gt;"))	}	/**	* Reverses Object for Internal Use	* @param	obj	*/	private static function reverse(obj)	{		// reversal - reverses object in structure		var ro = {};											// create temp reversal object		for(var each in obj)									// loop through object			ro[each] = obj[each];								// assign prop and values to reversal object		return ro;	}	/**	* Parses Object to XML	* @param	o	* @param	name	* @param	xmlStr	*/	private static function parseObject(o, name, xmlStr)	{		var close;		xmlStr += "<" + name									// add start of node (<name)		if(typeof(o) == "object")		{			o = reverse(o)						var value = "";			close = true;			// add values as attributes			for(var each in o)									// for every item in this object			{					var item = o[each];								// create a reference to the current item				if(typeof(item) == "object")					// if this item is not an object or an array					close = false;				else				{					xmlStr += " " + each + "=" + "\"" + validate(item) + "\"";// add it as an attribute					delete o[each];												// remove it from list				}						}			if(close)	xmlStr += " />";			else		xmlStr += ">" + value;								// add closing part of opening node (>)			// Added 3.7.05			o = reverse(o);													// reverse object in order to maintain order			for(var each in o)												// for every item in this object			{				var item = o[each];				if(item.length)												// if its an array				{					var len = item.length;									// get the count of the objects left					for(var i=0;i<len;i++)									// loop throught the items						xmlStr = parseObject(item[i], each, xmlStr);		// convert the each object to xml				}				else														// otherwise there is only one object, not an array					xmlStr = parseObject(item, each, xmlStr)				// convert the object to xml			}		}		else			xmlStr += ">" + o;												// if the item is not an array or object, treat it as a text node		if(!close)	xmlStr += "</" + name + ">";							// add closing node		return xmlStr;														// return xml as string	}	/**	* Converts Object to String	* @param	obj	* @param	rootNodeName	*/	public static function toText(obj:Object, rootNodeName:String)	{		if(typeof(obj) != "object") 			return;					obj = clone(obj);		if(rootNodeName == null) 			rootNodeName = "root";		return  parseObject(obj, rootNodeName, "");	}		/**	* Converts Object to XML	* @param	obj	* @param	rootNodeName	*/	public static function toXML(obj:Object, rootNodeName:String)	{		return new XML(toText(obj, rootNodeName))	}	/**	* Converts XML to Object	* @param	xmlFile	*/	public static function toObject(xmlFile)	{		var file = parseNode(xmlFile, {});					// start file with the xml node and a new object		return file[xmlFile.firstChild.nodeName];				// return the final object	}}