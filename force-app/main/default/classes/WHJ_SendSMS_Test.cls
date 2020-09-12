@isTest
public class WHJ_SendSMS_Test {
    
    @isTest  
    static void testData(){
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
        oppo.CloseDate = Date.newInstance(2020, 2, 17);
        oppo.MobileNumber__c = '+917878787878'; 
        insert oppo;
        
        Task t = new Task();
        t.OwnerId = u[0].Id;
        t.WhatId = acc.Id;
        t.Subject = 'test';
        t.Type = 'SMS';
        t.Description = 'test';
        t.Status = 'Open';
        
        insert t;
    }
    @isTest  
    static void testDataOppo(){
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
        oppo.CloseDate = Date.newInstance(2020, 2, 17);
        oppo.MobileNumber__c = '+917878787878'; 
        insert oppo;
        
        Task t = new Task();
        t.OwnerId = u[0].Id;
        t.WhatId = oppo.Id;
        t.Subject = 'test';
        t.Type = 'SMS';
        t.Description = 'test';
        t.Status = 'Open';
        
        insert t;
        
        
        
        
    }
}