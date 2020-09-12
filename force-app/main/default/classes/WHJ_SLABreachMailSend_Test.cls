@isTest
public class WHJ_SLABreachMailSend_Test {
    
    @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Sales Manager'];
        //insert r;
        UserRole r1 = [Select id from UserRole where Name = 'Renewals Manager'];
        UserRole r2 = [Select id from UserRole where Name = 'Referral Manager'];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r1.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                          ,Sales_Region__c = 'International'    );
        insert u;
        
             User u1 = new User(Alias = 'test123', Email='abc123@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available', Package_Type__c = 'APT' 
                           ,Sales_Region__c = 'IndiaV2',managerId =u.Id);
        insert u1;
        User u2 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International',managerId=u1.Id);
        insert u2; 
        
        
        User u3 = new User(Alias = 'test12', Email='abc12@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg12', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr12test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'IndiaV2' ,managerId=u2.Id);
        insert u3;
    }
    
    static testmethod void test() 
    {
        User usr = [select Id, name from User where email = 'abc12@gmail.com' limit 1];
        
            List<Account> lstAcc = new List<Account>(); 
            
            Account account = new Account();
            account.LastName = 'Test Account';
            account.BillingCountry = 'India';
            account.Last_Teacher_Feedback_Date__c=System.today();
            account.Activation_Date__c = System.today();
            account.Status__c = 'Active';
            account.Credit__c = 5;
            insert account;
            List<Configuration__mdt> conlstRenewal= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='RoleForRenewal'];
            System.debug('conlstRenewal::'+conlstRenewal);
            
            Opportunity oppo = new Opportunity();
            oppo.AccountId = account.Id;
            oppo.Name = 'whj';
            oppo.StageName = 'WIP';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type = 'Renewal';
            oppo.OwnerId = usr.Id;
            
            insert oppo; 
            oppo.SendMailto_TL_Director_VP__c = true;
            oppo.Send_Mail_To_AuditTeam__c = true;
            oppo.SendMailToAuditTeamIn72Hours__c = true;
            update oppo;
            
            Test.startTest();
            WHJ_SLABreachMailSend be1 = new WHJ_SLABreachMailSend();
            Test.stopTest();   
        
          
    }
    
    static testmethod void testSLABreachfor1hr() 
    {
          List<Account> lstAcc = new List<Account>(); 
        
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 5;
        insert account;
        
        Test.startTest();
        account.SendMailSLAbreach__c = true;
        update account;
        Test.stopTest(); 
    }
    
    static testmethod void testSLABreachfor2hr() 
    {
          List<Account> lstAcc = new List<Account>(); 
        
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 5;
        insert account;
        
        Test.startTest();
        account.Send_Mail_To_AuditTeam__c = true;
        update account;
        Test.stopTest(); 
    }
}