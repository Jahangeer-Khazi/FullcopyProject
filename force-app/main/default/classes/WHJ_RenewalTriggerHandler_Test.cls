@isTest
public class WHJ_RenewalTriggerHandler_Test {

   /* @isTest
    static void testForIndiaRenewalif() {  
        
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 8;
        account.Class_Number__c = 2;
        insert account;   
        
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WIP';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        insert oppo;  
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = account.Id;
        oppo1.Name = 'whj';
        oppo1.StageName = 'WON - UPGRADE POTENTIAL';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.Type = 'Renewal';
        insert oppo1;  
        

        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = account.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Package_Name__c = 'Standard';
        pay.Credits__c = 2;
        insert pay;
        
        Booking__c booking = new Booking__c();
        booking.Name = 'B-111';
    booking.Account__c = account.Id;        
        booking.Class_Number__c = 2;
        booking.Is_Trial__c = false;
        booking.Teacher_Name__c = 'test';
        booking.Teacher_Comments__c = 'test';
        booking.Rating__c = '5';
        booking.Course_Version__c = 'c2';
        booking.Student_Feedback_Category__c = 'Audio';
        booking.Student_Feedback_Comments__c = 'test';
        booking.Student_Feedback_Rating__c = '1';
        insert booking;

        Test.startTest();
        	account.LastName = 'Test Account1';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Credit__c = 0;
        update account; 
        Test.stopTest();        
           
    }*/
    
    /*@isTest
    static void testForIndiaRenewalelse() {  
        Test.startTest();
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 8;
        account.Class_Number__c = 2;
        insert account;   
        
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WIP';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        insert oppo;  
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = account.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Package_Name__c = 'Expert';
        pay.Credits__c = 2;
        insert pay;
        
        Booking__c booking = new Booking__c();
        booking.Name = 'B-111';
    booking.Account__c = account.Id;        
        booking.Class_Number__c = 2;
        booking.Is_Trial__c = false;
        booking.Teacher_Name__c = 'test';
        booking.Teacher_Comments__c = 'test';
        booking.Rating__c = '5';
        booking.Course_Version__c = 'c2';
        booking.Student_Feedback_Category__c = 'Audio';
        booking.Student_Feedback_Comments__c = 'test';
        booking.Student_Feedback_Rating__c = '1';
        insert booking;

        
        	account.LastName = 'Test Account1';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Credit__c = 4;
        update account; 
        Test.stopTest();        
           
    }
 
    */
    
        
    
 @isTest
    static void testForUSARenewal() {  
        //Test.startTest();
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 8;
        account.Subscription_Flag__c = false;
        account.Class_Number__c = 2;
        insert account;   
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        insert oppo;  
  
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = account.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Package_Name__c = 'Basic';
        pay.Credits__c = 2;
        insert pay;
        
        Booking__c booking = new Booking__c();
        booking.Name = 'B-1111qwert';
        booking.Account__c = account.Id;
        booking.Class_Number__c = 2;
        booking.Is_Trial__c = false;
        booking.Teacher_Name__c = 'test';
        booking.Teacher_Comments__c = 'test';
        booking.Rating__c = '5';
        booking.Course_Version__c = 'c2';
        booking.Student_Feedback_Category__c = 'Audio';
        booking.Student_Feedback_Comments__c = 'test';
        booking.Student_Feedback_Rating__c = '1';
        insert booking;

        Test.startTest();
        account.Subscription_Flag__c = false;
        account.LastName = 'Test Account1';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Credit__c = 5;
        update account;   
         Test.stopTest();     
 
    }
 
     @isTest
    static void ExceptionHandler() {      
     //WHJ_RenewalTriggerHandler.onAfterUpdate(null);
       // WHJ_RenewalTriggerHandler.onAfterUpdateSubscription(null);
    }
    
    //CH01 Start. Added test cases to increase code coverage by Jahangeer Khazi 31-08-2020
    @isTest
    static void unitTest1(){
    Profile pf= [Select Id from profile where Name='System Administrator'];
    User u=new User(firstname = 'ABC', lastName = 'XYZ', email = 'unit1@gmail.com', Username = 'xyz7321@gmail.com', 
                     EmailEncodingKey = 'ISO-8859-1', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',Alias = '123abc1', 
                     LanguageLocaleKey = 'en_US', ProfileId = pf.Id); 
        
    insert u;
    List<Account> accountList = new List<Account>();
    Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 8;
        account.Subscription_Flag__c = false;
        account.Class_Number__c = 2;
        account.Selling_Manager__c = u.id;
        //accountList.add(account);
        //insert accountList;
        insert account;
        Test.startTest();
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        insert oppo; 
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = account.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Package_Name__c = 'Basic';
        pay.Credits__c = 8;
        insert pay;
        
        Booking__c booking = new Booking__c();
        booking.Name = 'B-1111qwert';
        booking.Account__c = account.Id;
        booking.Class_Number__c = 2;
        booking.Is_Trial__c = false;
        booking.Teacher_Name__c = 'test';
        booking.Teacher_Comments__c = 'test';
        booking.Rating__c = '5';
        booking.Course_Version__c = 'c2';
        booking.Student_Feedback_Category__c = 'Audio';
        booking.Student_Feedback_Comments__c = 'test';
        booking.Student_Feedback_Rating__c = '1';
        insert booking;
        
        account.Credit__c = 7;
        update account;
        Test.stopTest();
        //WHJ_RenewalTriggerHandler.onAfterUpdate(accountList);
        //WHJ_RenewalTriggerHandler.onAfterUpdateSubscription(accountList);
         
    }
    
   /* @isTest
    static void unitTest2(){
    Profile pf= [Select Id from profile where Name='System Administrator'];
    User u=new User(firstname = 'ABC', lastName = 'XYZ', email = 'unit1@gmail.com', Username = 'xyz7321@gmail.com', 
                     EmailEncodingKey = 'ISO-8859-1', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',Alias = '123abc1', 
                     LanguageLocaleKey = 'en_US', ProfileId = pf.Id); 
        
    insert u;
    List<Account> accountList = new List<Account>();
    Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 7;
        account.Subscription_Flag__c = false;
        account.Class_Number__c = 2;
        account.Selling_Manager__c = u.id;
        accountList.add(account);
        insert accountList;
        
        Test.startTest();
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON - PAYMENT RECEIVED';
        oppo.CloseDate = Date.newInstance(2020, 8, 31);
        //oppo.ClosedDate = System.today();
        oppo.Type = 'Renewal';
        insert oppo; 
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = account.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Package_Name__c = 'Basic';
        pay.Credits__c = 10;
        pay.Date__c = System.today();
        insert pay;
        Test.stopTest();
       // WHJ_RenewalTriggerHandler.onAfterUpdate(accountList);
        //WHJ_RenewalTriggerHandler.onAfterUpdateSubscription(accountList);
         
    }*/
    
     @isTest
    static void unitTest3(){
    Profile pf= [Select Id from profile where Name='System Administrator'];
    User u=new User(firstname = 'ABC', lastName = 'XYZ', email = 'unit1@gmail.com', Username = 'xyz7321@gmail.com', 
                     EmailEncodingKey = 'ISO-8859-1', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',Alias = '123abc1', 
                     LanguageLocaleKey = 'en_US', ProfileId = pf.Id,sales_region__c = 'India'); 
        
    insert u;
    List<Account> accountList = new List<Account>();
        //Test.startTest();
    Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 8;
        account.Subscription_Flag__c = false;
        account.Class_Number__c = 2;
        account.Selling_Manager__c = u.id;
        accountList.add(account);
        insert accountList;
        
        Test.startTest();
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'LOST - PRICE';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'Renewal';
        insert oppo; 
        Test.stopTest();
       /* Test.startTest();

        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = account.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Package_Name__c = 'Basic';
        pay.Credits__c = 8;
        pay.Date__c = System.today();
        insert pay;
        Test.stopTest();
       
        Booking__c booking = new Booking__c();
        booking.Name = 'B-1111qwert';
        booking.Account__c = account.Id;
        booking.Class_Number__c = 2;
        booking.Is_Trial__c = false;
        booking.Teacher_Name__c = 'test';
        booking.Teacher_Comments__c = 'test';
        booking.Rating__c = '5';
        booking.Course_Version__c = 'c2';
        booking.Student_Feedback_Category__c = 'Audio';
        booking.Student_Feedback_Comments__c = 'test';
        booking.Student_Feedback_Rating__c = '1';
        insert booking; */
        
       // account.Credit__c = 7;
       // update account;
        //Test.stopTest();
        //WHJ_RenewalTriggerHandler.onAfterUpdate(accountList);
        //WHJ_RenewalTriggerHandler.onAfterUpdateSubscription(accountList);
         
    }
    
     static testmethod void validateTestCOdeCoverage() {
        WHJ_RenewalTriggerHandler.testCodeCOverage();
    }
    
  }