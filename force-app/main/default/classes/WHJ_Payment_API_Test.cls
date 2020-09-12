/*White Hat Junior Payment API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 16/09/2019
 *Purpose: This Test class is to test Data for WHJ_Payment_API class.
 */ 


@isTest
global class WHJ_Payment_API_Test {

     @isTest
    static void setupTestData(){
       
      Account acc = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'harsh@gmail.com',Status__c = 'Active');
       insert acc;
      
        Opportunity oppo = new Opportunity();
            oppo.AccountId = acc.Id;
			oppo.Name = acc.LastName; 
            oppo.StageName = 'CLASS COMPLETE';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type='New Student';
         //   oppo.Subscription_Created__c	= false;
        insert oppo;
		System.debug('oppo::'+oppo);
  		List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='harsh@gmail.com'];
    	System.debug('lstAccount::'+lstAccount);	
//System.debug('lstOpportunity::'+lstOpportunity);	
            
         if(!lstAccount.isEmpty()){
        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity ORDER BY CreatedDate DESC NULLS FIRST limit 1 ];
             if(!lstOpportunity.isEmpty()){
                 
          Payment__c payment = new Payment__c();
            payment.Account__c =   acc.Id;
            payment.Name = 'test';
            payment.Payment_Type__c = 'Link';
            payment.Amount__c = 3.3;
            payment.Credits__c = 3.5;
            payment.Discount__c = 2.2;
            payment.Payment_Gateway_Name__c = 'test';
            payment.Package_Name__c = 'Basic';
            payment.EMI__c = true;
            payment.Opportunity__c = lstOpportunity[0].Id;
            payment.Link_By__c = 'test@gmail.com';     
          insert payment; 
           
        System.debug(payment);       
             }
        }    
    }
  @isTest
    static void setupTestData3(){
       
      Account acc = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'harsh123@gmail.com',Status__c = 'Active');
       insert acc;
      
        Opportunity oppo = new Opportunity();
            oppo.AccountId = acc.Id;
			oppo.Name = acc.LastName; 
            oppo.StageName = 'CLASS COMPLETE';
            oppo.CloseDate = Date.newInstance(1960, 2, 17);
            oppo.Type='Referral';
         //   oppo.Subscription_Created__c	= false;
        insert oppo;
		
            
             }
            
    
 
     @isTest
    static void setupTestDataElse(){
       
      Account acc = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'rohit@gmail.com',Status__c = 'Active');
       insert acc;
    
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='rohit@gmail.com'];
    	System.debug('lstAccount::'+lstAccount);	
//System.debug('lstOpportunity::'+lstOpportunity);	
            
         if(!lstAccount.isEmpty()){
        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity  where AccountId =: lstAccount[0].Id ];
             if(lstOpportunity.isEmpty()){
  System.debug('lstOpportunity::'+lstOpportunity);	
        
            /*     Opportunity oppo = new Opportunity();
            	oppo.Name = lstAccount[0].Name;
            	oppo.AccountId = lstAccount[0].Id;
            	oppo.StageName = 'WON - PAYMENT RECEIVED';
            	oppo.CloseDate = System.today() + 7;
            	insert oppo;
                 System.debug('oppo::'+oppo);
            Payment__c payment = new Payment__c();
            payment.Account__c =   acc.Id;
            payment.Name = 'test';
            payment.Payment_Type__c = 'Link';
            payment.Amount__c = 3.3;
            payment.Credits__c = 3.5;
            payment.Discount__c = 2.2;
            payment.Payment_Gateway_Name__c = 'test';
            payment.Package_Name__c = 'Basic';
            payment.EMI__c = true;
            payment.Opportunity__c =oppo.Id;
          insert payment; 
                 System.debug('payment::'+payment);*/
             }   
          
        }    
        
    }
 
    
    
 static testmethod void createpayment() {
          setupTestData();
     	  setupTestDataElse();
   String actual = '{ "email": "harsh@gmail.com","paymentId": "123", "type": "Link","amount": "3.3","currrency": "123","credits":"3.5","discount": "2.3","paymentgatewayname": "test","paymentdate": "2018-07-25","packagename": "Basic","emi": true,"leadby":"test@gmail.com"}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    test.startTest();
     WHJ_Payment_API.createPayment();
     test.stopTest();
    }
   
    /*static testmethod void createpayment1() {
          setupTestData();
     	  setupTestDataElse();
   String actual = '{ "email": "harsh123456789@gmail.com","paymentId": "123", "type": "Link","amount": "3.3","currrency": "123","credits":"3.5","discount": "2.3","paymentgatewayname": "test","paymentdate": "2018-07-25","packagename": "Basic","emi": true,"leadby":"test@gmail.com"}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Payment_API.createPayment();
    }
*/    
    
    
static testmethod void createpaymentCatch() {
          setupTestData();
        	  setupTestDataElse();

    String actual = '{ "email": "","paymentId": "123", "type": "Link","amount": "3.3","currrency": "123","credits":"3.5","discount": "2.3","paymentgatewayname": "test","paymentdate": "2018-07-25","packagename": "Basic","emi": true,"leadby":"test@gmail.com"}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Payment_API.createPayment();
    }   

    /*static testmethod void createaccElse() {
          setupTestData();
        	  setupTestDataElse();

    String actual = '{ "email": "rohit@gmail.com","paymentId": "123", "type": "Link","amount": "3.3","currrency": "123","credits":"3.5","discount": "2.3","paymentgatewayname": "test","paymentdate": "2018-07-25","packagename": "Basic","emi": true,"leadby":"test@gmail.com"}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Payment_API.createPayment();
    } */  

    /*
static testmethod void accElse() {
          setupTestData();
        	  setupTestDataElse();

    String actual = '{ "email": "abc@gmail.com","paymentId": "123", "type": "Link","amount": "3.3","currrency": "123","credits":"3.5","discount": "2.3","paymentgatewayname": "test","paymentdate": "2018-07-25","packagename": "Basic","emi": true,"leadby":"test@gmail.com"}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Payment_API.createPayment();
    }       */
    
    
    static testmethod void accElse1() {
   setupTestData3();
        
    String actual = '{ "email": "harsh123@gmail.com","paymentId": "123", "type": "Link","amount": "3.3","currrency": "123","credits":"3.5","discount": "2.3","paymentgatewayname": "test","paymentdate": "2018-07-25","packagename": "Basic","emi": true,"leadby":"test@gmail.com"}';
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Payment_API.createPayment();
    }       
    
}