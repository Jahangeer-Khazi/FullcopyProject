@isTest
public class WHJ_Unsubscription_API_Test {
	
    static testmethod void testmethod_Success(){
    	Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'test@stu.com');
        insert account;
        Lead ld = new Lead();
        ld.FirstName = 'Test';
        ld.LastName = 'Ld1';
        ld.Email = 'test@stu.com';
        ld.Phone = '9876543211';
        ld.Status = 'Registered';
        insert ld;
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON - UPGRADE POTENTIAL';
        oppo.Type = 'New Student';
        oppo.Email__c = 'test@stu.com';
        oppo.Teacher_Email__c = 'test@stu.com';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        insert oppo;
        Test.startTest();
        String input_body = '{"unsubscriber_lst":[{"phone": "9876543211","email": "test@stu.com","flag": "True"}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(input_body);
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Unsubscription_API.notificationSubscripe();
        Test.stopTest();
    }
    static testmethod void testmethod_failure(){
    	Test.startTest();
        String input_body = '{Test ,"unsubscriber_lst":[{"phone": "9876543211","email": "test@abc.com","flag": "True"}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(input_body);
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Unsubscription_API.notificationSubscripe();
        Test.stopTest();
    }
    static testmethod void forJsonParser(){
        WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe tmpParser = new WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe();
        WHJ_Unsubscription_API.Unsubscribe_parser tmpunsubscribe = new WHJ_Unsubscription_API.Unsubscribe_parser();
        tmpunsubscribe.email = 'Test EMail';
        tmpunsubscribe.phone = 'Test Phone';
        tmpunsubscribe.flag = 'True';
        
    }
}