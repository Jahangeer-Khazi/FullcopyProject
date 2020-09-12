/*White Hat Junior FeedBack Batch Test Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 25/09/2019
 *Purpose: This Apex class is to test FeedBack Batch Class
 */ 



@isTest
public class WHJ_FeedbackBatchClass_Test {
    static testMethod void testBatchClass()
   {
/*		Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User usr = new User(Alias = 'standt', Email='standarduser@tt.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = pro.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@tt.com');
*/
       Date d = System.today().addDays(-30);
	   Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		System.debug('stExam::'+stExam);
        Account acc = new Account();
            acc.LastName = 'Test Account';
            acc.Credit__c=15;
            acc.Last_Teacher_Feedback_Date__c=System.today().addDays(-30);
            acc.RecordtypeId= stExam;
            insert acc;
       		System.debug('acc::'+acc);
       List<Account> lstAcc = [SELECT ID,LastName , Last_Teacher_Feedback_Date__c , Credit__c, OwnerId FROM Account 
                               WHERE Last_Teacher_Feedback_Date__c =: d AND Credit__c >= 8 ];     
       
       if(!lstAcc.isEmpty()){
           Test.StartTest();
       WHJ_FeedbackBatchClass obj = new WHJ_FeedbackBatchClass();
            DataBase.executeBatch(obj);
       }
        
    }
}