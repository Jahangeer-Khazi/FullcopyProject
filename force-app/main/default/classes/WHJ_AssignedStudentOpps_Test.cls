/*White Hat Junior Assigned Student Opps TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 25/09/2019
 *Purpose: This Test class is to test Data for WHJ_AssignedStudentOpps trigger.
 */ 

@isTest
public class WHJ_AssignedStudentOpps_Test {
    @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Student Ops Manager'];
    //    insert r;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.id,Batch_Type__c = 'ONE_TO_TWO',
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhr@testorg.com',Sales_Region__c = 'India',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available'     );
        User u1 = new User(Alias = 'test2', Email='abc2@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg2', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.id,Batch_Type__c = 'ONE_TO_ONE',
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhr2@testorg.com',Sales_Region__c = 'India',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available'     );
              User u2 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.id,Batch_Type__c = 'ONE_TO_TWO',
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1@testorg.com',Sales_Region__c = 'International',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available'     );
            User u3 = new User(Alias = 'test13', Email='abc13@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg13', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.id,Batch_Type__c = 'ONE_TO_ONE',
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhr13@testorg.com',Sales_Region__c = 'International',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available'     );
        insert u;
        insert u1;
        insert u2;
        insert u3;
    }
    @isTest
    static void insertAccount() {      
        Account account = new Account();
        account.LastName = 'Test Account1';
        account.Last_Teacher_Feedback_Date__c=System.today();
        //            account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Batch_Type__c = 'ONE_TO_TWO';
        insert account;   


    }
    @isTest
     static void insertAccount1() {      
        Account account1 = new Account();
        account1.LastName = 'Test Account2';
        account1.Last_Teacher_Feedback_Date__c=System.today();
        //            account.Activation_Date__c = System.today();
        account1.Status__c = 'Active';
        account1.Batch_Type__c = null;
        insert account1;   
    }
    
    @isTest
      static void updateAccount() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        //            account.Activation_Date__c = System.today();
        account.Status__c = 'Opportunity';
          account.Batch_Type__c = 'ONE_TO_TWO';
        insert account;   
        
        account.LastName = 'Test Account1';
        account.Status__c = 'Active';
        account.Last_Teacher_Feedback_Date__c=System.today();
        update account;      
    }
    
     @isTest
      static void updateAccountforRegioIndia() {      
        Account account = new Account();
        account.LastName = 'Test Account2';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        //            account.Activation_Date__c = System.today();
        account.Status__c = 'Opportunity';
          account.Batch_Type__c = 'ONE_TO_ONE';
        insert account;   
        
        account.LastName = 'Test Account2';
        account.Status__c = 'Active';
        account.Last_Teacher_Feedback_Date__c=System.today();
        update account;      
    }

    static testMethod void testassignForV2(){
       Account acc = new Account();
       acc.LastName = 'testAssign';
       acc.BillingCountry = 'International';
        acc.Batch_Type__c = 'ONE_TO_ONE';
       insert acc;
       
       Opportunity oppo = new Opportunity();
       oppo.AccountId = acc.Id;
       oppo.Name = 'whj';
       oppo.StageName = 'WON-PART PAYMENT';
       oppo.CloseDate = Date.newInstance(1960, 2, 17);
       oppo.Type = 'New Student';
        insert oppo;
        }
    
    @isTest
      static void coverZendeskMethod() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        //            account.Activation_Date__c = System.today();
        account.Status__c = 'Opportunity';
        account.PersonMobilePhone = '8787878787';
          account.Batch_Type__c = 'ONE_TO_TWO';
        insert account;   
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'Test Opty';
        oppo.CloseDate = System.today();
        oppo.StageName = 'WIP';  
        oppo.MobileNumber__c = '7485961230';
        insert oppo;  
       
        account.LastName = 'Test Account1';
        account.Status__c = 'Active';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.PersonMobilePhone = '7412589630';  
        update account;      
    }
}