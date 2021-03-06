//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WHJ_PaymentParser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'        \"email\": \"testFlag199@abc.com\",'+
		'	    \"paymentId\": \"PayRR-0313\",'+
		'        \"type\": \"Organic\",'+
		'        \"amount\": 5.3,'+
		'        \"currrency\": \"123\",'+
		'        \"credits\":2.3,'+
		'        \"discount\": 5.2,'+
		'        \"paymentgatewayname\": \"test\",'+
		'        \"paymentdate\": \"2018-07-25\", '+
		'	    \"packagename\": \"Standard\",'+
		'        \"emi\": false,'+
		'        \"leadby\":\"test lead\"'+
		'        '+
		'}';
		WHJ_PaymentParser r = WHJ_PaymentParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WHJ_PaymentParser objWHJ_PaymentParser = new WHJ_PaymentParser(System.JSON.createParser(json));
		System.assert(objWHJ_PaymentParser != null);
		System.assert(objWHJ_PaymentParser.email == null);
		System.assert(objWHJ_PaymentParser.paymentId == null);
		System.assert(objWHJ_PaymentParser.type == null);
		System.assert(objWHJ_PaymentParser.amount == null);
		System.assert(objWHJ_PaymentParser.currrency == null);
		System.assert(objWHJ_PaymentParser.credits == null);
		System.assert(objWHJ_PaymentParser.discount == null);
		System.assert(objWHJ_PaymentParser.paymentgatewayname == null);
		System.assert(objWHJ_PaymentParser.paymentdate == null);
		System.assert(objWHJ_PaymentParser.packagename == null);
		System.assert(objWHJ_PaymentParser.emi == null);
		System.assert(objWHJ_PaymentParser.leadby == null);
	}
}