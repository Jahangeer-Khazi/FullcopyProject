@isTest
public class WHJ_OneTimeRenewalOptyUS_Test {
    
    static testmethod void test1() 
    {
        Account acc = new Account();
        acc.FirstName = 'FirstName';
        acc.LastName = 'LastName';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 7 ;
        acc.BillingCountry = 'USA';
        insert acc;
        
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='test@gmail.com'];
        
        User usr = new User();
        
        usr.LastName = 'testuser';
        usr.Email= 'testuserbatchavailable@gmail.com';
        usr.Alias = 'testuser';
        usr.Username = 'testuserbatchavailable@gmail.com';
        usr.CommunityNickname ='test';
        usr.TimeZoneSidKey = 'Asia/Kolkata';
        usr.LocaleSidKey= 'en_IN';
        usr.EmailEncodingKey= 'ISO-8859-1';
        usr.ProfileId= '00e2v000003UNxNAAW';
        usr.LanguageLocaleKey= 'en_US';
        usr.Shifts__c = 'US Only';
        usr.Status__c = 'Available';
        usr.IsActive = true;
        
        insert usr;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = acc.LastName; 
        oppo.StageName = 'CLASS COMPLETE';
        oppo.CloseDate = Date.newInstance(2020, 2, 27);
        oppo.OwnerId = usr.Id;
        
        insert oppo;
        
        
        
        if(!lstAccount.isEmpty()){
            List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity ORDER BY CreatedDate DESC NULLS FIRST limit 1 ];
            if(!lstOpportunity.isEmpty()){
                
                Payment__c payment = new Payment__c();
                payment.Account__c =   acc.Id;
                payment.Name = 'test';
                payment.Payment_Type__c = 'Link';
                payment.Amount__c = 3.3;
                payment.Credits__c = 3.5;
                payment.Discount__c = 2.2;
                payment.Payment_Gateway_Name__c = 'test';
                payment.EMI__c = true;
                payment.Opportunity__c = lstOpportunity[0].Id;
                payment.Link_By__c = 'test@gmail.com';     
                insert payment; 
                
            }
        }
        
        
        
        Test.StartTest();
        WHJ_OneTimeRenewalOptyUS obj = new WHJ_OneTimeRenewalOptyUS();
        DataBase.executeBatch(obj);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, obj);       
        Test.StopTest();
    }
    
    static testmethod void test2() 
    {
        Account acc = new Account();
        acc.FirstName = 'FirstName1';
        acc.LastName = 'LastName1';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test1@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 4 ;
        acc.BillingCountry = 'USA';
        insert acc;
        
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='test1@gmail.com'];
        
        User usr = new User();
        
        usr.LastName = 'testuser';
        usr.Email= 'testuserbatchavailable@gmail.com';
        usr.Alias = 'testuser';
        usr.Username = 'testuserbatchavailable@gmail.com';
        usr.CommunityNickname ='test';
        usr.TimeZoneSidKey = 'Asia/Kolkata';
        usr.LocaleSidKey= 'en_IN';
        usr.EmailEncodingKey= 'ISO-8859-1';
        usr.ProfileId= '00e2v000003UNxNAAW';
        usr.LanguageLocaleKey= 'en_US';
        usr.Shifts__c = 'US Only';
        usr.Status__c = 'Available';
        usr.IsActive = true;
        insert usr;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = acc.LastName; 
        oppo.StageName = 'CLASS COMPLETE';
        oppo.CloseDate = Date.newInstance(2020, 2, 27);
        oppo.OwnerId = usr.Id;
        
        insert oppo;
        
        
        
        if(!lstAccount.isEmpty()){
            List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity ORDER BY CreatedDate DESC NULLS FIRST limit 1 ];
            if(!lstOpportunity.isEmpty()){
                
                Payment__c payment = new Payment__c();
                payment.Account__c =   acc.Id;
                payment.Name = 'test';
                payment.Payment_Type__c = 'Link';
                payment.Amount__c = 3.3;
                payment.Credits__c = 3.5;
                payment.Discount__c = 2.2;
                payment.Payment_Gateway_Name__c = 'test';
                payment.EMI__c = true;
                payment.Opportunity__c = lstOpportunity[0].Id;
                payment.Link_By__c = 'test@gmail.com';     
                insert payment; 
                
            }
        }
        
        
        
        Test.StartTest();
        WHJ_OneTimeRenewalOptyUS obj = new WHJ_OneTimeRenewalOptyUS();
        DataBase.executeBatch(obj);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, obj);       
        Test.StopTest();
        
        
    }
    
    
    
    
    
    
    
    
    
    static testmethod void test3() 
    {
        Account acc = new Account();
        acc.FirstName = 'FirstName3';
        acc.LastName = 'LastName3';
        acc.Status__c ='Active';
        acc.PersonEmail = 'test3@gmail.com';
        acc.Activation_Date__c = Date.newInstance(2020, 02, 25);
        acc.Credit__c = 4 ;
        acc.BillingCountry = 'USA';
        insert acc;
        
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='test3@gmail.com'];
        
        User usr = new User();
        
        usr.LastName = 'testuser';
        usr.Email= 'testuserbatchavailable@gmail.com';
        usr.Alias = 'testuser';
        usr.Username = 'testuserbatchavailable@gmail.com';
        usr.CommunityNickname ='test';
        usr.TimeZoneSidKey = 'Asia/Kolkata';
        usr.LocaleSidKey= 'en_IN';
        usr.EmailEncodingKey= 'ISO-8859-1';
        usr.ProfileId= '00e2v000003UNxNAAW';
        usr.LanguageLocaleKey= 'en_US';
        usr.Shifts__c = 'US Only';
        usr.Status__c = 'Available';
        usr.IsActive = true;
        insert usr;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = acc.LastName; 
        oppo.StageName = 'CLASS COMPLETE';
        oppo.CloseDate = Date.newInstance(2020, 2, 27);
        oppo.OwnerId = usr.Id;
        
        insert oppo;
        
        
        
        if(!lstAccount.isEmpty()){
            List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity ORDER BY CreatedDate DESC NULLS FIRST limit 1 ];
            if(!lstOpportunity.isEmpty()){
                
                Payment__c payment = new Payment__c();
                payment.Account__c =   acc.Id;
                payment.Name = 'test';
                payment.Payment_Type__c = 'Link';
                payment.Amount__c = 3.3;
                payment.Credits__c = 3.5;
                payment.Discount__c = 2.2;
                payment.Payment_Gateway_Name__c = 'test';
                payment.Package_Name__c = 'Standard';
                payment.EMI__c = true;
                payment.Opportunity__c = lstOpportunity[0].Id;
                payment.Link_By__c = 'test@gmail.com';     
                insert payment; 
                
            }
        }
        
        
        
        Test.StartTest();
        WHJ_OneTimeRenewalOptyUS obj = new WHJ_OneTimeRenewalOptyUS();
        DataBase.executeBatch(obj);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, obj);       
        Test.StopTest();
        
        
    }
    
    
    
    
    
    
    
 
    
    
    
    
    
}