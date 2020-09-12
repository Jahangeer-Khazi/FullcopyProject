/*White Hat Junior Opportunity Handler Test Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 01/06/2020
 *Purpose: This Test class is to test WHJ_OpportunityHandlerController.
 */ 
@isTest
public class WHJ_OpportunityHandler_Test {
    static testMethod void testUnitif(){
        Account acc = new Account();
        acc.LastName = 'test';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'Renewal';
        insert oppo;
        
    }
    
    static testMethod void onAfterUpdateCallout(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc = new Account();
        acc.LastName = 'test';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'Renewal';
        insert oppo;
        
        
        Booking__c b = new Booking__c();
        b.Name = 'Book-1';
        b.Account__c =acc.Id;
        b.Is_Trial__c = true;
        b.Opportunity__c = oppo.Id;
        b.Booking_Date__c = System.today();
        b.Actual_Class_Start_Time__c = time.newInstance(1, 1, 1, 1);
        insert b;
        System.debug('b::'+b);
        
        oppo.StageName = 'WIP';
        update oppo;
        
        WHJ_OpportunityHandlerController.onAfterUpdateCallout(null);
    }
    
    static testMethod void updateReferralWonCounTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc = new Account();
        acc.LastName = 'test';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WIP';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Referral_Customer__c = 'test@gmail.com';
        oppo.Referred_by_Customer__c = acc.Id;
        oppo.Type = 'Renewal';
        insert oppo;
        
        
        Booking__c b = new Booking__c();
        b.Name = 'Book-1';
        b.Account__c =acc.Id;
        b.Is_Trial__c = true;
        b.Opportunity__c = oppo.Id;
        b.Booking_Date__c = System.today();
        b.Actual_Class_Start_Time__c = time.newInstance(1, 1, 1, 1);
        insert b;
        System.debug('b::'+b);
        
        oppo.StageName = 'WON-PART PAYMENT';
        update oppo;
		WHJ_OpportunityHandlerController.populateAccountIdLookup(null);        
        WHJ_OpportunityHandlerController.UpdateReferralWonCount(null,null);
        WHJ_OpportunityHandlerController.onAfterInsertForSalesken(null);
        WHJ_OpportunityHandlerController.SendDataToSalesken(null,null,null);
    }
}