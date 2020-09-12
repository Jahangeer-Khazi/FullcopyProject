@IsTest
public class WHJ_TeacherRecruitmentAPIParser_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'\"FirstName\": \"FName\",'+
		'\"LastName\": \"LName\",'+
		'\"email\": \"testAPI1@gmail.com\",'+
		'\"Mobile\": \"9798979596\",'+
		'\"DateOfRegistration\":\"2018-07-25\",'+
		'\"PhoneRecruiterMailId\":\"testmail@gmail.com\"'+
		'}';
		WHJ_TeacherRecruitmentAPIParser obj = WHJ_TeacherRecruitmentAPIParser.parse(json);
		System.assert(obj != null);
	}
}