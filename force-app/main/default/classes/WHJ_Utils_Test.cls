@isTest
public class WHJ_Utils_Test {
	 @isTest
     static void testUtil() {      
        WHJ_Utils.getSalesRegion('India');
        WHJ_Utils.getDefaultManagerId('India', 'New');
        WHJ_Utils.getSalesRefEmail('rajeev.dubey@whitehatjr.com'); 
         test.startTest();
         //WHJ_Utils.addDelay();
         WHJ_Utils.generateRandomNumber(5);
         test.stopTest();
     }
}