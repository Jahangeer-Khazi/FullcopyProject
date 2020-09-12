@isTest
global class  SetTrialDate_Test {
     @testSetup  static void setupTestData()
     {
        
       
    
       Opportunity oppo = new Opportunity(Name = 'Test' , StageName = 'Trial Class Complete', CloseDate = Date.newInstance(1960, 2, 17));
       //insert oppo;   
         
       Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'abc@gmail.com');
        insert account;
       
        
         
         Booking__c booking = new Booking__c();
            booking.Account__c = account.Id;
            booking.Opportunity__c =  oppo.Id; 
            booking.Name = 'B-11';
            booking.Class_Number__c = 2.2;
            booking.Is_Trial__c = true;
            booking.Teacher_Name__c = 'test';
            booking.Teacher_Comments__c = 'test';
            booking.Rating__c = '5';
          	booking.Actual_Class_Start_Time__c = Time.newInstance(9, 30, 0, 0);
         	booking.Course_Name__c = 'Basic';
            booking.Booking_Date__c =Date.newInstance(2019, 02, 25);
        
           
          insert booking; 
    System.debug(booking);
     
     }
    
    static testmethod void updateDate() {
        Booking__c b = [Select Id , Name ,Actual_Class_Start_Time__c,Booking_Date__c,Opportunity__c from Booking__c LIMIT 1];
        Opportunity opp = new Opportunity();
        opp.Id = b.Opportunity__c;
        DateTime dt = DateTime.newInstance(b.Booking_Date__c, b.Actual_Class_Start_Time__c);
        
        opp.Trial_Date_Time__c = dt;
        opp.Trial_Time__c = b.Actual_Class_Start_Time__c;
       // update opp;
    }

}