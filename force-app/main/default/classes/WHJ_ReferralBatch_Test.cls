@isTest
public class WHJ_ReferralBatch_Test {
    
    static testMethod void ReferralsINDIA()
    { 
        Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'abc@gmail.com' , BillingCountry = 'India');
        insert account;
        Datetime yesterday1 = Datetime.now().addDays(-19);
        Test.setCreatedDate(account.Id,yesterday1);
        
        Opportunity oppo = new Opportunity(Name = 'Test' , StageName = 'Trial Class Complete', CloseDate = Date.newInstance(1960, 2, 17));
        
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='abc@gmail.com'];
        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity where (IsWon = false  OR IsClosed = false ) And AccountId =: lstAccount[0].Id ];
        
        
        if(!lstAccount.isEmpty()){
            Booking__c booking = new Booking__c();
            booking.Account__c = account.Id;
            booking.Name = 'B-11';
            booking.Class_Number__c = 2.2;
            booking.Is_Trial__c = false;
            booking.Teacher_Name__c = 'test';
            booking.Teacher_Comments__c = 'test';
            booking.Rating__c = '5';
            booking.Actual_Class_Start_Time__c = Time.newInstance(9, 30, 0, 0);
            booking.Booking_Date__c =Date.newInstance(2019, 02, 25);
            insert booking; 
            
            
            
            Datetime yesterday = Datetime.now().addDays(-19);
            Test.setCreatedDate(booking.Id,yesterday);
            
            
            Test.StartTest();
            WHJ_ReferralBatchINDIA obj = new WHJ_ReferralBatchINDIA();
            DataBase.executeBatch(obj);
            String sch = '0  00 1 3 * ?';
            system.schedule('Test', sch, obj);       
            Test.StopTest();
        }
        
        
    }
    
    
     
    static testMethod void ReferralsUSA()
    { 
        Account account1 = new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail = 'abc1@gmail.com' , BillingCountry = 'USA');
        insert account1;
        Datetime yesterday1 = Datetime.now().addDays(-19);
        Test.setCreatedDate(account1.Id,yesterday1);
        
        Opportunity oppo = new Opportunity(Name = 'Test' , StageName = 'Trial Class Complete', CloseDate = Date.newInstance(1960, 2, 17));
        
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='abc1@gmail.com'];
        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity where (IsWon = false  OR IsClosed = false ) And AccountId =: lstAccount[0].Id ];
        
        
        if(!lstAccount.isEmpty()){
            Booking__c booking = new Booking__c();
            booking.Account__c = account1.Id;
            booking.Name = 'B-111';
            booking.Class_Number__c = 2.2;
            booking.Is_Trial__c = false;
            booking.Teacher_Name__c = 'test';
            booking.Teacher_Comments__c = 'test';
            booking.Rating__c = '5';
            booking.Actual_Class_Start_Time__c = Time.newInstance(9, 30, 0, 0);
            booking.Booking_Date__c =Date.newInstance(2019, 02, 25);
            insert booking; 
            
            
            
            Datetime yesterday = Datetime.now().addDays(-19);
            Test.setCreatedDate(booking.Id,yesterday);
            
            
            Test.StartTest();
            WHJ_ReferralBatchUS obj = new WHJ_ReferralBatchUS();
            DataBase.executeBatch(obj);
            String sch = '0  00 1 3 * ?';
            system.schedule('Test', sch, obj);       
            Test.StopTest();
        }
        
        
    }
    
}