//
//  StructureApp
//
//  Created by William Shippy on 2008-10-19.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

/* 

private var _currentAmount:Number = 0; 

public function getAmount():Number 
{ 
return _currentAmount; 
} 

public function setAmount(newAmount:Number):Void 
{ 
_currentAmount = newAmount 
}
var foo:Singleton = new Singleton(); 
The above call will create a new instance and therefore return 0 the default value set 
in the singleton class. So to retrieve the amount stored in the class you use: 
Singleton.getInstance().getAmount();  
*/




class StructureApp {
	
	static private var _instance:StructureApp; 
	private var _currentAmount:Number = 100; 
	
	private function StructureApp(){}
	
	static public function getInstance():StructureApp{ 
		if (_instance == undefined){ 
			_instance = new StructureApp(); 
		} 
			return _instance; 
	}
		
	public function getPath():Number { 
		return _currentAmount; 
	} 

	public function setPath(newAmount:Number):Void { 
		_currentAmount = newAmount;
	}
	
}