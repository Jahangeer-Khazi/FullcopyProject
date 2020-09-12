/*White Hat Junior Update Opportunity MobileField TEST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 17/09/2019
*Purpose: This Test class is to test Data for WHJ_UpdateOpportunityMobileField trigger.
*/ 


@isTest
public class WHJ_UpdateOpportunityMobileField_Test {
    
    Private static testMethod void UpdateMobile	() {
        
        Test.startTest();
        Account acc = new Account();
        acc.LastName ='Test Account';
        acc.PersonMobilePhone = '+919874521452';
        acc.Status__c = 'Active';
        insert acc;
        
        Opportunity oppt = new Opportunity();
        oppt.Name ='New OPPO';
        oppt.AccountID = acc.Id;
        oppt.StageName = 'CLASS COMPLETE';
        oppt.CloseDate = System.today();
        oppt.MobileNumber__c = '+919874521452';
        insert oppt;
        
        acc.LastName ='Test Account_WHJ';
        acc.PersonMobilePhone = '+919874521410';
        acc.Status__c = 'Active';
        update acc;
        
        acc=[SELECT Id,LastName,PersonMobilePhone,Status__c FROM account WHERE Id=:acc.Id];
        System.assertEquals(acc.PersonMobilePhone,'+919874521410');  
        
        List<Opportunity> lstOpp = [select id,StageName,MobileNumber__c from Opportunity where id =:oppt.id];
        
        System.assertEquals('+919874521410', lstOpp[0].MobileNumber__c);
	
        Test.stopTest();
    }
}