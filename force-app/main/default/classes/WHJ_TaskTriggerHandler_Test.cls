/*White Hat Junior Task Trigger Handler Test Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 01/06/2020
 *Purpose: This Test class is to test WHJ_TaskTriggerHandler.
 */ 
@isTest
public class WHJ_TaskTriggerHandler_Test {
	@isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        list<User> u = [select id , name from User ];
        Account acc = new Account();
        acc.LastName = 'test';
        acc.PersonMobilePhone = '+919898989898';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.MobileNumber__c = '+917878787878'; 
        insert oppo;
        
        Contact c = new Contact();
        c.LastName = 'test Contact';
        c.Type__c = 'Teacher';
        c.Email = 'gaurigauri@abc.com';
        insert c;
       
        test.startTest();
        Booking__c b = new Booking__c();
        b.Name = 'Book-1';
       	b.Account__c =acc.Id;
        b.Opportunity__c = oppo.Id;
        b.Is_Trial__c = true;
        b.Booking_Date__c = System.today();
        b.Actual_Class_Start_Time__c = time.newInstance(1, 1, 1, 1);
        insert b;
        test.stopTest();
        
        Task t = new Task();
        t.OwnerId = u[0].Id;
        t.WhatId = oppo.Id;
        t.Subject = 'test';
        t.Type = 'Call';
        t.Description = 'test';
        t.Status = 'Open';
        insert t;
        
        WHJ_TaskTriggerHandler.onAfterInsert(null);
    }
}