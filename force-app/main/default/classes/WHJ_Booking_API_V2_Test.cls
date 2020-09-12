/*White Hat Junior Booking API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 07/11/2019
 *Purpose: This Test class is to test Data for WHJ_Booking_API_V2 class.
 */ 


@isTest
global class WHJ_Booking_API_V2_Test {
	@testSetup  static void setupTestData()
        
    {
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

       Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'abc@gmail.com');
        insert account;
        System.debug(account);
    
       Opportunity oppo = new Opportunity(Name = 'Test' , StageName = 'Trial Class Complete', CloseDate = Date.newInstance(1960, 2, 17));
    //    insert oppo;        
        
         Contact c = new Contact();
        c.LastName = 'test Contact';
        c.Type__c = 'Teacher';
        c.Email = 'gaurigauri@abc.com';
        insert c;
        
        Booking__c b = new Booking__c();
        b.Name = 'Book-1';
       	b.Account__c =account.Id;
        insert b;
        
       
        
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail ='abc@gmail.com'];
        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity where (IsWon = false  OR IsClosed = false ) And AccountId =: lstAccount[0].Id ];
        List<Booking__c> lstBooking = [SELECT Id,Name FROM Booking__c WHERE Name=:b.Name];
        System.debug('lstBooking::'+lstBooking);
         if(!lstAccount.isEmpty()){
             System.debug('lstAccount::'+lstAccount);
         	 if(!lstBooking.isEmpty()){
        	System.debug('lstBooking::'+lstBooking);
                 Booking__c booking = new Booking__c();
                    booking.Id = lstBooking[0].Id;
                    booking.Name = 'B-11';
                    booking.Class_Number__c = 2.2;
                    booking.Is_Trial__c = true;
                    booking.Teacher_Name__c = 'test';
                    booking.Teacher_Comments__c = 'test';
                    booking.Rating__c = '5';
                    booking.Course_Version__c = 'c2';
            booking.Student_Feedback_Category__c = 'Audio';
            booking.Student_Feedback_Comments__c = 'test';
            booking.Student_Feedback_Rating__c = '1';
                 
           
          update booking;
             }         }
        
        /*
         if(!lstAccount.isEmpty()){
         Booking__c booking = new Booking__c();
            booking.Account__c = account.Id;
            booking.Name = 'B-11';
            booking.Class_Number__c = 2.2;
            booking.Is_Trial__c = true;
            booking.Teacher_Name__c = 'test';
            booking.Teacher_Comments__c = 'test';
            booking.Rating__c = '5';
           
           
          insert booking; 
    System.debug(booking);
        } */    
        
    }
    static testmethod void createNewbooking() {
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    String actual = '{"email": "abc@gmail.com","bookingId": "B-12","classNumber": "2","isTrial": true,"teacherName": "test","teacherEmail":"gaurigauri@abc.com","teacherComment":"test","rating": "5","classdate": "2018-07-25","scheduledClassStartTime": "10:00","actualClassStartTime": "10:30","CourseVersion": "test" ,"StudentFeedbackCategory": "Audio","StudentFeedbackComments": "test" ,"StudentFeedbackRating":"1"    }';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    test.startTest();
     WHJ_Booking_API_V2.createBooking();
        test.stopTest();
    }
    
    static testmethod void createbooking() {
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    String actual = '{"email": "abc@gmail.com","bookingId": "B-11","classNumber": "2","isTrial": true,"teacherName": "test","teacherEmail":"gaurigauri@abc.com","teacherComment":"test","rating": "5","classdate": "2018-07-25","scheduledClassStartTime": "10:00","actualClassStartTime": "10:30","CourseVersion": "test" ,"StudentFeedbackCategory": "Audio","StudentFeedbackComments": "test" ,"StudentFeedbackRating":"1"   }';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Booking_API_V2.createBooking();
    }

     static testmethod void createbookingCatch() {
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    String actual = '{"email": "","bookingId": "B-11","classNumber": "2","isTrial": true,"teacherName": "test","teacherEmail":"gaurigauri@abc.com","teacherComment":"test","rating": "5","classdate": "2018-07-25","scheduledClassStartTime": "10:00","actualClassStartTime": "10:30","CourseVersion": "test" ,"StudentFeedbackCategory": "Audio","StudentFeedbackComments": "test" ,"StudentFeedbackRating":"1"   }';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'PUT';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
    
     WHJ_Booking_API_V2.createBooking();
     WHJ_BookingTriggerHandler.onAfterInsertCallout(null);    
    }

 

}