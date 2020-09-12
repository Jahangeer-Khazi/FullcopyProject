@isTest
private class WHJ_AssignIndiaLeadsBatch_Test {
    
    @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Sales Manager'];
        UserRole r1 = [Select id from UserRole where Name = 'Sales Manager'];
        UserRole r2 = [Select id from UserRole where Name = 'Dead Lead 1:2 Team Leader'];
        
        UserRole r3 = [Select id from UserRole where Name = 'Dead Lead 1:2 Team Leader'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile pro = [SELECT Id FROM Profile WHERE Name='Referral Manager'];
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r1.id,
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
    
    
    
 
    
     static testMethod void testBatchClassfor15Days()
    {
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test Account for Batch';
        acc.Credit__c=15;
        acc.RecordtypeId= stExam;
        acc.Package_Type__c = 'Basic';
        acc.BillingCountry = 'India';
        acc.course_short_name__c = 'BEG';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Test';
        oppo.AccountId = acc.Id;
        oppo.CloseDate = System.today();
        oppo.StageName = 'WIP';
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Basic';
        insert oppo;   
        System.debug('CreatedDate::'+oppo.CreatedDate);
        Datetime yesterday = Datetime.now().addDays(-19);
        //Datetime yesterday = datetime.newInstance(2020, 08, 19, 00, 00, 00);
        
		Test.setCreatedDate(oppo.Id, yesterday);		
        System.debug('CreatedDate::'+oppo.CreatedDate);
        System.debug('owner::'+oppo.ownerId);
        
        Account acc2 = new Account();
        acc2.LastName = 'Test1 Account for Batch';
        acc2.Credit__c=15;
        acc2.Last_Class_Date__c=System.today() - 20;
        acc2.RecordtypeId= stExam;
        acc2.IsOpen__c = false;
        acc2.Package_Type__c = 'Basic';
        acc2.BillingCountry = 'India';
        acc2.course_short_name__c = 'ADV';
        insert acc2;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.Name = 'Test1';
        oppo2.AccountId = acc2.Id;
        oppo2.CloseDate = System.today();
        oppo2.StageName = 'WIP';
        oppo2.CurrencyIsoCode = 'INR';
        oppo2.Package_Sold__c = 'Basic';
        
        insert oppo2;
         Datetime yesterday1 = Datetime.now().addDays(-19);
        //Datetime yesterday = datetime.newInstance(2020, 08, 19, 00, 00, 00);
        Test.setCreatedDate(oppo2.Id, yesterday1);		
        
        Account acc1 = new Account();
        acc1.LastName = 'Test Account for Batch';
        acc1.Credit__c=15;
        acc1.RecordtypeId= stExam;
        acc1.Package_Type__c = 'Basic';
        acc1.BillingCountry = 'India';
        acc1.course_short_name__c = 'PRO';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.Name = 'Test';
        oppo1.AccountId = acc1.Id;
        oppo1.CloseDate = System.today();
        oppo1.StageName = 'WIP';
        oppo1.CurrencyIsoCode = 'INR';
        oppo1.Package_Sold__c = 'Basic';
        insert oppo1;   
        
        Datetime yesterday3 = Datetime.now().addDays(-19);
        //Datetime yesterday = datetime.newInstance(2020, 08, 19, 00, 00, 00);
        
		Test.setCreatedDate(oppo1.Id, yesterday3);		

        
        
               
        Test.StartTest();
        oneTimeBatch obj = new oneTimeBatch();
        DataBase.executeBatch(obj);
        String sch = '0  00 1 3 * ?';
        //system.schedule('Test', sch, obj);       
        Test.StopTest();
        
    } 
    
         
}