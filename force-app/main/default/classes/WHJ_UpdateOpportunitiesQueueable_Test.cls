@isTest
public class WHJ_UpdateOpportunitiesQueueable_Test {
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
        List<User> u = [Select id from User where LastName = 'Testingg'];
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
        List<Account> accList = new List<Account>();
        accList.add(acc);
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
        oppo.OwnerId = u[0].Id;
        insert oppo; 
         
         List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(oppo);
       
        
       
        
        Test.StartTest();
      
        WHJ_UpdateOpportunitiesQueueable q2 = new WHJ_UpdateOpportunitiesQueueable(oppList,u,accList);
		q2.execute(null); 
        Test.StopTest();
        
    }
        
}