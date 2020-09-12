/*White Hat Junior Task Parser TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 19/09/2019
 *Purpose: This Test class is to test Data for WHJ_TaskParser class.
 */ 


@IsTest
public class WHJ_TaskParser_Test {
	static testMethod void testParse() {
		String json = '{'+
		'\"Subject\": \"Here is Email\",'+
		'\"AssignedTo\": \"Harsh Gughane\",'+
		'\"Priority\": \"High\",'+
		'\"Status\": \"Open\",'+
		'\"DueDate\":\"2018-07-25\",'+
		'\"Type\": \"Email\",'+
		'\"ToAddress\": \"harhghsh@gmail.com\",'+
		'\"TextBody\": \"Test\",'+
		'\"SubjectForEmailMessage\": \"Create Email\",'+
		'\"HtmlBody\": \"Hi this is Harsh\",'+
		'\"StatusofEmailMeassage\": \"3\"'+
		'       '+
		'}';
		WHJ_TaskParser r = WHJ_TaskParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WHJ_TaskParser objWHJ_TaskParser = new WHJ_TaskParser(System.JSON.createParser(json));
		System.assert(objWHJ_TaskParser != null);
		System.assert(objWHJ_TaskParser.Subject == null);
		System.assert(objWHJ_TaskParser.AssignedTo == null);
		System.assert(objWHJ_TaskParser.Priority == null);
		System.assert(objWHJ_TaskParser.Status == null);
		System.assert(objWHJ_TaskParser.DueDate == null);
		System.assert(objWHJ_TaskParser.Type == null);
		System.assert(objWHJ_TaskParser.ToAddress == null);
		System.assert(objWHJ_TaskParser.TextBody == null);
		System.assert(objWHJ_TaskParser.SubjectForEmailMessage == null);
		System.assert(objWHJ_TaskParser.HtmlBody == null);
		System.assert(objWHJ_TaskParser.StatusofEmailMeassage == null);
	}
}