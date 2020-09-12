public class WHJ_BookingTriggerHandler {
    public static void onAfterInsert(List<Booking__c> lstBooking) {
        List<Contact> lstContact = [Select Id,Name From Contact Where Email =: lstBooking[0].Teacher_Email__c ];
        if(!lstContact.isEmpty()){
            List<Booking__c> lstBook = [Select Id,Teacher_Id__c From Booking__c Where Id =: lstBooking[0].Id ];
            if(!lstBook.isEmpty()){
                lstBook[0].Teacher_Id__c = lstContact[0].Id;
            }update lstBook;
        }
    }
    public static void onAfterInsertCallout(List<Booking__c> lstBook) {
     	 String email = '';
        String reqBody = '';

        try{
            Set<String> SetOfBookingId = new Set<String>();
            Set<Id> SetOfOppId = new Set<Id>();
            List<wrapData> wrapList = new List<wrapData>();
            
            for(Booking__c book : lstBook){
                SetOfBookingId.add(book.Name);
                SetOfOppId.add(book.Opportunity__c);
            }
            
            Date classCompletionDate; // booking 
            String teacherComments;  // booking
            String bookingId; // booking
            DateTime lastCallTime; //task
            Integer noOfCalls; //task
            String studentName; // opty
            String studentMobile; // opty
            String studentEmail;  // opty
            String salesPersonName; // opty
            String salesPersonEmail; // opty
            String salesPersonMobile; // opty
            String status; // opty
            String salesComments; // opty
            
            List<Booking__c> lstBooking = [Select Id,Name,Booking_Date__c,Teacher_Comments__c from Booking__c where Name IN : SetOfBookingId];
            if(!lstBooking.isEmpty()){
                for(Booking__c book : lstBooking){
                    classCompletionDate = book.Booking_Date__c;
                    teacherComments = book.Teacher_Comments__c;
                    bookingId = book.Name;
                }    
            }
            
            List<Opportunity> lstOpp = [Select Id,Name,Account.Name,MobileNumber__c,Student_Email__c,Owner.Name,Owner.Email,
                                        Owner.MobilePhone,StageName,Closure_Comments__c from Opportunity where Id IN : SetOfOppId];
            if(!lstOpp.isEmpty()){
                for(Opportunity opp : lstOpp){
                    studentName = opp.Account.Name;
                    studentMobile = opp.MobileNumber__c;
                    studentEmail = opp.Student_Email__c;
                    salesPersonName = opp.Owner.Name;
                    salesPersonEmail = opp.Owner.Email;
                    salesPersonMobile = opp.Owner.MobilePhone;
                    status = opp.StageName;
                    salesComments = opp.Closure_Comments__c;
                }
            }
            
            List<Task> TaskData = [SELECT Id, CreatedDate
                                   FROM Task where WhatId IN : SetOfOppId and type = 'Call' ORDER BY createddate DESC NULLS FIRST];
            if(!TaskData.isEmpty()){
                lastCallTime = TaskData[0].CreatedDate;    
                noOfCalls = TaskData.size(); 
            }
            wrapData wr = new wrapData();
            wr.classCompletionDate = classCompletionDate;
            wr.teacherComments = teacherComments;
            wr.bookingId = bookingId;
            wr.lastCallTime = lastCallTime;
            wr.noOfCalls = noOfCalls;
            wr.studentName = studentName;
            wr.studentMobile = studentMobile;
            wr.studentEmail = studentEmail;
            wr.salesPersonName = salesPersonName;
            wr.salesPersonEmail = salesPersonEmail;
            wr.salesPersonMobile = salesPersonMobile;
            wr.status = status;
            wr.salesComments = salesComments;
            wrapList.add(wr);
            
            WHJ_BookingTriggerHandler.SendData(JSON.serialize(wrapList),email);        
        }catch(Exception e){
            String compName = 'WHJ_BookingTriggerHandler';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);            
        }   
    }
        @future(callout=true)
    public static void SendData(String getData,String emailrec) {
        System.debug('getData::'+getData);
        String email = emailrec;
        String reqBody = '';
 
          Http http = new Http();
            HttpRequest request = new HttpRequest();
        //https://v2stage.whitehatjr.com/api/V1/teacherSales/leads
        	request.setEndpoint(System.Label.TeacherSalesLeadURL);
            //request.setEndpoint('https://code.whitehatjr.com/api/V1/teacherSales/leads');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        	request.setHeader( 'Authorization', 'Bearer ' + System.Label.token );
            // Set the body as a JSON object
            request.setBody(getData);
            HttpResponse response = new HttpResponse();
            if(!test.isRunningTest()){
                response = http.send(request);
            }else{
            	response.setStatusCode(201);
            }
            if (response.getStatusCode() != 200) {
            String compName = 'WHJ_BookingTriggerHandler';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = response.getStatusCode() + ' ' + response.getStatus();
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            
        } else {
            System.debug(response.getBody());
        }
    } 
    
    public class wrapData {
        public Date classCompletionDate {get; set;}
        public String teacherComments {get; set;}
        public String bookingId {get; set;}
        public DateTime lastCallTime {get; set;}
        public Integer noOfCalls {get; set;}
        public String studentName {get; set;}
        public String studentMobile {get; set;}
        public String studentEmail {get; set;}
        public String salesPersonName {get; set;}
        public String salesPersonEmail {get; set;}
        public String salesPersonMobile {get; set;}
        public String status {get; set;}
        public String salesComments {get; set;}
        
    }
    
}