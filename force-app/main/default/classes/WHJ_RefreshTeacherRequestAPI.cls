/*White Hat Junior CASE API REST Class 
*Created By: Mohit
*Release No: 1
*Created Date: 24/08/2020
*Purpose: This Apex REST API class is to Send detail of teacher when teacher click refresh button on it panel.
*/ 

@RestResource(urlMapping='/RefreshTaskTeacher/*')
global class WHJ_RefreshTeacherRequestAPI {
    @httpPost
    global static Void teacherTaskDetails(){
        String email = '';
        String reqBody = '';
        try{
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
            
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            System.debug('@@@ reqBody '+reqBody);
            wrap_RefreshTaskRequest readValueAsResults = (wrap_RefreshTaskRequest)JSON.deserialize(reqBody, wrap_RefreshTaskRequest.class);
            System.debug('@@@ Student Email '+readValueAsResults.studentEmail);
            if(String.isNotBlank(readValueAsResults.studentEmail)){
                List<Booking__c> lstBooking = [Select Id,Name,Booking_Date__c,Teacher_Comments__c from Booking__c where Account__r.PersonEmail =:readValueAsResults.studentEmail ORDER BY createddate DESC Limit 1];
                if(!lstBooking.isEmpty()){
                    Booking__c book = lstBooking[0];
                    classCompletionDate = book.Booking_Date__c;
                    teacherComments = book.Teacher_Comments__c;
                    bookingId = book.Name;
                }
                List<Opportunity> lstOpp = [Select Id,Name,Account.Name,MobileNumber__c,Student_Email__c,Owner.Name,Owner.Email,
                                            Owner.MobilePhone,StageName,Closure_Comments__c from Opportunity where Account.PersonEmail =: readValueAsResults.studentEmail Limit 1];
                if(!lstOpp.isEmpty()){
                    Opportunity opp = lstOpp[0];
                    studentName = opp.Account.Name;
                    studentMobile = opp.MobileNumber__c;
                    studentEmail = opp.Student_Email__c;
                    salesPersonName = opp.Owner.Name;
                    salesPersonEmail = opp.Owner.Email;
                    salesPersonMobile = opp.Owner.MobilePhone;
                    status = opp.StageName;
                    salesComments = opp.Closure_Comments__c;
                }
                List<Task> TaskData = [SELECT Id, CreatedDate
                                       FROM Task where WhatId =: lstOpp[0].Id  and type = 'Call' ORDER BY createddate DESC NULLS FIRST];
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
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(wr)); 	   
            }else{
                Error_msg emsg = new Error_msg();
                emsg.msg = 'Please Enter Student Email';
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(emsg)); 
            }
        }catch(Exception e){//Exception
            RestContext.response.statusCode = 400;
            String compName = 'WHJ_Case_API';
            String compType = 'REST API Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
        }
    } 
    
    
    public class wrap_RefreshTaskRequest{
        public String studentEmail{get;set;}
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
    public class Error_msg{
        public String msg{get;set;}
    }
}