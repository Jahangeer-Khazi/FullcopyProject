@isTest
public class WHJ_DeadLead_ReferralBatch_Test {
     
    @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Dead Leads Referrals Manager'];
        //insert r;
        UserRole r1 = [Select id from UserRole where Name = 'Dead Leads Referrals Manager - USA'];
        UserRole r2 = [Select id from UserRole where Name = 'Dead Leads Referrals Team Leader'];
        
        UserRole r3 = [Select id from UserRole where Name = 'Dead Leads Referrals Team Leader - USA'];
        
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
    
    
    
    
    
    static testMethod void ReferralsINDIA()
    { 
        Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'abc@gmail.com' ,Referral_Call__c=false, BillingCountry = 'India');
        insert account;
        
        Opportunity oppo1 = new Opportunity(Name = 'Test1' , accountId= account.id, StageName = 'WIP', CloseDate = date.today() );
        insert oppo1;
        Datetime yesterday1 = Datetime.now().addDays(-70);
        Test.setCreatedDate(oppo1.Id,yesterday1);
        list<Account> lstAcc = new list<Account>();
        lstAcc.add(account);
        System.debug('Stage_Won__c::'+oppo1.Stage_Won__c);
        System.debug('CreatedDate::'+oppo1.CreatedDate);
        System.debug('Student_Country__c::'+oppo1.Student_Country__c);
        
        Test.StartTest();
        WHJ_DeadLead_ReferralBatchINDIA obj2 = new WHJ_DeadLead_ReferralBatchINDIA();
        WHJ_DeadLead_ReferralBatchUSA obj3  = new WHJ_DeadLead_ReferralBatchUSA();
        obj2.execute(null,lstAcc);
        obj3.execute(null,lstAcc);
        DataBase.executeBatch(obj2);
        DataBase.executeBatch(obj3);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, obj2);    
        system.schedule('Test3', sch, obj3);  
        Test.StopTest();
    }
}