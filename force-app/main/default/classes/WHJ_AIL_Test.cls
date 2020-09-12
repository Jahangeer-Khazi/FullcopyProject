@isTest
public class WHJ_AIL_Test {

      @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Dead Lead 1:2 Sales Manager'];
        UserRole r1 = [Select id from UserRole where Name = 'Dead Lead 1:2 Sales Manager'];
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
    
    
    
    
    static testmethod void test() 
    {
        
        Account account1 = new Account();
        account1.FirstName = 'Test';
        account1.LastName = 'Test';
        account1.PersonEmail = 'abc@gmail.com';
        account1.Referral_Call__c=false; 
        account1.BillingCountry = 'India';
        account1.Dead_Lead_1_2__c=true;
        account1.Assigned_To_Training_Team__c=true;
        insert account1;
        
         account1.Dead_Lead_1_2__c=true;
        account1.Assigned_To_Training_Team__c=true;
        update account1;
        
        Account account2 = new Account();
        account2.FirstName = 'Test';
        account2.LastName = 'Test';
        account2.PersonEmail = 'pqr@gmail.com';
        account2.Referral_Call__c=false; 
        account2.BillingCountry = 'India';
        account2.Dead_Lead_1_2__c=true;
        account2.Assigned_To_Training_Team__c=false;
        insert account2;
        
       
        Opportunity oppo1 = new Opportunity();
        oppo1.Name = 'Test1';
        oppo1.accountId= account1.id;
        oppo1.StageName = 'WIP';
        oppo1.CloseDate = date.today();
        oppo1.IsAssign__c=false;
        oppo1.Assigned_To_Trainee__c=system.today();
        oppo1.Assigned_To_Training_Team__c=true;
        oppo1.Owner_Assigned__c = false;
        oppo1.course_short_name__c='pro';
        oppo1.Dead_Lead_1_2__c=true;
        insert oppo1;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.Name = 'Test1';
        oppo2.accountId= account1.id;
        oppo2.StageName = 'WIP';
        oppo2.CloseDate = date.today();
        oppo2.IsAssign__c=false;
        oppo2.Assigned_To_Trainee__c=system.today();
        oppo2.Assigned_To_Training_Team__c=false;
        oppo2.Owner_Assigned__c = false;
        oppo2.course_short_name__c='adv';
        oppo2.Dead_Lead_1_2__c=true;
        insert oppo2;
        
        Opportunity oppo3 = new Opportunity();
        oppo3.Name = 'Test3';
        oppo3.accountId= account2.id;
        oppo3.StageName = 'WIP';
        oppo3.CloseDate = date.today();
        oppo3.IsAssign__c=false;
        oppo3.Assigned_To_Trainee__c=system.today();
        oppo3.Assigned_To_Training_Team__c=false;
        oppo3.Owner_Assigned__c = false;
        oppo3.course_short_name__c='BEG';
        oppo3.Dead_Lead_1_2__c=true;
        insert oppo3;
        
        Opportunity oppo4 = new Opportunity();
        oppo4.Name = 'Test4';
        oppo4.accountId= account2.id;
        oppo4.StageName = 'WIP';
        oppo4.CloseDate = date.today();
        oppo4.IsAssign__c=false;
        oppo4.Assigned_To_Trainee__c=system.today();
        oppo4.Assigned_To_Training_Team__c=true;
        oppo4.Owner_Assigned__c = true;
        oppo4.course_short_name__c='pro';
        oppo4.Dead_Lead_1_2__c=true;
        insert oppo4;
        
        
        Test.startTest();
        WHJ_AssignIndiaLeadsBatch be1 = new WHJ_AssignIndiaLeadsBatch();
        database.executeBatch(be1);
        Test.stopTest(); 
    }
        
       
    
}