@isTest
public class WHJ_ErrorLogHandler_Test {
   @isTest
   static void testData() {
         Exception ex = null;
   		  Error_Log__c e = new Error_Log__c();
      	  e.Component_Name__c = 'test';
          e.Component_Type__c = 'Apex class';
          e.Error_Code__c = 400;
          e.Error_Message__c = 'Invalid date';
          e.Record_Reference__c = 'test';
          e.Response_Request__c = 'test';
      insert e;
       WHJ_ErrorLogHandler.log('test', 'Apex class', 'Invalid date', 400, 'test','test');
   }	
}