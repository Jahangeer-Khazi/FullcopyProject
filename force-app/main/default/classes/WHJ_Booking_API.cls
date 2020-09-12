/*White Hat Junior Booking API REST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 16/09/2019
 *Purpose: This Apex REST API class is to creates a booking for the Student where
Student email is same as email in service request.
 */ 

@RestResource(urlMapping='/BookingAPI')
global class WHJ_Booking_API {

 @HttpPost
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
        
        Time ts = readValueAsResults.scheduledClassStartTime;
        Time TimeforScheduledclass = ts.addMinutes(-390);
 
		Time ta = readValueAsResults.actualClassStartTime;
        Time TimeforactualClass = ta.addMinutes(-390);
        
        //Select the student record for the email address in the request
        List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail =: readValueAsResults.email];

        List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName FROM Opportunity where (IsWon = false  OR IsClosed = false ) And AccountId =: lstAccount[0].Id   ];
      
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
        }     
        }catch(Exception e){//Exception
        RestContext.response.statusCode = 400;
        ParentRecord parent = new ParentRecord();
        parent.success = false;
        parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));
        String compName = 'WHJ_Booking_API';
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