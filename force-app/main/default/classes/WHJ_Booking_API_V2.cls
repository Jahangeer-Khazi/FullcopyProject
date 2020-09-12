/*White Hat Junior Booking API V2 REST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 07/11/2019
 *Purpose: This Apex REST API class is to creates a booking for the V2 Student where
Student email is same as email in service request.
 */ 

@RestResource(urlMapping='/BookingAPIV2')
global class WHJ_Booking_API_V2 {

 @HttpPut
    global static Void createBooking() 
    {
        String email = '';
        String reqBody = '';
    try{
        RestRequest request = RestContext.request;
        reqBody = request.requestBody.toString(); 
        system.debug('createBooking  :: '+ reqBody);
        ParentRecord parent = new ParentRecord();
        parent.success = true;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    

        Type resultType = Type.forName('WHJ_BookingParser');
        WHJ_BookingParser readValueAsResults = (WHJ_BookingParser)JSON.createParser(reqBody).readValueAs(resultType);
        System.debug('==========> createParser().readValueAs() results = ' + readValueAsResults);
        email = readValueAsResults.email;
        Decimal myInt;
        if(readValueAsResults.isTrial == false){
        String cno = readValueAsResults.classNumber;
        String str = cno.SubStringAfter('-C');
        System.debug('str ::'+str);
            
        myInt = Decimal.valueOf(str);
        System.debug('myInt::'+myInt);
        }
        
        Time TimeforScheduledclass;
        Time TimeforactualClass;    
        if(readValueAsResults.scheduledClassStartTime <> null){
            Time ts = readValueAsResults.scheduledClassStartTime;
            TimeforScheduledclass = ts.addMinutes(330);    
        }
        
        if(readValueAsResults.actualClassStartTime <> null){
            Time ta = readValueAsResults.actualClassStartTime;
            TimeforactualClass = ta.addMinutes(330);    
        }
		
        
        //Select the student record for the email address in the request
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail =: readValueAsResults.email];

        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity where (IsWon = false  OR IsClosed = false ) And AccountId =: lstAccount[0].Id   ];
      	 
        List<Booking__c> lstBooking = [SELECT Id,Name FROM Booking__c WHERE Name=:readValueAsResults.bookingId];
        
        
        
        
        
        if(!lstAccount.isEmpty()){//If Account found, create booking
        if(!lstBooking.isEmpty()){
            Booking__c booking = new Booking__c();
            booking.Id = lstBooking[0].Id;
            if(readValueAsResults.bookingId <> null){
            	booking.Name = readValueAsResults.bookingId;    
            }
            if(readValueAsResults.isTrial == false){
            booking.Class_Number__c = myInt;                
            }
            if(readValueAsResults.classNumber <> null){
            	booking.Class_Number_Text__c = readValueAsResults.classNumber;
            }
            if(readValueAsResults.isTrial <> null){
            	booking.Is_Trial__c = readValueAsResults.isTrial;    
            }
            
            if(readValueAsResults.teacherName <> null){
            	booking.Teacher_Name__c = readValueAsResults.teacherName;    
            }
            
            if(readValueAsResults.teacherComment <> null){
            	booking.Teacher_Comments__c = readValueAsResults.teacherComment;    
            }
            
            if(readValueAsResults.teacherPhone <> null){
                booking.Teacher_Phone__c = readValueAsResults.teacherPhone;
            }
            
            if(readValueAsResults.teacherEmail <> null){
                booking.Teacher_Email__c = readValueAsResults.teacherEmail;
            }
            
            if(readValueAsResults.rating <> null){
                booking.Rating__c = readValueAsResults.rating;
            }
            
            if(readValueAsResults.classdate <> null){
                booking.Booking_Date__c = readValueAsResults.classdate;
            }
            
            if(TimeforScheduledclass <> null){
            	booking.Scheduled_Class_Start_Time__c = TimeforScheduledclass;    
            }
            
            if(TimeforactualClass <> null){
            	booking.Actual_Class_Start_Time__c= TimeforactualClass;    
            }
            
            if(readValueAsResults.timezone <> null){
            	booking.Time_Zone__c = readValueAsResults.timezone;    
            }
            
            if(readValueAsResults.CourseVersion <> null){
            	booking.Course_Version__c = readValueAsResults.CourseVersion;    
            }
            
            if(readValueAsResults.StudentFeedbackCategory <> null){
            	booking.Student_Feedback_Category__c = readValueAsResults.StudentFeedbackCategory;    
            }
            
            if(readValueAsResults.StudentFeedbackComments <> null){
            	booking.Student_Feedback_Comments__c = readValueAsResults.StudentFeedbackComments;    
            }
            
            if(readValueAsResults.StudentFeedbackRating <> null){
            	booking.Student_Feedback_Rating__c = readValueAsResults.StudentFeedbackRating;    
            }
            
            
          update booking;
        }else{
            Booking__c booking = new Booking__c();
            booking.Account__c =   lstAccount[0].Id;
            booking.Name = readValueAsResults.bookingId;
            if(readValueAsResults.isTrial == false){
            booking.Class_Number__c = myInt;                
            }
            booking.Class_Number_Text__c = readValueAsResults.classNumber;
            booking.Is_Trial__c = readValueAsResults.isTrial;
            booking.Teacher_Name__c = readValueAsResults.teacherName;
            booking.Teacher_Comments__c = readValueAsResults.teacherComment;
            booking.Teacher_Phone__c = readValueAsResults.teacherPhone;
            booking.Teacher_Email__c = readValueAsResults.teacherEmail;
            booking.Rating__c = readValueAsResults.rating;
            booking.Booking_Date__c = readValueAsResults.classdate;
            booking.Scheduled_Class_Start_Time__c = TimeforScheduledclass;
            booking.Actual_Class_Start_Time__c= TimeforactualClass;
            booking.Time_Zone__c = readValueAsResults.timezone;
            booking.Course_Version__c = readValueAsResults.CourseVersion;
            booking.Student_Feedback_Category__c = readValueAsResults.StudentFeedbackCategory;
            booking.Student_Feedback_Comments__c = readValueAsResults.StudentFeedbackComments;
            booking.Student_Feedback_Rating__c = readValueAsResults.StudentFeedbackRating;
            
            if(!lstOpportunity.isEmpty()){//If opportunity is open then only associate the booking with opportunity
                booking.Opportunity__c = lstOpportunity[0].Id;
             }
            
          insert booking;
        }
        }        
        
        
        
        
        
        
        
        
       /* 
        
        if(!lstAccount.isEmpty()){//If Account found, create booking
         System.debug(lstAccount);
            
          Booking__c booking = new Booking__c();
            booking.Account__c =   lstAccount[0].Id;
            booking.Name = readValueAsResults.bookingId;
            if(readValueAsResults.isTrial == false){
            booking.Class_Number__c = myInt;                
            }
            booking.Class_Number_Text__c = readValueAsResults.classNumber;
            booking.Is_Trial__c = readValueAsResults.isTrial;
            booking.Teacher_Name__c = readValueAsResults.teacherName;
            booking.Teacher_Comments__c = readValueAsResults.teacherComment;
            booking.Teacher_Phone__c = readValueAsResults.teacherPhone;
            booking.Teacher_Email__c = readValueAsResults.teacherEmail;
            booking.Rating__c = readValueAsResults.rating;
            booking.Booking_Date__c = readValueAsResults.classdate;
            booking.Scheduled_Class_Start_Time__c = TimeforScheduledclass;
            booking.Actual_Class_Start_Time__c= TimeforactualClass;
            
            if(!lstOpportunity.isEmpty()){//If opportunity is open then only associate the booking with opportunity
                booking.Opportunity__c = lstOpportunity[0].Id;
             }
            
          insert booking;
        }    */ 
        }catch(Exception e){//Exception
        RestContext.response.statusCode = 400;
        ParentRecord parent = new ParentRecord();
        parent.success = false;
        parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));
        String compName = 'WHJ_Booking_API_V2';
        String compType = 'REST API Class';
        String recRef = email;
        String err = e.getMessage()  + e.getStackTraceString(); 
        String req = reqBody;    
        WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));      }//return  'Success';  
    }
 public class ParentRecord {
    public Boolean success;
    public ChildRecord[] error;
    public ParentRecord() {
        this.success = success;
        error = new ChildRecord[0];
    }
}

public class ChildRecord {
    public String error_Code, error_message;
    public ChildRecord( String errorCode, string message) {
        this.error_Code = errorCode;
        this.error_message = message;
    }
}
}