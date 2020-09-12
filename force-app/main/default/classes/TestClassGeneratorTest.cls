@isTest
public class TestClassGeneratorTest { 
    
    @testSetup static void setup() {
        
        
    }
    
    @isTest static void TestGetMachineryTypes()
    {
        Test.startTest();
        TestClassGeneratorUtility.getAllRequiredFields('Contact');
        
        TestClassGeneratorUtility.getAllRequiredFields('Map');
        Test.stopTest();
    }
    
    
    @isTest static void getApexClassDetailsTest() {
        
        TestClassGeneratorController.getApexClassDetails(); 
    }
    
    @isTest static void generateTestClassTest() {
        Test.setMock(HttpCalloutMock.class, new TestClassMockResponse());
        TestClassGeneratorController.generateTestClass( 'public class testClassForConv {\npublic static String testApexMethodIntegerPrm(Integer int_input, String str_input,Date date_input,DateTime dateTime_input,List<customObj__c> cstmLst,List<contact> contactLst){\nreturn \'Sample Text\';\n}\n}' ,'testClassForConv' ); 
    }
    
    @isTest static void createTestMethodsTest() {
        TestClassGeneratorController.createTestMethods('{"Methods":[{"IsStatic":true,"AccessModifier":"public","ReturnType":"String","Name":"getLoggedInUserTimeZone","Params":[{"Type":"Integer","Name":"int_input"},{"Type":"String","Name":"str_input"},{"Type":"Boolean","Name":"bool_input"},{"Type":"Double","Name":"dbl_input"},{"Type":"Decimal","Name":"dcml_input"},{"Type":"Time","Name":"tm_input"},{"Type":"DateTime","Name":"dateTime_input"}]},{"IsStatic":true,"AccessModifier":"static","ReturnType":"String","Name":"testApexMethodIntegerPrm","Params":[{"Type":"Integer","Name":"int_input"},{"Type":"String","Name":"str_input"},{"Type":"Date","Name":"date_input"},{"Type":"DateTime","Name":"dateTime_input"},{"Type":"List<customObj__c>","Name":"cstmLst"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<Account>","Name":"getAllAccounts","Params":[{"Type":"String","Name":"searchText"},{"Type":"String","Name":"selectedType"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<CustomSelectOption>","Name":"getGrades","Params":[]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<Lead>","Name":"getAllLead","Params":[{"Type":"String","Name":"searchText"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<User>","Name":"getUsersFromDb","Params":[]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<RESurvey__c>","Name":"getAllSurveys","Params":[]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<Visits__c>","Name":"getEvents","Params":[{"Type":"String","Name":"selectedUser"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"List<Visits__c>","Name":"getEventsForLoggedInUser","Params":[]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"Visits__c","Name":"getNewEvent","Params":[]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"Visits__c<VisitTask__c>","Name":"saveNewEventWithSurveys","Params":[{"Type":"String","Name":"ownerId"},{"Type":"String","Name":"subject"},{"Type":"String","Name":"startDateTime"},{"Type":"String","Name":"endDateTime"},{"Type":"String","Name":"accountId"},{"Type":"String","Name":"selectedSurveys"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"Visits__c","Name":"saveNewEvent","Params":[{"Type":"String","Name":"ownerId"},{"Type":"String","Name":"accountId"},{"Type":"String","Name":"subject"},{"Type":"String","Name":"startDateTime"},{"Type":"String","Name":"endDateTime"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"Visits__c","Name":"updateEvent","Params":[{"Type":"String","Name":"eventId"},{"Type":"String","Name":"startDateTime"},{"Type":"String","Name":"endDateTime"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"Visits__c<VisitTask__c>","Name":"updateOlderEvent","Params":[{"Type":"String","Name":"eventId"},{"Type":"String","Name":"subject"},{"Type":"String","Name":"startDateTime"},{"Type":"String","Name":"endDateTime"},{"Type":"String","Name":"selectedSurveys"},{"Type":"String","Name":"allEvents"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"void","Name":"deleteEvent","Params":[{"Type":"String","Name":"eventId"}]},{"IsStatic":true,"AccessModifier":"public","ReturnType":"void","Name":"unsuppEx","Params":[{"Type":"Contact","Name":"con"},{"Type":"List<Account>","Name":"accLst"},{"Type":"List<String>","Name":"nameLst"},{"Type":"List<Date>","Name":"dateLst"}]}]}',
                                                       '@isTest private class RG_CalendarCtrlTest {',
                                                       'RG_CalendarCtrl');
    //    TestClassGeneratorController.createTestMethods( '{"Methods": [{"IsStatic": true, "AccessModifier": "public", "ReturnType": "String", "Name": "testApexMethodIntegerPrm", "Params": [{"Type": "Integer", "Name": "int_input"}, {"Type": "String", "Name": "str_input"},{"Type": "Date", "Name": "date_input"},{"Type": "DateTime", "Name": "dateTime_input"},{"Type": "List<customObj__c>", "Name": "cstmLst"}]}}]}' ,'@isTest \nprivate class testClassForConvTest { }' ,'testClassForConv' ); 
    }
    
    @isTest static void createPrimitiveTypeListinTestMethodTest() {
        
        TestClassGeneratorController.createPrimitiveTypeListinTestMethod( 'testClass' ,'prmtype' ,'prmname' ,2 ); 
    }
    
    @isTest static void createObjinTestMethodTest() {
        
        TestClassGeneratorController.createObjinTestMethod( 'testClass' ,'Contact' ,'con' ,2 ); 
    }
    
    @isTest static void callParserTest() {
        
         Test.setMock(HttpCalloutMock.class, new TestClassMockResponse());
        TestClassGeneratorController.callParser( 'testClassForConv' ,'public class testClassForConv {\npublic static String testApexMethodIntegerPrm(Integer int_input, String str_input,Date date_input,DateTime dateTime_input,List<customObj__c> cstmLst){\nreturn \'Sample Text\';\n}\n}' ); 
    }
    
    @isTest static void ApexMethodTest() {
        
        TestClassGeneratorController.ApexMethod ap = new   TestClassGeneratorController.ApexMethod('asdas','asdasd','asdasdasd',true,new List<TestClassGeneratorController.Param>());
    }   
}