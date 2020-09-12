/*White Hat Junior Booking API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 16/09/2019
 *Purpose: This Test class is to test Data for WHJ_Booking_API class.
 */ 


@isTest
global class WHJ_Booking_API_Test {

    @testSetup  static void setupTestData()
        
    {
       Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'abc@gmail.com');
        insert account;
        System.debug(account);
    
       Opportunity oppo = new Opportunity(Name = 'Test' , StageName = 'Trial Class Complete', CloseDate = Date.newInstance(1960, 2, 17));
    //    insert oppo;        
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='abc@gmail.com'];
        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity where (IsWon = false  OR IsClosed = false ) And AccountId =: lstAccount[0].Id ];
        
        
         if(!lstAccount.isEmpty()){
         Booking__c booking = new Booking__c();
            booking.Account__c = account.Id;
            booking.Name = 'B-11';
            booking.Class_Number__c = 2.2;
            booking.Is_Trial__c = true;
            booking.Teacher_Name__c = 'test';
            booking.Teacher_Comments__c = 'test';
            booking.Rating__c = '5';
          	booking.Actual_Class_Start_Time__c = Time.newInstance(9, 30, 0, 0);
            booking.Booking_Date__c =Date.newInstance(2019, 02, 25);
          insert booking; 
    System.debug(booking);
        }     
        
    }
        
   
 static testmethod void createbooking() {
    String actual = '{"email": "abc@gmail.com","bookingId": "B-11","classNumber": "2","isTrial": true,"teacherName": "test","teacherComment":"test","rating": "5","classdate": "2018-07-25","scheduledClassStartTime": "10:00","actualClassStartTime": "10:30"}';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Booking_API.createBooking();
    }

     static testmethod void createbookingCatch() {
    String actual = '{"email": "","bookingId": "B-11","classNumber": "2","isTrial": true,"teacherName": "test","teacherComment":"test","rating": "5","classdate": "2018-07-25","scheduledClassStartTime": "10:00","actualClassStartTime": "10:30"}';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Booking_API.createBooking();
    }

    
}