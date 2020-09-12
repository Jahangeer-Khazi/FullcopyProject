@isTest
public class WHJ_Test_AssignIndiaLeads {
    
    @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Sales Manager'];
        UserRole r1 = [Select id from UserRole where Name = 'Dead Lead 1:2 Sales Manager'];
        UserRole r2 = [Select id from UserRole where Name = 'Dead Lead 1:2 Team Leader'];
        
        UserRole r3 = [Select id from UserRole where Name = 'Dead Lead 1:2 Team Leader'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile pro = [SELECT Id FROM Profile WHERE Name='Referral Manager'];
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                          ,Sales_Region__c = 'International'    );
        insert u;
        
        User u9 = new User(Alias = 'test123', Email='abc123@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available', Package_Type__c = 'APT' 
                           ,Sales_Region__c = 'IndiaV2'    );
        insert u9;
        User u10 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                            EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1@testorg.com',
                            Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                            ,Sales_Region__c = 'International'    );
        insert u10; 
        
        
        User u2 = new User(Alias = 'test12', Email='abc12@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg12', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr12test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'IndiaV2'    );
        insert u2;
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u1; 
        
        User u3 = new User(Alias = 't23', Email='abc123@gmail.com',  isActive = false ,
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u3;
        
        User u4 = new User(Alias = 'te34', Email='abc1234@gmail.com', isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1234te@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u4; 
        
        User u5 = new User(Alias = 'tes356', Email='abc123225@gmail.com',  isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Test3ingg51', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r3.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123te@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u5;
        
        User u6 = new User(Alias = 'te336', Email='abc13332345@gmail.com', isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Test33ingg31', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r3.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1234test12@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u6; 
    }
    
    @isTest
    public static void test8020Percentage()
    {
        User u = [Select id from User where LastName = 'Testingg'];
        //Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.Credit__c=15;
        acc.Last_Class_Date__c=System.today() - 20;
        acc.course_short_name__c= 'ADV';
        acc.IsOpen__c = false;
        acc.Package_Type__c = 'Basic';
        acc.BillingCountry = 'IndiaV2';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Test';
        oppo.AccountId = acc.Id;
        oppo.CloseDate = System.today();
        oppo.StageName = 'WIP';
        oppo.Type = 'New Student';
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Basic';
        oppo.Assigned_To_Trainee__c = Date.newInstance(2020, 04,01);
        oppo.IsAssign__c = false;
        oppo.OwnerId = u.Id;
        insert oppo;       
        Datetime yesterday = Datetime.now().addDays(-19);
        //Datetime yesterday = datetime.newInstance(2020, 08, 19, 18, 30, 00);
        Test.setCreatedDate(oppo.Id,yesterday);
        
        Account acc1 = new Account();
        acc1.LastName = 'Test';
        acc1.Credit__c=15;
        acc1.Last_Class_Date__c=System.today() - 20;
        acc1.course_short_name__c= 'ADV';
        acc1.IsOpen__c = false;
        acc1.Package_Type__c = 'Basic';
        acc1.BillingCountry = 'IndiaV2';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.Name = 'Test';
        oppo1.AccountId = acc1.Id;
        oppo1.CloseDate = System.today();
        oppo1.StageName = 'WIP';
        oppo1.Type = 'New Student';
        oppo1.CurrencyIsoCode = 'INR';
        oppo1.Package_Sold__c = 'Basic';
        oppo1.Assigned_To_Trainee__c = Date.newInstance(2020, 04,01);
        oppo1.IsAssign__c = false;
        oppo1.OwnerId = u.Id;
        insert oppo1;       
        Datetime yesterday1 = Datetime.now().addDays(-19);
        Test.setCreatedDate(oppo1.Id,yesterday1);
        
        Account acc2 = new Account();
        acc2.LastName = 'Test';
        acc2.Credit__c=15;
        acc2.Last_Class_Date__c=System.today() - 20;
        acc2.course_short_name__c= 'BEG';
        acc2.IsOpen__c = false;
        acc2.Package_Type__c = 'Basic';
        acc2.BillingCountry = 'IndiaV2';
        insert acc2;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.Name = 'Test';
        oppo2.AccountId = acc2.Id;
        oppo2.CloseDate = System.today();
        oppo2.StageName = 'WIP';
        oppo2.Type = 'New Student';
        oppo2.CurrencyIsoCode = 'INR';
        oppo2.Package_Sold__c = 'Basic';
        oppo2.Assigned_To_Trainee__c = Date.newInstance(2020, 04,01);
        oppo2.IsAssign__c = false;
        oppo2.OwnerId = u.Id;
        insert oppo2;       
        Datetime yesterday2 = Datetime.now().addDays(-19);
        Test.setCreatedDate(oppo2.Id,yesterday2);
        
        
        Test.StartTest();
        WHJ_AssignIndiaLeadsBatch obj = new  WHJ_AssignIndiaLeadsBatch();
        
        
        DateTime todayDateTime = DateTime.now();
        String strToday = String.valueOf(todayDateTime.year()) + String.valueOf(todayDateTime.month()) + String.valueOf(todayDateTime.day()) + String.valueOf(todayDateTime.hour()) + String.valueOf(todayDateTime.minute()) + String.valueOf(todayDateTime.second());
        System.schedule('Test Job PostPaymentBatch_' + strToday, '0 0 18 ? * * *',obj);
        DataBase.executeBatch(obj);
        
        
        Test.StopTest();
        
    }
    /*
static testmethod void validateTestCOdeCoverage() {
WHJ_AssignIndiaLeadsBatch.testCodeCOverage();
}*/
    @isTest
    public static void testUpdateOpportunitiesBatch()
    {
        User u = [Select id from User where LastName = 'Testingg'];
        //Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        List<Opportunity> indiaOpps = new List<Opportunity>();
        List<String> advOppsIds = new List<String>();
        List<String> begOppsIds = new List<String>();
        Map<Id, Account> oppidsAccount = new Map<Id, Account>();
        
        Account acc = new Account();
        acc.LastName = 'Test';
        acc.Credit__c=15;
        acc.Last_Class_Date__c=System.today() - 20;
        acc.course_short_name__c= 'ADV';
        acc.IsOpen__c = false;
        acc.Package_Type__c = 'Basic';
        acc.BillingCountry = 'IndiaV2';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Test';
        oppo.AccountId = acc.Id;
        oppo.CloseDate = System.today();
        oppo.StageName = 'WIP';
        oppo.Type = 'New Student';
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Basic';
        oppo.Assigned_To_Trainee__c = Date.newInstance(2020, 04,01);
        oppo.IsAssign__c = false;
        oppo.OwnerId = u.Id;
        insert oppo;       
        Datetime yesterday = Datetime.now().addDays(-19);
        //Datetime yesterday = datetime.newInstance(2020, 08, 19, 18, 30, 00);
        Test.setCreatedDate(oppo.Id,yesterday);
        indiaOpps.add(oppo);
        advOppsIds.add(oppo.Id);
        oppidsAccount.put(oppo.Id,acc);
        
        Account acc1 = new Account();
        acc1.LastName = 'Test';
        acc1.Credit__c=15;
        acc1.Last_Class_Date__c=System.today() - 20;
        acc1.course_short_name__c= 'ADV';
        acc1.IsOpen__c = false;
        acc1.Package_Type__c = 'Basic';
        acc1.BillingCountry = 'IndiaV2';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.Name = 'Test';
        oppo1.AccountId = acc1.Id;
        oppo1.CloseDate = System.today();
        oppo1.StageName = 'WIP';
        oppo1.Type = 'New Student';
        oppo1.CurrencyIsoCode = 'INR';
        oppo1.Package_Sold__c = 'Basic';
        oppo1.Assigned_To_Trainee__c = Date.newInstance(2020, 04,01);
        oppo1.IsAssign__c = false;
        oppo1.OwnerId = u.Id;
        insert oppo1;       
        Datetime yesterday1 = Datetime.now().addDays(-19);
        Test.setCreatedDate(oppo1.Id,yesterday1);
        indiaOpps.add(oppo1);
        advOppsIds.add(oppo1.Id);
        oppidsAccount.put(oppo1.Id,acc1);
        
        Account acc2 = new Account();
        acc2.LastName = 'Test';
        acc2.Credit__c=15;
        acc2.Last_Class_Date__c=System.today() - 20;
        acc2.course_short_name__c= 'BEG';
        acc2.IsOpen__c = false;
        acc2.Package_Type__c = 'Basic';
        acc2.BillingCountry = 'IndiaV2';
        insert acc2;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.Name = 'Test';
        oppo2.AccountId = acc2.Id;
        oppo2.CloseDate = System.today();
        oppo2.StageName = 'WIP';
        oppo2.Type = 'New Student';
        oppo2.CurrencyIsoCode = 'INR';
        oppo2.Package_Sold__c = 'Basic';
        oppo2.Assigned_To_Trainee__c = Date.newInstance(2020, 04,01);
        oppo2.IsAssign__c = false;
        oppo2.OwnerId = u.Id;
        insert oppo2;       
        Datetime yesterday2 = Datetime.now().addDays(-19);
        Test.setCreatedDate(oppo2.Id,yesterday2);
        indiaOpps.add(oppo2);
        begOppsIds.add(oppo2.Id);
        oppidsAccount.put(oppo2.Id,acc2);
        
        Test.StartTest();
       	WHJ_UpdateOpportunitiesBatch childBatch = new WHJ_UpdateOpportunitiesBatch(indiaOpps, advOppsIds, begOppsIds, oppidsAccount);
        ID childBatchId = Database.executeBatch(childBatch); 
        Test.StopTest();
        
    }
    
    
}