/*White Hat Junior Update Opportunity MobileField TEST Class 
*Created By: GDESHPANDE
*Release No: 1
*Created Date: 19/09/2019
*Purpose: This Test class is to test Data for Whj_userpicklist trigger.
*/ 

@isTest
public class WHJ_userpicklist_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    test.stopTest();
  }
  static testMethod void test_userupdate_UseCase1(){
    List<User> user_Obj  =  [SELECT Id,Status__c from User];
    System.assertEquals(true,user_Obj.size()>0);
    Whj_userpicklist obj01 = new Whj_userpicklist();
    Whj_userpicklist.userupdate('Available');
  }
  static testMethod void test_userreload_UseCase1(){
    List<User> user_Obj  =  [SELECT Id,Status__c from User];
    System.assertEquals(true,user_Obj.size()>0);
    Whj_userpicklist obj01 = new Whj_userpicklist();
    Whj_userpicklist.userreload();
  }
}