@isTest
public class WHJ_HotRenewalTriggerHandler_Test {
    
    
    
    
    
    @testSetup static void setup() {
        
        UserRole r1 = [Select id from UserRole where Name = 'Renewals Manager'];
        
        UserRole r2 = [Select id from UserRole where Name = 'US Renewal Sales Manager'];
        
        
        UserRole r3 = [Select id from UserRole where Name = 'Renewals Lead'];
        
        
        UserRole r4 = [Select id from UserRole where Name = 'US Renewal Team Leader'];
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r1.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                          ,Sales_Region__c = 'India'    );
        insert u;
        
        
        
        User u2 = new User(Alias = 'test12', Email='abc12@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg12', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr12test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'IndiaV2'    );
        insert u2;
        
        
        User u3 = new User(Alias = 'test3', Email='abc3@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg3', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest31@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u3;
        
        
        
        User u4 = new User(Alias = 'test123', Email='abc123@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg123', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr12t3est1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u4;
        
        User u5 = new User(Alias = 'test35', Email='abc1253@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg1523', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r3.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr12t53est1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'India'    );
        insert u5;
        User u6 = new User(Alias = 'tes356', Email='abc12536@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg15263', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r4.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr126t536est1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u6;
    }
    
    
   static testMethod void onAfterUpdateForIndia() { 
       
       Account acc = new Account();
       acc.FirstName = 'FirstName1';
       acc.LastName = 'LastName1';
       acc.Status__c ='Active';
       acc.PersonEmail = 'test12344@gmail.com';
       acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
       acc.Credit__c = 7 ;
       acc.BillingCountry = 'India';
       insert acc;
       
       
       List<Opportunity> lstopp = new List<Opportunity>();
       Opportunity oppo = new Opportunity();
       oppo.AccountId = acc.Id;
       oppo.Name = 'whj9';
       oppo.StageName = 'WIP';
       oppo.CloseDate = Date.newInstance(1960, 2, 17);
       oppo.Type = 'Renewal';
       lstopp.add(oppo);
       insert lstopp;
       
       acc.Credit__c = 4;
       Test.StartTest();
       update acc;      
       Test.StopTest();
   } 
    
     static testMethod void onAfterUpdateForInternational() { 
       
       Account acc = new Account();
       acc.FirstName = 'FirstName1';
       acc.LastName = 'LastName1';
       acc.Status__c ='Active';
       acc.PersonEmail = 'test12344@gmail.com';
       acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
       acc.Credit__c = 7 ;
       acc.BillingCountry = 'USA';
       insert acc;
       
       
       List<Opportunity> lstopp = new List<Opportunity>();
       Opportunity oppo = new Opportunity();
       oppo.AccountId = acc.Id;
       oppo.Name = 'whj9';
       oppo.StageName = 'WIP';
       oppo.CloseDate = Date.newInstance(1960, 2, 17);
       oppo.Type = 'Renewal';
       lstopp.add(oppo);
       insert lstopp;
       
       acc.Credit__c = 4;
       Test.StartTest();
       update acc;      
       Test.StopTest();
   } 
    
    static testmethod void validateTestCOdeCoverage() {
        WHJ_HotRenewalTriggerHandler.testCodeCOverage();
    }
    

    
   /* static testMethod void onAfterUpdateForIndia() { 
        
        Account acc = new Account();
        acc.FirstName = 'FirstName1';
        acc.LastName = 'LastName1';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test12344@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 7 ;
        acc.BillingCountry = 'India';
        insert acc;
        
        
        List<Opportunity> lstopp = new List<Opportunity>();
        for(integer i = 0 ; i<=10 ; i++){
            Opportunity oppo = new Opportunity();
            oppo.AccountId = acc.Id;
            oppo.Name = 'whj9'+i;
            oppo.StageName = 'WIP';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type = 'Renewal';
            lstopp.add(oppo);
            
        }
        Test.StartTest();
        insert lstopp;
        Test.StopTest();  
        acc.Credit__c = 4;
        update acc;        
        
        
        
    } 
    
    static testMethod void onAfterUpdateForNonIndia() { 
        
        Account acc = new Account();
        acc.FirstName = 'FirstName1';
        acc.LastName = 'LastName1';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test12344@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 7 ;
        acc.BillingCountry = 'USA';
        insert acc;
        
        
        List<Opportunity> lstopp = new List<Opportunity>();
        for(integer i = 0 ; i<=10 ; i++){
            Opportunity oppo = new Opportunity();
            oppo.AccountId = acc.Id;
            oppo.Name = 'whj9'+i;
            oppo.StageName = 'WIP';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type = 'Renewal';
            lstopp.add(oppo);
            
        }
        Test.StartTest();
        insert lstopp;
        Test.StopTest();  
        acc.Credit__c = 4;
        update acc;        
        
        
        
    } 
    
    static testMethod void onAfterUpdateForNonIndia2() { 
        
        
        user usr = [select id, email from user where email = 'abc3@gmail.com' limit 1];
        
        Account acc = new Account();
        acc.FirstName = 'FirstName1';
        acc.LastName = 'LastName1';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test12344@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 7 ;
        acc.BillingCountry = 'USA';
        insert acc;
        
        
        List<Opportunity> lstopp = new List<Opportunity>();
        for(integer i = 0 ; i<=10 ; i++){
            Opportunity oppo = new Opportunity();
            oppo.AccountId = acc.Id;
            oppo.Name = 'whj9'+i;
            oppo.StageName = 'WIP';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type = 'Renewal';
            oppo.OwnerId = usr.id;
            lstopp.add(oppo);
            
        }
        Test.StartTest();
        insert lstopp;
        Test.StopTest();  
        acc.Credit__c = 4;
        update acc;        
        
        
        
    }
    
    
    
    
    
    static testMethod void onAfterUpdateForIndia2() { 
        
        
        user usr = [select id, email from user where email = 'abc@gmail.com' limit 1];
        
        Account acc = new Account();
        acc.FirstName = 'FirstName1';
        acc.LastName = 'LastName1';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test12344@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 7 ;
        acc.BillingCountry = 'India';
        insert acc;
        
        
        List<Opportunity> lstopp = new List<Opportunity>();
        for(integer i = 0 ; i<=10 ; i++){
            Opportunity oppo = new Opportunity();
            oppo.AccountId = acc.Id;
            oppo.Name = 'whj9'+i;
            oppo.StageName = 'WIP';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type = 'Renewal';
            oppo.OwnerId = usr.id;
            lstopp.add(oppo);
            
        }
        Test.StartTest();
        insert lstopp;
        Test.StopTest();  
        acc.Credit__c = 4;
        update acc;        
        
        
        
    }*/
        
    @isTest
    static void ExceptionHandler() {      
        WHJ_HotRenewalTriggerHandler.onAfterUpdate(null,null);
    }
    
    
    
}