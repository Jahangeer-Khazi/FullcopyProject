/*White Hat Junior FirstResTime parser API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 3
 *Created Date: 27/02/2020
 *Purpose: This Test class is to test Data for WHJ_FirstResTime_API_Parser class.
 */ 

@IsTest
public class WHJ_FirstResTime_API_Parser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'\"sessionkey\":\"020351f5-338c-428a-910a-1f762bcda2f8\",'+
		'\"firstresponsetime\":\"2020-02-27T06:45:10Z\",'+
		'\"frtduration\":1000.11'+
		'}';
		WHJ_FirstResTime_API_Parser r = WHJ_FirstResTime_API_Parser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WHJ_FirstResTime_API_Parser objWHJ_FirstResTime_API_Parser = new WHJ_FirstResTime_API_Parser(System.JSON.createParser(json));
		System.assert(objWHJ_FirstResTime_API_Parser != null);
		System.assert(objWHJ_FirstResTime_API_Parser.sessionkey == null);
		System.assert(objWHJ_FirstResTime_API_Parser.firstresponsetime == null);
		System.assert(objWHJ_FirstResTime_API_Parser.frtduration == null);
	}
}
/*@IsTest
public class WHJ_FirstResTime_API_Parser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'\"sessionkey\":\"b12fec1d-7502-4ee0-a0cd-c59f78385f21\",'+
		'\"firstresponsetime\":\"2020-02-22T03:30:10Z\"'+
		'}';
		WHJ_FirstResTime_API_Parser r = WHJ_FirstResTime_API_Parser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WHJ_FirstResTime_API_Parser objWHJ_FirstResTime_API_Parser = new WHJ_FirstResTime_API_Parser(System.JSON.createParser(json));
		System.assert(objWHJ_FirstResTime_API_Parser != null);
		System.assert(objWHJ_FirstResTime_API_Parser.sessionkey == null);
		System.assert(objWHJ_FirstResTime_API_Parser.firstresponsetime == null);
	}
}*/