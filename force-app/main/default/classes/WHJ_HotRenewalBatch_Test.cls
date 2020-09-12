@isTest
public class WHJ_HotRenewalBatch_Test {
	static testMethod void HotRenewals()
    {
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Test Account for Batch';
        acc.Credit__c=2;
        acc.Last_Class_Date__c=System.today() - 20;
        acc.RecordtypeId= stExam;
        acc.IsOpen__c = false;
        acc.Package_Type__c = 'Basic';
        acc.BillingCountry = 'India';
        
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Test';
        oppo.AccountId = acc.Id;
        oppo.CloseDate = System.today();
        oppo.StageName = 'WIP';
        oppo.CurrencyIsoCode = 'INR';
        oppo.Package_Sold__c = 'Basic';
        oppo.Hot_Renewal__c = false;
        oppo.Type = 'Renewal';
        insert oppo;   
        Datetime yesterday = Datetime.now().addDays(-19);
        Test.setCreatedDate(oppo.Id,yesterday);
        
        
        Test.StartTest();
        WHJ_HotRenewalBatch obj = new WHJ_HotRenewalBatch();
        DataBase.executeBatch(obj);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, obj);       
        Test.StopTest();
        
    }

}