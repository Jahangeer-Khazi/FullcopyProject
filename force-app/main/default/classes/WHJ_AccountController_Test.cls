@IsTest
public class WHJ_AccountController_Test {
    
    static testMethod void onAfterInsert()
    {
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test Account for Batch';
        acc.Credit__c=15;
        acc.Last_Teacher_Feedback_Date__c=System.today();
        acc.RecordtypeId= stExam;
        acc.BillingCountry = 'India';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'Test Opty';
        oppo.StageName = 'WIP';
        oppo.CloseDate = system.today();
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Expert';
        insert oppo;
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = acc.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Amount__c = 43434;
        pay.Credits__c = 4;
        pay.Payment_Type__c = 'Organic';
        pay.Package_Name__c = 'Expert';
        insert pay;
        
        test.startTest();
        acc.Status__c = 'Active';
        update acc;
        test.stopTest();
    }
    
    static testMethod void onCatch()
    {
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test Account for Batch';
        acc.Credit__c=15;
        acc.Last_Teacher_Feedback_Date__c=System.today();
        acc.RecordtypeId= stExam;
        acc.BillingCountry = 'India';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'Test Opty';
        oppo.StageName = 'WIP';
        oppo.CloseDate = system.today();
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Expert';
        insert oppo;
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = acc.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Amount__c = 43434;
        pay.Credits__c = 4;
        pay.Payment_Type__c = 'Organic';
        pay.Package_Name__c = 'Expert';
        insert pay;
        /* Payment__c pay1 = new Payment__c();
pay1.Name = 'pay-02';
pay1.Account__c = acc.Id;
pay1.Opportunity__c = oppo.Id;
pay1.Amount__c = 43434;
pay1.Credits__c = 4;
pay1.Payment_Type__c = 'Organic';
pay1.Package_Name__c = 'Expert';
insert pay1;
Payment__c pay2 = new Payment__c();
pay2.Name = 'pay-03';
pay2.Account__c = acc.Id;
pay2.Opportunity__c = oppo.Id;
pay2.Amount__c = 43434;
pay2.Credits__c = 4;
pay2.Payment_Type__c = 'Organic';
pay2.Package_Name__c = 'Expert';
insert pay2;*/
        test.startTest();
        acc.Status__c = 'Active';
        update acc;
        test.stopTest();
    }
    
    static testMethod void testForDirectPayment()
    {
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test Account for Batch';
        acc.Credit__c=15;
        acc.Last_Teacher_Feedback_Date__c=System.today();
        acc.RecordtypeId= stExam;
        acc.BillingCountry = 'India';
        acc.Status__c = 'Active';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'Test Opty';
        oppo.StageName = 'WIP';
        oppo.CloseDate = system.today();
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Expert';
        insert oppo;
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = acc.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Amount__c = 43434;
        pay.Credits__c = 4;
        pay.Payment_Type__c = 'Organic';
        pay.Package_Name__c = 'Expert';
        insert pay;
    }
    @isTest
    static void setup()
    {
        
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 2;
        account.Batch_Id__c = 'A';
        account.SLA_First_Calll__c = true;
        insert account;      
        Account account1 = new Account();
        account1.LastName = 'Test Account 1';
        account1.BillingCountry = 'India';
        account1.Last_Teacher_Feedback_Date__c=System.today();
        account1.Activation_Date__c = System.today();
        account1.Status__c = 'Active';
        account1.Credit__c = 2;
        account1.Batch_Id__c = 'A';
        account1.SLA_First_Calll__c = true;
        insert account1;      
    }
    
    @isTest
    static void onAfterUpdate1() {  
        List<Account> lstAcc = new List<Account>(); 
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 2;
        account.SLA_First_Calll__c = true;
        insert account;   
        Test.startTest();
        account.Batch_Id__c = 'A';
        update account;        
        Test.stopTest();
    }
    
    
    @isTest
    static void onAfterUpdate2() {  
        
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 2;
        account.Batch_Id__c = 'A';
        account.SLA_First_Calll__c = true;
        insert account;   
        Test.startTest();
        account.Batch_Id__c = 'B';
        update account;        
        Test.stopTest();
    }
    
    @isTest
    static void onAfterUpdate3() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 22;
        account.Subscription_Flag__c = false;
        account.Batch_Id__c = 'A';
        account.Pair_Found__c = true;
        account.SLA_First_Calll__c = true;
        insert account;   
        Test.startTest();
        account.Batch_Id__c = 'B';
        update account;        
        Test.stopTest();        
    }
    
    
    @isTest
    static void onAfterUpdate4() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 22;
        account.Subscription_Flag__c = false;
        account.Batch_Id__c = 'A';
        account.SLA_First_Calll__c = true;
        insert account; 
        Account account1 = new Account();
        account1.LastName = 'Test Account1';
        account1.BillingCountry = 'USA';
        account1.Last_Teacher_Feedback_Date__c=System.today();
        account1.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account1.Status__c = 'Active';
        account1.Credit__c = 22;
        account1.Subscription_Flag__c = false;
        account1.Batch_Id__c = 'A';
        account1.SLA_First_Calll__c = true;
        insert account1;
        Test.startTest();
        account.Batch_Id__c = 'B';
        update account;
        Test.stopTest();
        
    }
    @isTest
    static void onAfterUpdate5() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 22;
        account.Subscription_Flag__c = false;
        account.Batch_Id__c = 'A';
        account.SLA_First_Calll__c = true;
        insert account; 
        Account account1 = new Account();
        account1.LastName = 'Test Account1';
        account1.BillingCountry = 'USA';
        account1.Last_Teacher_Feedback_Date__c=System.today();
        account1.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account1.Status__c = 'Active';
        account1.Credit__c = 22;
        account1.Subscription_Flag__c = false;
        account1.Batch_Id__c = 'A';
        account1.SLA_First_Calll__c = true;
        insert account1;
        Test.startTest();
        account.Batch_Id__c = '';
        update account;
        Test.stopTest();
        
    }
    
    @isTest
    static void onAfterUpdate6() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 22;
        account.Subscription_Flag__c = false;
        account.Batch_Id__c = 'A';
        account.SLA_First_Calll__c = true;
        insert account; 
        Account account1 = new Account();
        account1.LastName = 'Test Account1';
        account1.BillingCountry = 'USA';
        account1.Last_Teacher_Feedback_Date__c=System.today();
        account1.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account1.Status__c = 'Active';
        account1.Credit__c = 22;
        account1.Subscription_Flag__c = false;
        account1.Batch_Id__c = 'B';
        account1.SLA_First_Calll__c = true;
        
        insert account1;
        Test.startTest();
        account1.Batch_Id__c = 'A';
        update account1;
        Test.stopTest();
        
    }
    
    
    @isTest
    static void onAfterUpdate7() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 22;
        account.Subscription_Flag__c = false;
        account.Batch_Id__c = 'A';
        account.Pair_Found__c = true;
        account.SLA_First_Calll__c = true;
        insert account; 
        Account account0 = new Account();
        account0.LastName = 'Test Account1';
        account0.BillingCountry = 'USA';
        account0.Last_Teacher_Feedback_Date__c=System.today();
        account0.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account0.Status__c = 'Active';
        account0.Credit__c = 22;
        account0.Subscription_Flag__c = false;
        account0.Batch_Id__c = 'A';
        account0.Pair_Found__c = true;
        account0.SLA_First_Calll__c = true;
        insert account0; 
        Account account1 = new Account();
        account1.LastName = 'Test Account';
        account1.BillingCountry = 'USA';
        account1.Last_Teacher_Feedback_Date__c=System.today();
        account1.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account1.Status__c = 'Active';
        account1.Credit__c = 22;
        account1.Subscription_Flag__c = false;
        account1.Batch_Id__c = 'B';
        account1.Pair_Found__c = true;
        account1.SLA_First_Calll__c = true;
        insert account1;
        Test.startTest();
        account1.Batch_Id__c = 'B';
        update account1;
        Test.stopTest();
    }
    
}