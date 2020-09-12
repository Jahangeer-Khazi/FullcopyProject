@isTest
public class WHJ_CaseHandlerForZendesk_Test {
    @isTest
    static void coverZendeskMethod() {   
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.PersonEmail = 'test@abc.com';
        account.Parent_Name__c = 'Test Parent Name';
        //            account.Activation_Date__c = System.today();
        account.Status__c = 'Opportunity';
        account.PersonMobilePhone = '8787878787';  
        insert account;   
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser210820@testorg.com');
        JSON2ApexZendeskToSF tmpjson =  new JSON2ApexZendeskToSF();
        tmpjson.ticket = new JSON2ApexZendeskToSF.Ticket();
        tmpjson.ticket.url = 'test';
        tmpjson.ticket.id = 121;
        tmpjson.ticket.external_id = 'test';
        
        System.runAs(u) {
            //System.debug('@@@ User'+[select id,])
            Case cs = new Case();
            cs.Status ='New';
            cs.AccountId =  account.Id;
            cs.origin = 'Email';
            cs.Send_to_Zendesk__c  = 'True';
            cs.Category__c = 'Student has not joined yet';
            cs.subject = 'Test Case Subject';
            cs.Type = 'Problem';
            cs.Description = 'Test Description for case';
            insert cs;          
        }
    }
    
    @isTest
    static void coverZendeskMethodErrorMsg() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Parent_Name__c = 'Test Parent Name';
        account.Status__c = 'Opportunity';
        account.PersonMobilePhone = '8787878787';  
        insert account;   
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser210820@testorg.com');
        
        System.runAs(u) {
            Case cs = new Case();
            cs.Status ='New';
            cs.AccountId =  account.Id;
            cs.origin = 'Email';
            cs.Send_to_Zendesk__c  = 'True';
            cs.subject = 'Test Case Subject';
            cs.Type = 'Problem';
            insert cs;          
        }
    }
    @isTest
    static void coverZendeskMethodTickets() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Parent_Name__c = 'Test Parent Name';
        account.Status__c = 'Opportunity';
        account.PersonMobilePhone = '8787878787';  
        insert account;   
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser210820@testorg.com');
        
        System.runAs(u) {
            Case cs = new Case();
            cs.Status ='New';
            cs.AccountId =  account.Id;
            cs.origin = 'Email';
            cs.Send_to_Zendesk__c  = 'false';
            cs.subject = 'Test Case Subject';
            cs.Type = 'Problem';
            cs.Description = 'Test Case Details';
            cs.Category__c = 'Student has not joined yet';
            insert cs;        
            System.enqueuejob(new WHJ_CaseHandlerForZendesk(new List<case>{cs}));
        }
    }
    @isTest
    static void coverZendeskToSalesforceOwnerChanges() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Parent_Name__c = 'Test Parent Name';
        account.Status__c = 'Opportunity';
        account.PersonMobilePhone = '8787878787'; 
        account.PersonEmail = 'test@abc.com';
        insert account;   
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser210820@testorg.com');
        
        System.runAs(u) {
            Case cs = new Case();
            cs.Status ='New';
            cs.AccountId =  account.Id;
            cs.origin = 'Email';
            cs.Send_to_Zendesk__c  = 'true';
            cs.subject = 'Test Case Subject';
            cs.Type = 'Problem';
            cs.Description = 'Test Case Details';
            cs.Zendesk_Support_Ticket_Requester_Email__c = 'test@abc.com';
            insert cs;        
            System.enqueuejob(new WHJ_CaseHandlerForZendesk(new List<case>{cs}));
        }
    }
}