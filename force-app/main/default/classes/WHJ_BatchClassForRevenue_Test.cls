@isTest
public class WHJ_BatchClassForRevenue_Test {
    static testMethod void testBatchClass()
    {	 
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test Account for Batch';
        acc.Credit__c=15;
        acc.Last_Teacher_Feedback_Date__c=System.today();
        acc.RecordtypeId= stExam;
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'Test Opty';
        oppo.StageName = 'WIP';
        oppo.CloseDate = system.today();
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Basic';
        insert oppo;
        
        
        Payment__c pay = new Payment__c();
        pay.Name = 'pay-01';
        pay.Account__c = acc.Id;
        pay.Opportunity__c = oppo.Id;
        pay.Amount__c = 43434;
        pay.Credits__c = 4;
        insert pay;
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(pay.Id,yesterday);
        
        Test.StartTest();
        WHJ_BatchClassForRevenue obj = new WHJ_BatchClassForRevenue();
        DataBase.executeBatch(obj);
        
        
        WHJ_BatchClassForTLRevenue obj1 = new WHJ_BatchClassForTLRevenue();
        DataBase.executeBatch(obj1);
        Test.StopTest();
        
    }
    
}