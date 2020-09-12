/*White Hat Junior Get Opportunity Mobile Test Class
*Created By: RSURI
*Release No: 1
*Created Date: 24/09/2019
*Purpose: This Test class is to test Data for WHJ_GetOpportunityMobile class.
*/ 

@isTest
public class WHJ_GetOpportunityMobile_Test {

    Private static testMethod void GetMobile() {
        
        Test.startTest();
        Account acc = new Account();
        acc.LastName ='Test Get Mobile Account';
        acc.PersonMobilePhone ='+919874521452';
        insert acc;
        
        Opportunity oppt = new Opportunity();
        oppt.Name ='Test Get Mobile';
        oppt.AccountID = acc.Id;
        oppt.StageName = 'CLASS COMPLETE';
        oppt.CloseDate = System.today();
        oppt.MobileNumber__c = '+919874521452';
        insert oppt;
        
        String OptyId = String.valueOf(oppt.Id);
        System.debug('OptyId: ' + OptyId);
        String Mobile = WHJ_GetOpportunityMobile.WHJ_GetMobile(OptyId);
        
        System.assertEquals('+919874521452', Mobile);
	
        Test.stopTest();
    }
    
    
}