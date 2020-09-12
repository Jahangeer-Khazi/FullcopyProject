@IsTest
public class WHJ_TeacherAPIParser_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'\"FirstName\": \"FName\",'+
		'\"LastName\": \"LName\",'+
		'\"email\": \"testAPI1@gmail.com\",'+
		'\"Mobile\": \"9798979596\",'+
		'\"RMname\":\"RMname\",'+
		'\"RMemailId\":\"testrmmail@gmail.com\",'+
		'\"Status\":true,'+
		'\"Region\":\"India\",'+
		'\"CurriculumLevel\":\"ADVANCED\",'+
		'\"Language\":\"English\",'+
		'\"DateOfOnboarding\":\"2018-07-25\",'+
		'\"InductionOwner\":\"testInductor@gmail.com\"'+
		'}';
		WHJ_TeacherAPIParser obj = WHJ_TeacherAPIParser.parse(json);
		System.assert(obj != null);
	}
}