@isTest
global class WHJ_UpdateLead_API_Test {

     static void setupTestData()
    {
        Lead l = new Lead(LastName = 'Test' , Status = 'Unregistered' ,Email = 'test@gmail.com', Do_Not_Disturb__c = false);
        insert l;
       
        Account account1 = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'test@gmail.com', student_id__c = 'student-id-test-1');
        insert account1;
        
  
        
        List<Lead> lstLead = [Select id, IsConverted, Email from Lead where Email ='test@gmail.com' and IsConverted = false];
        System.debug('lstLead ::' +lstLead);
        
        List<Account> lstAccount  =[Select id, PersonEmail from Account where PersonEmail ='test@gmail.com'];

        if(!lstAccount.isEmpty() )
        {
            Account account = new Account();
                account.Id = lstAccount[0].Id;
                account.PersonEmail = 'test@gmail.com';
                account.FirstName = 'Test';
                account.Alternate_Email__c = 'test@gmail.com';
                account.LastName = 'testlastname';
                account.PersonMobilePhone = '9898989898';
            update account;
        }
    }
  


    
 static testmethod void createLead() {
    //setupTestData();
     Test.startTest();
    String actual = '{"primaryemail": "test@gmail.com","alternateemail": "test@gmail.com","studentid" : "student-id-test-1", "status": 12}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/UpdateStudents'; //Request URL
    req.httpMethod = 'PUT';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     
     WHJ_UpdateLead_API.updateLead();
     test.stopTest();
    }

}