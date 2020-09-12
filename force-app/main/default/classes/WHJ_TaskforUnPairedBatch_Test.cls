@isTest
public class WHJ_TaskforUnPairedBatch_Test {
    static testmethod void test() 
    {
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'USA';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.Activation_Date__c = Date.newInstance(2020, 2, 17);
        account.Status__c = 'Active';
        account.Credit__c = 22;
        account.Subscription_Flag__c = false;
        account.Batch_Id__c = 'A';
        Date Dat1 = date.today().adddays(3);
        account.Batch_Start_Date__c =Dat1;
        insert account; 
        Test.startTest();
        WHJ_TaskforUnPairedBatch be1 = new WHJ_TaskforUnPairedBatch();
        database.executeBatch(be1);
        Test.stopTest();   
    }  
}