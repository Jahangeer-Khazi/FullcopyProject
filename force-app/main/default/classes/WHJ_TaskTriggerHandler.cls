/*White Hat Junior Task Trigger Handler 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 01/06/2020
 *Purpose: This Apex handler is used for Webhook callout.
 */ 
public class WHJ_TaskTriggerHandler {
    //Get data from trigger
    public static void onAfterInsert(List<Task> TasksList) {
        //Parameters to handle Error logs
        String email = '';
        String reqBody = '';
        try{
            //Set of task ids
            Set<String> SetOfTaskId = new Set<String>();
            //Set of WhatId ids
            Set<Id> SetOfWhatId = new Set<Id>();
            //List of wrapper class
            List<wrapData> wrapList = new List<wrapData>();
            
            //Iteration over Task object
            for(Task t : TasksList){
                //Add task ids to set of task ids
                SetOfTaskId.add(t.Id);
                //Add what ids to set of what ids
                SetOfWhatId.add(t.WhatId);
            }
            //Parameters to assigned data
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
            
            //Get Task list from set of task ids 
            List<Task> TaskDataa = [SELECT Id FROM Task where Id IN : SetOfTaskId  AND what.type = 'Opportunity'];
            //Check if list is not empty
            if(!TaskDataa.isEmpty()){
                //Get trial booking data
                List<Booking__c> lstBooking = [Select Id,Name,Booking_Date__c,Teacher_Comments__c from Booking__c where Opportunity__c IN : SetOfWhatId AND Is_Trial__c = true];
                //Check if list is not empty
                if(!lstBooking.isEmpty()){
                    //Iteration over Booking object
                    for(Booking__c book : lstBooking){
                        //Assignments
                        classCompletionDate = book.Booking_Date__c;
                        teacherComments = book.Teacher_Comments__c;
                        bookingId = book.Name;
                    }    
                    //Get Opportunity Data
                    List<Opportunity> lstOpp = [Select Id,Name,Account.Name,MobileNumber__c,Student_Email__c,Owner.Name,Owner.Email,
                                                Owner.MobilePhone,StageName,Closure_Comments__c from Opportunity where Id IN : SetOfWhatId];
                    //Check if list is not empty
                    if(!lstOpp.isEmpty()){
                        //Iteration over Opportunity object
                        for(Opportunity opp : lstOpp){
                            //Assignments
                            email = opp.Student_Email__c;
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
	                //Get task data
                    List<Task> TaskData = [SELECT  Id, CreatedDate 
                                           FROM Task where WhatId IN : SetOfWhatId ORDER BY createddate DESC NULLS FIRST];
                    //Check if list is not empty
                    if(!TaskData.isEmpty()){
                        //Assignments
                        lastCallTime = TaskData[0].CreatedDate;    
                        noOfCalls = TaskData.size(); 
                    } 
                    //Wrapper Class instance
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
                    //Pass Wrapper class list to SendData method in same handler
                    WHJ_TaskTriggerHandler.SendData(JSON.serialize(wrapList),email);
                }       
            }
        }catch(Exception e){ //Error log exception handler 
            String compName = 'WHJ_TaskTriggerHandler';
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
        //Post wrapper class data to webhook url
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://code.whitehatjr.com/api/V1/teacherSales/leads');
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
            String compName = 'WHJ_TaskTriggerHandler';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = response.getStatusCode() + ' ' + response.getStatus();
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            
        } else {
            System.debug(response.getBody());
        }
    } 
    //Wrapper Class
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