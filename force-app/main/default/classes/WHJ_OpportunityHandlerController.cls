/*White Hat Junior Opportunity Handler 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 01/06/2020
*Purpose: This Apex handler is used for Webhook callout and create OCR for renewal opportunity.
*/ 
public class WHJ_OpportunityHandlerController {
    public static void onAfterInsert(List<Opportunity> lstOppo) {
        List<OpportunityContactRole> oldOCR = [Select Id From OpportunityContactRole Where OpportunityId =: lstOppo[0].Id];
        if(oldOCR.isEmpty()){
            List<OpportunityContactRole> lstOCR = new List<OpportunityContactRole>();
            
            
            Set<Id> SetofAccIds = new Set<Id>(); 
            
            
            
            for(Opportunity oppo : lstOppo){
                SetofAccIds.add(oppo.AccountId);
            }
            System.debug('SetofAccIds::'+SetofAccIds);
            
            
            
            
            
            Map<Id,Account> AccountMap = new Map<Id,Account>([Select Id From Account Where Id IN :SetofAccIds]);
            
            
            
            // Map<Id,Contact> contactMap = new Map<Id,Contact>([Select Id , AccountId From Contact Where Id IN :SetofAccIds]);
            
            
            
            
            List<Contact> con = [Select Id , AccountId From Contact Where AccountId =: SetofAccIds];
            
            
            for(Opportunity oppo1 : lstOppo){
                
                OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.role= 'Student';
                ocr.OpportunityId = oppo1.Id;
                
                for (Contact cont: con){
                    if(cont.AccountId == AccountMap.get(oppo1.AccountId).Id)
                    {
                        ocr.ContactId = cont.id;
                    }
                    else
                        continue;    
                }
                //ocr.ContactId = con.Id;
                
                
                lstOCR.add(ocr);
                
                
            }insert lstOCR;
            
            
            
            System.debug('lstOCR::'+lstOCR);  
        }
    }
    //Get data from trigger
    public static void onAfterUpdateCallout(List<Opportunity> lstOppo){
        //Parameters to handle Error logs
        String email = '';
        String reqBody = '';
        try{
            //Set of Booking ids
            Set<String> SetOfBookingId = new Set<String>();
            //Set of Opportunity ids
            Set<Id> SetOfOppId = new Set<Id>();
            //List of wrapper class
            List<wrapData> wrapList = new List<wrapData>();
            //Iteration over Opportunity object
            for(Opportunity oppo : lstOppo){
                email = oppo.Student_Email__c;
                //Add opty ids to set of opty ids
                SetOfOppId.add(oppo.Id);
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
            //Get Booking list from set of opty ids 
            List<Booking__c> lstBooking = [Select Id,Name,Booking_Date__c,Teacher_Comments__c from Booking__c where Opportunity__c IN : SetOfOppId AND Is_Trial__c = true];
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
                                            Owner.MobilePhone,StageName,Closure_Comments__c from Opportunity where Id IN : SetOfOppId];
                //Check if list is not empty
                if(!lstOpp.isEmpty()){
                    //Iteration over Opportunity object
                    for(Opportunity opp : lstOpp){
                        //Assignments
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
                List<Task> TaskData = [SELECT  Id,CreatedDate 
                                       FROM Task where WhatId IN : SetOfOppId and type = 'Call' ORDER BY createddate DESC NULLS FIRST];
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
                WHJ_OpportunityHandlerController.SendData(JSON.serialize(wrapList),email);
            }
        }catch(Exception e){//Error log exception handler 
            String compName = 'WHJ_OpportunityHandlerController';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
        }
    }
    
    public static void UpdateReferralWonCount(List<Opportunity> OpportunityList, Map<Id, Opportunity> mapOpptyOld)
    {
        String email = '';
        String reqBody = '';
        try{
            Set<Id> SetOfOppId = new Set<Id>();
            Set<String> SetOfAccId = new Set<String>();
            for(Opportunity oppo : OpportunityList){
                system.debug('###11'+oppo.StageName);
                system.debug('###12'+mapOpptyOld.get(oppo.Id).StageName);
                if((oppo.Stage_Won__c == 1) && (mapOpptyOld.get(oppo.Id).Stage_Won__c <> oppo.Stage_Won__c) && oppo.Referred_by_Customer__c != null && oppo.Referral_Customer__c != null)
                {
                    system.debug('###1');
                    SetOfOppId.add(oppo.Id);
                    SetOfAccId.add(oppo.Referral_Customer__c);
                }
            }
            
            
            List<Account> accList = [select id,PersonEmail,Count_of_Referral_Provided__c,Count_of_Referrals_Won__c from Account where PersonEmail in: SetOfAccId]; // account list
            List<Opportunity> oppList = [select id,Referral_Customer__c,Referred_by_Customer__c from Opportunity where id in: SetOfOppId]; // opportunity list
            
            List<Account> ListUpdateAcc = new List<Account>();
            
            
            if(!accList.isEmpty()){
                for (Opportunity opp :oppList)
                {
                    for(Account acc : accList)
                    {
                        if(opp.Referral_Customer__c == acc.PersonEmail){
                            
                            // increase count of referral won provided by 1
                            
                            if(acc.Count_of_Referrals_Won__c == null)
                            {
                                acc.Count_of_Referrals_Won__c = 1 ;
                            }
                            else
                            {
                                acc.Count_of_Referrals_Won__c = acc.Count_of_Referrals_Won__c + 1;
                            }
                            ListUpdateAcc.add(acc);
                            
                            
                            break;
                        }
                        else
                            continue;
                        
                    }
                }
                
                update  ListUpdateAcc;
                
            }
            
            
            
        }
        Catch(Exception e)
        {
            String compName = 'WHJ_OpportunityHandlerController';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            
            
        } 
        
        
    }
    
    public static void populateAccountIdLookup(List<Opportunity> lstOppo){//method to populate Account id
        
        String email = '';
        String reqBody = '';
        try{
            
            Set<Id> SetOfOppId = new Set<Id>();
            
            Set<String> SetOfMailId = new Set<String>();
            
            
            for(Opportunity oppo : lstOppo){
                email = oppo.Student_Email__c;
                SetOfOppId.add(oppo.Id);
                SetOfMailId.add(oppo.Referral_Customer__c);
            }
            
            List<Account> accList = [select id,PersonEmail,Count_of_Referral_Provided__c from Account where PersonEmail in: SetOfMailId]; // account list
            List<Opportunity> oppList = [select id,Referral_Customer__c,Referred_by_Customer__c from Opportunity where id in:SetOfOppId]; // opportunity list
            List<Opportunity> ListUpdateOpp = new List<Opportunity>();
            List<Account> ListUpdateAcc = new List<Account>();
            if(!accList.isEmpty()){
                for (Opportunity opp :oppList)
                {
                    for(Account acc : accList)
                    {
                        if(opp.Referral_Customer__c == acc.PersonEmail){
                            opp.Referred_by_Customer__c = acc.id;  //populate account id
                            
                            
                            // increase count of referral provided by 1
                            
                            if(acc.Count_of_Referral_Provided__c == null)
                            {
                                acc.Count_of_Referral_Provided__c = 1 ;
                            }
                            else
                            {
                                acc.Count_of_Referral_Provided__c = acc.Count_of_Referral_Provided__c + 1;
                            }
                            ListUpdateAcc.add(acc);
                            
                            ListUpdateOpp.add(opp);
                            break;
                        }
                        else
                            continue;
                        
                    }
                }
                update ListUpdateOpp;
                update  ListUpdateAcc;
                
            }
            
            
        }
        Catch(Exception e)
        {
            String compName = 'WHJ_OpportunityHandlerController';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            
            
        }
        
        
        
    }
    
    
    @future(callout=true)
    public static void SendData(String getData,String emailrec) {
        String email = emailrec;
        String reqBody = '';
        System.debug('getData::'+getData);
        //Post wrapper class data to webhook url
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint('https://v2stage.whitehatjr.com/api/V1/teacherSales/leads');
        request.setEndpoint(System.Label.TeacherSalesLeadURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader( 'Authorization', 'Bearer ' + System.Label.token );
        System.debug('123'+System.Label.token);
        // Set the body as a JSON object
        request.setBody(getData);
        HttpResponse response = new HttpResponse();
        if(!test.isRunningTest()){
            response = http.send(request);
        }else{
            response.setStatusCode(201);
        }        
        if (response.getStatusCode() != 200) {
            String compName = 'WHJ_OpportunityHandlerController';
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
    
    public static void onAfterInsertForSalesken(List<Opportunity> lstOppo) {
        Set<String> lstOppIds = new Set<String>();
        String reqBody = '';
        try{
            //Iteration over Opportunity object to get Opportunity type and ownerid
            system.debug('lstOppo -- ' + lstOppo);
            for(Opportunity opty : lstOppo){
                system.debug('opty -- ' + opty);
                lstOppIds.add(opty.Id);
            }
            system.debug('lstOppIds ---- ' + lstOppIds);
            List<Opportunity> changedOwnerRecords = [Select Id, Type, Owner.Email, Student_Email__c from Opportunity where Id IN:lstOppIds];
            listOfOppsForSalesken(changedOwnerRecords);
        }catch(Exception e){ //Exception
            system.debug('exception-- ' + e.getMessage());
            String compName = 'WHJ_OpportunityHandlerController';
            String compType = 'Apex Handler';
            String recRef = 'sendtoSalesken Future';
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);    
        }
    }
    
    public static void onAfterUpdateForSalesken(List<Opportunity> lstOppo, Map<Id, Opportunity> lstOldOpp){
        Set<String> lstOppIds = new Set<String>();
        String reqBody = '';
        try{
            //Iteration over Opportunity object to get Opportunity type and ownerid
            for(Opportunity opty : lstOppo){
                if(lstOldOpp!= null && lstOldOpp.get(opty.id).ownerId != opty.OwnerId) {
                    lstOppIds.add(opty.Id);
                }
            }
            List<Opportunity> changedOwnerRecords = [Select Id, Type, Owner.Email, Student_Email__c from Opportunity where Id IN:lstOppIds];
            listOfOppsForSalesken(changedOwnerRecords);
        }catch(Exception e){ //Exception
            String compName = 'WHJ_OpportunityHandlerController';
            String compType = 'Apex Handler';
            String recRef = 'ref';
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);    
        }
    }
    
    public static void listOfOppsForSalesken(List<Opportunity> oppList) {
        //Query custom metadata to check boolean value for specific type
        system.debug('for salesken--- ' + oppList);
        List<SalesKen__mdt> Saleskenmdt = [Select Name__c,Value__c from SalesKen__mdt];
        for(Opportunity oppo : oppList){
            system.debug('opp lsit--- ' + oppo);
            system.debug('Saleskenmdt--- ' + Saleskenmdt);
            for(SalesKen__mdt sk: Saleskenmdt) {
                if(oppo.Type == sk.Name__c && sk.Value__c == true) {
                    String email = oppo.Student_Email__c;
                    String OwnerEmail = oppo.Owner.Email;
                    WHJ_OpportunityHandlerController.SendDataToSalesken(oppo.Id,OwnerEmail,oppo.Student_Email__c);
                    break;
                }
            }     
        }
    }
    
    // send to salesken for creating task
    @future(callout=true)
    public static void SendDataToSalesken(String oppId,String ownerEmailId,String recEmail) {
        String email = recEmail;
        String reqBody = '';
        //Post wrapper class data to webhook url
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.SaleskenEndpoint1 + System.Label.SaleskenEndpoint2+'&opp_id='+oppId + '&actor_email='+ownerEmailId);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse response = new HttpResponse();
        if(!test.isRunningTest()){
            response = http.send(request);
        }else{
            response.setStatusCode(201);
        }        
        if (response.getStatusCode() != 200) {
            String compName = 'WHJ_OpportunityHandlerController';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = response.getStatusCode() + ' ' + response.getStatus();
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            System.debug('error -- ' + response.getBody());
        } else {
            System.debug('Success-- ' + response.getBody());
        }
    }
    
}