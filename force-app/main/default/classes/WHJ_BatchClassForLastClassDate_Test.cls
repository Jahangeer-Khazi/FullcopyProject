@isTest
public class WHJ_BatchClassForLastClassDate_Test {
 static testMethod void testBatchClass()
   {
	   Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
       Account acc = new Account();
       acc.LastName = 'Test Account for Batch';
       acc.Credit__c=15;
       acc.Last_Class_Date__c=System.today() - 20;
       acc.RecordtypeId= stExam;
       acc.IsOpen__c = false;
       insert acc;
       
       acc.Last_Class_Date__c=System.today() - 15;
       update acc;
     
       Test.StartTest();
       WHJ_BatchClassForLastClassDate obj = new WHJ_BatchClassForLastClassDate();
	   DataBase.executeBatch(obj);
       Test.StopTest();
        
    }
}