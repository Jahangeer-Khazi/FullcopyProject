@isTest(SeeAllData=true)
public class WHJ_UserTriggerHandler_Test {
    @isTest
    static void onAfterUpdateForIf() {  
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'Sales Manager' LIMIT 1];
        User usr = new User(LastName = 'flagUser',
                            FirstName='test',
                            Alias = 'flag',
                            Email = 'flag.test@sfdc.com',
                            Username = 'flag.test@sfdc.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            Department__c = 'India Sales');
        insert usr;
        
        User usr2 = new User(LastName = 'flagUser2',
                             FirstName='test2',
                             Alias = 'flag2',
                             Email = 'flag2.test@sfdc.com',
                             Username = 'flag2.test@sfdc.com',
                             ProfileId = profileId.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US',
                             Department__c = 'India Renewals');
        insert usr2;
        System.debug('usr2::'+usr2);
        
        User usr3 = new User();
        usr3.LastName = 'flagUser3';
        usr3.FirstName='test3';
        usr3.Alias = 'flag3';
        usr3.Email = 'flag3.test@sfdc.com';
        usr3.Username = 'flag3.test@sfdc.com';
        usr3.ProfileId = profileId1.id;
        usr3.TimeZoneSidKey = 'GMT';
        usr3.LanguageLocaleKey = 'en_US';
        usr3.EmailEncodingKey = 'UTF-8';
        usr3.LocaleSidKey = 'en_US';
        usr3.ManagerId = usr.id;
        insert usr3;
        String mgrId = usr3.ManagerId;
        
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'India';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = System.today();
        account.Status__c = 'Active';
        account.Credit__c = 2;
        insert account;  
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WIP';
        oppo.CloseDate = System.today() ;
        oppo.Type = 'New Student';
        insert oppo; 
        oppo.OwnerId = usr3.Id;
        update oppo;

        usr3.ManagerId = usr2.id;
        update usr3;
    }
    
}