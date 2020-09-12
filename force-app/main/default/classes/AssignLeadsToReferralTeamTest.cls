/*
 * Created by 		: Rajeev Dubey.
 * Created Date 	: 29/07/2020
 * Test Class   	: AssignLeadsToReferralTeamTest
 * Test Coverage	: 72%
 * Change History	: 
 * 					CH01 # Jahangeer Khazi Commented  and added new test class methods.
*/
@isTest (seeAllData =false)
private class AssignLeadsToReferralTeamTest {
   /* @testsetup
    public static void setupData() {
        //create user
        UserRole rmIndia = [Select id from UserRole where Name = 'Referral Manager'];
        UserRole rmUSA = [Select id from UserRole where Name = 'Referral Manager - USA'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile refManagerProfile = [SELECT Id FROM Profile WHERE Name='Referral Manager'];
        User u = new User(Alias = 'test', Email='whjhrtest1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = refManagerProfile.Id, UserRoleId = rmIndia.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                          ,Sales_Region__c = 'India'    );
        insert u;
        
        User u1 = new User(Alias = 'test123', Email='abc123@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = refManagerProfile.Id, UserRoleId = rmIndia.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available', Package_Type__c = 'APT' 
                           ,Sales_Region__c = 'IndiaV2'    );
        insert u1;
        
        User u2 = new User(Alias = 'te336', Email='abc13332345@gmail.com', isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Test33ingg31', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = refManagerProfile.Id, UserRoleId = rmUSA.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1234test12@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u2; 
        //Id referralRoleId = [Select Id from userRole where Name = 'Referral Conversion Manager' limit 1].Id;
        //Id referralProfileId = [Select Id from Profile where Name = 'Referral Manager' limit 1].Id;
        
    }
    
    
    static testmethod void testAssignLeadsToReferralConversionTeam() {
        List<Lead> lstLead = new List<Lead>();
        Lead ld = createSingleLeadIndia();
        Lead ld1 = createSingleLeadIndia();
        Lead ldUS1 = createSingleLeadUS();
        Lead ldUS2 = createSingleLeadUS();
        lstLead.add(ld);
        lstLead.add(ld1);
        lstLead.add(ldUS1);
        lstLead.add(ldUS2);
        insert lstLead;
    }
    
    static testmethod void validateReferralUnregisteredLead() {
        test.startTest();
        List<User> u = [select Id, name, email from user where email = 'whjhrtest1@testorg.com'];
        String actual = '{"primaryemail": "harsh@gmail.com","alternateemail": "harsh@gmail.com","firstname": "Harsh","lastname": "Gughane", "ReferralManager": "whjhrtest1@testorg.com", "street": "test","city":"Pune","state": "Maharashtra","country": "India","status": "9", "leadType": "referral", "mobile": "9898989898","credit": "123","gender": "Male","parentname": "abc","registereddate":"2018-07-25", "grade": "1st","timezone": "10:00","appointmentschedule":null,"appointmentcomments":"test comment","subscriptionflag":false}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Students'; //Request URL
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Lead_API.createLead();
        test.stopTest();
    }
    
    static testmethod void validateReferralUnregisteredLeadWithBlankRM() {
        
        List<User> u = [select Id, name, email from user where email = 'whjhrtest1@testorg.com'];
        system.runAs(u[0]) {
            test.startTest();
            String actual = '{"primaryemail": "harsh@gmail.com","alternateemail": "harsh@gmail.com","firstname": "Harsh","lastname": "Gughane", "ReferralManager": "", "street": "test","city":"Pune","state": "Maharashtra","country": "India","status": "9", "leadType": "referral", "mobile": "9898989898","credit": "123","gender": "Male","parentname": "abc","registereddate":"2018-07-25", "grade": "1st","timezone": "10:00","appointmentschedule":null,"appointmentcomments":"test comment","subscriptionflag":false}';
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/Students'; //Request URL
            req.httpMethod = 'PUT';
            req.requestBody = Blob.valueOf(actual);
            
            RestContext.request = req;
            RestContext.response= res;
            
            WHJ_Lead_API.createLead();
            test.stopTest();    
        }
        
    }
    
    static testmethod void validateTestCOdeCoverage() {
        AssignLeadsToReferralTeam.testCodeCOverage();
    }
    
    private static Lead createSingleLeadIndia() {
        Lead ld = new Lead();
        ld.Status = '9';
        ld.Lead_Type__c = 'referral';
        ld.LastName = 'Test referral';
        return ld;
    }
    
    private static Lead createSingleLeadUS() {
        Lead ld = new Lead();
        ld.Status = '9';
        ld.Lead_Type__c = 'referral';
        ld.LastName = 'Test referral';
        ld.Country = 'Canada';
        return ld;
    }*/
    //CH01 Start
    static testMethod void unitTest1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User u = new User(Alias = 'test', Email='xyz@test.com', EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',ProfileId=p.id,
                          Status__c = 'Available',Call_Availability_Status__c = 'Available', Sales_Region__c = 'India');
        
        insert u;
        List<Lead> leadList = new List<Lead>();
        Lead l1 = new Lead(Status = '9',Lead_Type__c = 'referral',LastName = 'Test referral',Referral_Manager__c = 'xyz@test.com');
        insert l1;
        leadList.add(l1);
        AssignLeadsToReferralTeam.assignLeadsToReferralConversionTeam(leadList);
    }
    
    static testMethod void unitTest2()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        UserRole role = [Select id, DeveloperName from UserRole where DeveloperName=:'Referral_Manager']; 
		 
		UserRole ur = [Select id, name from UserRole where id = :role.id ];
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.runAs(usr)
        {
			User u = new User(Alias = 'test', Email='xyz@test.com', EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',ProfileId = p.id, UserRoleId = role.id,
                          Status__c = 'Available',Call_Availability_Status__c = 'Available', Sales_Region__c = 'India');
        
        	insert u;
        }
        
        Test.startTest();
        List<Lead> leadList = new List<Lead>();
        Lead l1 = new Lead(Status = '9',Lead_Type__c = 'referral',LastName = 'Test referral',Referral_Manager__c = 'xyzabc@test.com',Country='India');
        insert l1;
        Test.stopTest();
        leadList.add(l1);
        AssignLeadsToReferralTeam.assignLeadsToReferralConversionTeam(leadList);
    }
    
    static testMethod void unitTest3()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Student Ops Manager'];
        UserRole role = [Select id, DeveloperName from UserRole where DeveloperName=:'Referral_Manager_USA']; 
		 
		UserRole ur = [Select id, name from UserRole where id = :role.id ];
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.runAs(usr)
        {
			User u = new User(Alias = 'test', Email='xyz@test.com', EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',ProfileId = p.id, UserRoleId = role.id,
                          Status__c = 'Available',Call_Availability_Status__c = 'Available', Sales_Region__c = 'International');
        
        	insert u;
        }
        
        Test.startTest();
        List<Lead> leadList = new List<Lead>();
        Lead l1 = new Lead(Status = '9',Lead_Type__c = 'referral',LastName = 'Test referral',Referral_Manager__c = 'xyzabc@test.com',Country='US');
        insert l1;
        Test.stopTest();
        leadList.add(l1);
        AssignLeadsToReferralTeam.assignLeadsToReferralConversionTeam(leadList);
    }
    //CH01 End
}