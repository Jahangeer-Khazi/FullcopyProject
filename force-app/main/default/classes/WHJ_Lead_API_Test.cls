/*White Hat Junior Lead API TEST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 15/09/2019
*Purpose: This Test class is to test Data for WHJ_Lead_API class.
*/ 

@isTest
global class WHJ_Lead_API_Test {
    
    static void setupTestData()
    {
        Lead l = new Lead(LastName = 'Test' , Status = 'Registered' ,Email = 'harsh@gmail.com', Do_Not_Disturb__c = false);
        insert l;
        
        Account account1 = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'harsh@gmail.com');
        insert account1;
        
        
        
        List<Lead> lstLead = [Select id, IsConverted, Email from Lead where Email ='harsh@gmail.com' and IsConverted = false];
        System.debug('lstLead ::' +lstLead);
        
        List<Account> lstAccount  =[Select id, PersonEmail from Account where PersonEmail ='harsh@gmail.com'];
        
        if(!lstLead.isEmpty())
        {
            Lead lead = new Lead();
            lead.Id = lstLead[0].Id;
            lead.LastName = 'Harsh';
            lead.Status = 'Incoming';
            lead.Email = 'harsh@gmail.com';
            lead.Alternate_Email__c = 'harsh@gmail.com';
            lead.Phone = '9898989898';
            lead.Appointment_Schedule__c = system.today();
            lead.Appointment_Comments__c = 'Meeting went very well';
            update lead;
            
        }else  if(lstLead.isEmpty())
        {
            System.debug(lstLead);
            Lead lead = new Lead();
            lead.Id = lstLead[0].Id;
            lead.LastName = 'test';
            lead.Status = 'Complete';
            lead.Email = 'abc@gmail.com';
            lead.Alternate_Email__c = 'abc@gmail.com';
            lead.Phone = '9895589898';
            lead.Do_Not_Disturb__c = false;
            insert lead;
            System.debug(lead);
        }
        
        
        
        if(!lstAccount.isEmpty() )
        {
            Account account = new Account();
            account.Id = lstAccount[0].Id;
            account.PersonEmail = 'harsh@gmail.com';
            account.FirstName = 'Test';
            account.Alternate_Email__c = 'harsh@gmail.com';
            account.LastName = 'Gughane';
            account.PersonMobilePhone = '9898989898';
            update account;
        }
    }
    
    
    
    
    static testmethod void createLead() {
        setupTestData();
        String actual = '{"primaryemail": "harsh@gmail.com","alternateemail": "harsh@gmail.com","firstname": "Harsh","lastname": "Gughane", "street": "test","city":"Pune","state": "Maharashtra","country": "India","status": "2", "mobile": "9898989898","credit": "123","gender": "Male","parentname": "abc","registereddate":"2018-07-25", "grade": "1st","timezone": "10:00","appointmentschedule":null,"appointmentcomments":"test comment","subscriptionflag":false}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Students'; //Request URL
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Lead_API.createLead();
    }
    
    
    static testmethod void createLeadElseIfLead() {
        String actual = '{"primaryemail": "harsh@gmail.com","alternateemail": "harsh@gmail.com","firstname": "Harsh","lastname": "Gughane", "street": "test","city":"Pune","state": "Maharashtra","country": "India","status": "11", "mobile": "9898989898","credit": "123","gender": "Male","parentname": "abc","registereddate":"2018-07-25", "grade": "1st","timezone": "10:00","appointmentschedule":null,"appointmentcomments":"test comment","subscriptionflag":false}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Students'; //Request URL
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Lead_API.createLead();
    }
    static testmethod void createLeadElseIfAcc() {
        String actual = '{"primaryemail": "harsh@gmail.com","alternateemail": "harsh@gmail.com","firstname": "Harsh","lastname": "Gughane", "street": "test","city":"Pune","state": "Maharashtra","country": "India","status": "1", "mobile": "9898989898","credit": "123","gender": "Male","parentname": "abc","registereddate":"2018-07-25", "grade": "1st","timezone": "10:00","appointmentschedule":null,"appointmentcomments":"test comment","subscriptionflag":false}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Students'; //Request URL
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Lead_API.createLead();
    }
    
    static testmethod void createLeadforReferralManager() {
        UserRole r2 = [Select id from UserRole where Name = 'Referral Manager'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        User u3 = new User(Alias = 't23', Email='abcrajeev123987@gmail.com',  isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='abcrajeev123987@gmail.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'India'    );
        insert u3;
        system.debug('user. u3 == ' + u3);
        system.runAs(u3) {
            setupTestData();
            String actual = '{"primaryemail": "harsh@gmail.com","alternateemail": "harsh@gmail.com","firstname": "Harsh","lastname": "Gughane", "street": "test","city":"Pune","state": "Maharashtra","country": "India","status": "9", "leadType": "referral", "ReferralManager": "abcrajeev123987@gmail.com", "mobile": "9898989898","credit": "123","gender": "Male","parentname": "abc","registereddate":"2018-07-25", "grade": "1st","timezone": "10:00","appointmentschedule":null,"appointmentcomments":"test comment","subscriptionflag":false}';
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/Students'; //Request URL
            req.httpMethod = 'PUT';
            req.requestBody = Blob.valueOf(actual);
            
            RestContext.request = req;
            RestContext.response= res;
            
            WHJ_Lead_API.createLead();   
            
        }
        
    }
}