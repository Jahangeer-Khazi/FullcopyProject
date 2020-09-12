@isTest
private class WHJ_SMSConnect_Test {
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
        
        
        Task t = new Task();
        t.OwnerId = u[0].Id;
        t.WhatId = acc.Id;
        t.Subject = 'test';
        t.Type = 'SMS';
        t.Description = 'test';
        t.Status = 'Open';
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        //String tskId = '00T6D0000024LYcUAM';
        String mobNo ='+919898989898';
        String message='test' ;
        String authKey= '281845APXW8qHjuRp95d0a737d';
        String sender = 'WHJRCO';
        String tskId = String.valueOf(t.Id);
        
        
        
        //   WHJ_SMSConnect service = new WHJ_SMSConnect();
        WHJ_SMSConnect.sendSMS(tskId, mobNo, message, authKey, sender);
        
       
    }
}