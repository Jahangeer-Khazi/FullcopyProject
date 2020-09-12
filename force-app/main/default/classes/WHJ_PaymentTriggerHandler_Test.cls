@IsTest
public class WHJ_PaymentTriggerHandler_Test {
	
    static testMethod void onAfterInsert()
   {
	   Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
       Account acc = new Account();
       acc.LastName = 'Test Account for Batch';
       acc.Credit__c=15;
       acc.Last_Teacher_Feedback_Date__c=System.today();
       acc.RecordtypeId= stExam;
       acc.BillingCountry = 'India';
       insert acc;
       
       Opportunity oppo = new Opportunity();
       oppo.AccountId = acc.Id;
       oppo.Name = 'Test Opty';
       oppo.StageName = 'WIP';
       oppo.CloseDate = system.today();
       oppo.CurrencyIsoCode = 'INR';
       oppo.Package_Sold__c = 'Expert';
       insert oppo;
       
       Payment__c pay = new Payment__c();
       pay.Name = 'pay-01';
       pay.Account__c = acc.Id;
       pay.Opportunity__c = oppo.Id;
       pay.Amount__c = 43434;
       pay.Credits__c = 4;
       pay.Package_Name__c = 'Expert';
       insert pay;
     
    }
}