/*White Hat Junior Lead API REST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 11/09/2019
*Purpose: This Apex REST API class is to creates a Lead And Student record
*Change History : CH01 #Jahangeer Khazi# Added a debug Statements  to track the Lead Ids that is coming from PostMan.
*/ 


@RestResource(urlMapping='/Students')
global class WHJ_Lead_API {
    
    @HttpPut
    global static Void createLead() 
    {
        String email = '';
        String reqBody = '';
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            system.debug('createLead  :: '+ reqBody);
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
            
            Type resultType = Type.forName('WHJ_LeadParser');
            WHJ_LeadParser readValueAsResults = (WHJ_LeadParser)JSON.createParser(reqBody).readValueAs(resultType);
            System.debug('==========> createParser().readValueAs() results = ' + readValueAsResults);
            email = readValueAsResults.primaryemail;
            Map<String, WhJr_Lead_Status_Mapping__mdt> mapOfStatus = new Map<String, WhJr_Lead_Status_Mapping__mdt>();
            for(WhJr_Lead_Status_Mapping__mdt mapping: [select id, MasterLabel,Status_Value__c, Target_Object__c 
                                                        from WhJr_Lead_Status_Mapping__mdt])
            {
                mapOfStatus.put(mapping.MasterLabel, mapping);
            }
            
            if(readValueAsResults.status == '9') {
                List<User> RefUser = [Select id from User where (UserRole.Name =:system.label.Role_Referral_Manager OR UserRole.Name =:system.label.Role_Referral_Manager_USA  OR UserRole.Name =:system.label.Role_Dead_Leads_Referrals_Manager  OR UserRole.Name =:system.label.Role_Dead_Leads_Referrals_Manager_USA ) AND Email =:readValueAsResults.ReferralManager];
                // for un registered lead
                //if lead generator is except referral Manager then Unregistered lead will not be created 
                if(readValueAsResults.LeadType == 'referral' && !RefUser.isEmpty()) 
                {
                    
                    //create lead
                    Lead getLeadRec = getLead(readValueAsResults);
                }
            } else {
                List<Lead> lstLead = new List<Lead>();
                //Select the Active Lead record for the email address in the request
                if (readValueAsresults.LeadId != null) {
                    //CH01 Start
                    System.debug('Lead ID :'+readValueAsresults.LeadId);
                    //CH01 End
                    lstLead = [Select id, IsConverted, Email from Lead where LeadId__c =:readValueAsresults.LeadId  and IsConverted = false];
                } else { //Select the student record for the email address in the request
                    //CH01 Start
                    System.debug('Lead Primary Email:'+readValueAsresults.primaryemail);
                    //CH02 End
                    lstLead = [Select id, IsConverted, Email from Lead where Email =:readValueAsResults.primaryemail and IsConverted = false];
                }
                
                
                
                List<Account> lstAccount  =[Select id, PersonEmail from Account where PersonEmail =:readValueAsResults.primaryemail];
                
                
                if(!lstLead.isEmpty())  //If Lead found, Update same lead
                {
                    Lead lead = new Lead();
                    lead.id = lstLead[0].Id;
                    lead.FirstName = readValueAsResults.firstname;
                    lead.LastName = readValueAsResults.lastname;
                    lead.Alternate_Email__c = readValueAsResults.alternateemail;
                    if(readValueAsResults.street <> null){
                        lead.Street = readValueAsResults.street.substring(0, Math.min(readValueAsResults.street.length(), 255));    
                    }  
                    if (readValueAsresults.LeadId != null) {
                        lead.Email = readValueAsResults.primaryemail;
                        lead.Status = mapOfStatus.get(readValueAsResults.status).Status_Value__c;
                    }
                    lead.State = readValueAsResults.state;
                    lead.City = readValueAsResults.city;
                    lead.Country = readValueAsResults.country;
                    lead.MobilePhone = readValueAsResults.mobile;
                    lead.Parent_Name__c = readValueAsResults.parentname;
                    lead.Registration_Date__c = readValueAsResults.registereddate;
                    
                    if(readValueAsResults.appointmentschedule != NULL )
                    {
                        lead.Appointment_Schedule__c = (readValueAsResults.appointmentschedule); 
                    }
                    if(readValueAsResults.appointmentcomments != NULL )
                    {
                        lead.Appointment_Comments__c = readValueAsResults.appointmentcomments; 
                    }
                    
                    lead.Grade__c = readValueAsResults.grade;
                    lead.Gender__c = readValueAsResults.gender;
                    lead.Credit__c  = readValueAsResults.credit;
                    lead.Timezone__c = readValueAsResults.timezone;
                    lead.Id__c = readValueAsResults.id;
                    lead.Student_Id__c = readValueAsResults.studentid;
                    lead.Campaign_Source__c = readValueAsResults.campaignsource;
                    lead.Campaign_Medium__c = readValueAsResults.campaignmedium;
                    lead.Campaign_Name__c = readValueAsResults.campaignname;
                    lead.Campaign_Content__c = readValueAsResults.campaigncontent;
                    lead.Campaign_Term__c = readValueAsResults.campaignterm;
                    lead.Campaign_Creative__c = readValueAsResults.campaigncreative;
                    lead.Language__c = readValueAsResults.language;
                    lead.Page__c = readValueAsResults.page;
                    lead.Campaign_Id__c = readValueAsResults.campaignid;
                    lead.Adset_Id__c = readValueAsResults.adsetid;
                    lead.Ad_Id__c = readValueAsResults.adid;
                    lead.Affiliate_Name__c = readValueAsResults.affiliatename;
                    lead.List_Name__c = readValueAsResults.listname;
                    lead.Location__c = readValueAsResults.location;
                    lead.Match_Type__c = readValueAsResults.matchtype;
                    lead.Device__c = readValueAsResults.device;
                    lead.REF_Type__c = readValueAsResults.reftype;
                    lead.REF_Description__c = readValueAsResults.refdescription;
                    lead.Total_Discount__c = readValueAsResults.totaldiscount;     
                    lead.SalesRef__c = readValueAsResults.salesRef; 
                    lead.course_short_name__c = readValueAsResults.course_short_name; 
                    lead.AdditionalContactNo__c = readValueAsresults.additionalContactNo;           
                    lead.Subscription_Flag__c = readValueAsresults.subscriptionflag;
                    lead.Additional_Email__c = readValueAsresults.additionalEmailId;
                    lead.LeadId__c = readValueAsresults.LeadId != null ? readValueAsresults.LeadId : '';  
                    
                    
                    if(readValueAsresults.ReferralCustomer != NULL){
                        lead.Referral_Customer__c = readValueAsresults.ReferralCustomer; // populating referral customer if provided
                        lead.LeadSource = system.Label.LeadSourceValueStudentReferral; //if lead have referral customer then making lead source as student referral
                    }
                    
                    if(readValueAsresults.ReferralManager != NULL){
                        lead.Referral_Manager__c = readValueAsresults.ReferralManager; //populating referral manager if provided
                    }
                    
                    
                    
                    if(lstLead[0].Email == readValueAsResults.primaryemail){
                        lead.Status = mapOfStatus.get(readValueAsResults.status).Status_Value__c;
                        
                        
                        if(mapOfStatus.get(readValueAsResults.status).Target_Object__c == null)
                        {
                            lead.Do_Not_Disturb__c =  true;
                        }else{
                            lead.Do_Not_Disturb__c = false;
                        }
                    }else{
                        System.debug('Already Lead Exist');
                    }
                    
                    update lead;
                    //Else , create Lead
                } else if(lstLead.isEmpty() && lstAccount.isEmpty() && (readValueAsResults.status == '11' || readValueAsResults.status == '13')){
                    Lead lead = new Lead();
                    lead.FirstName = readValueAsResults.firstname;
                    lead.LastName = readValueAsResults.lastname;
                    lead.Email = readValueAsResults.primaryemail;
                    lead.Alternate_Email__c = readValueAsResults.alternateemail;
                    if(readValueAsResults.street <> null){
                        lead.Street = readValueAsResults.street.substring(0, Math.min(readValueAsResults.street.length(), 255));    
                    }
                    lead.State = readValueAsResults.state;
                    lead.City = readValueAsResults.city;
                    lead.Country = readValueAsResults.country;
                    lead.Parent_Name__c = readValueAsResults.parentname;
                    lead.MobilePhone = readValueAsResults.mobile;
                    lead.Registration_Date__c = readValueAsResults.registereddate;
                    if(readValueAsResults.appointmentschedule != NULL )
                    {
                        lead.Appointment_Schedule__c = (readValueAsResults.appointmentschedule); 
                    }
                    if(readValueAsResults.appointmentcomments != NULL )
                    {
                        lead.Appointment_Comments__c = readValueAsResults.appointmentcomments; 
                    }
                    
                    lead.Grade__c = readValueAsResults.grade;
                    lead.Gender__c = readValueAsResults.gender;
                    lead.Credit__c  = readValueAsResults.credit;
                    lead.Timezone__c = readValueAsResults.timezone;
                    lead.Status = mapOfStatus.get(readValueAsResults.status).Status_Value__c;
                    lead.Id__c = readValueAsResults.id;
                    lead.Student_Id__c = readValueAsResults.studentid;
                    lead.Campaign_Source__c = readValueAsResults.campaignsource;
                    lead.Campaign_Medium__c = readValueAsResults.campaignmedium;
                    lead.Campaign_Name__c = readValueAsResults.campaignname;
                    lead.Campaign_Content__c = readValueAsResults.campaigncontent;
                    lead.Campaign_Term__c = readValueAsResults.campaignterm;
                    lead.Campaign_Creative__c = readValueAsResults.campaigncreative;
                    lead.Language__c = readValueAsResults.language;
                    lead.Page__c = readValueAsResults.page;
                    lead.Campaign_Id__c = readValueAsResults.campaignid;
                    lead.Adset_Id__c = readValueAsResults.adsetid;
                    lead.Ad_Id__c = readValueAsResults.adid;
                    lead.Affiliate_Name__c = readValueAsResults.affiliatename;
                    lead.List_Name__c = readValueAsResults.listname;
                    lead.Location__c = readValueAsResults.location;
                    lead.Match_Type__c = readValueAsResults.matchtype;
                    lead.Device__c = readValueAsResults.device;
                    lead.REF_Type__c = readValueAsResults.reftype;
                    lead.REF_Description__c = readValueAsResults.refdescription;
                    lead.Total_Discount__c = readValueAsResults.totaldiscount;      
                    lead.SalesRef__c = readValueAsResults.salesRef; 
                    lead.course_short_name__c = readValueAsResults.course_short_name;
                    lead.AdditionalContactNo__c = readvalueAsResults.additionalContactNo;
                    lead.Subscription_Flag__c = readValueAsresults.subscriptionflag;
                    lead.Additional_Email__c = readValueAsresults.additionalEmailId;
                    lead.LeadId__c = readValueAsresults.LeadId != null ? readValueAsresults.LeadId : '';  
                    
                    if(readValueAsresults.ReferralCustomer != NULL){
                        lead.Referral_Customer__c = readValueAsresults.ReferralCustomer; // populating referral customer if provided
                        lead.LeadSource = system.Label.LeadSourceValueStudentReferral; //if lead have referral customer then making lead source as student referral
                    }
                    
                    if(readValueAsresults.ReferralManager != NULL){
                        lead.Referral_Manager__c = readValueAsresults.ReferralManager; //populating referral manager if provided
                    }
                    
                    
                    
                    if(mapOfStatus.get(readValueAsResults.status).Target_Object__c == null)
                    {
                        lead.Do_Not_Disturb__c =  true;
                    }else{
                        lead.Do_Not_Disturb__c =  false;
                    }
                    insert lead;
                    
                    System.debug('type::'+lead.Lead_Type__c);
                }
                if(!lstAccount.isEmpty() && (readValueAsResults.status == '1' || readValueAsResults.status == '2' || readValueAsResults.status == '3'))     //If Student found, Update student
                {
                    Account account = new Account();
                    account.Id = lstAccount[0].Id;
                    account.FirstName = readValueAsResults.firstname;
                    account.Alternate_Email__c = readValueAsResults.alternateemail;
                    account.LastName = readValueAsResults.lastname;
                    account.PersonMobilePhone = readValueAsResults.mobile;
                    account.PersonEmail = readValueAsResults.primaryemail;
                    account.Credit__c = readValueAsResults.credit;
                    account.Parent_Name__c = readValueAsResults.parentname;
                    if(readValueAsResults.street <> null){
                        account.BillingStreet = readValueAsResults.street.substring(0, Math.min(readValueAsResults.street.length(), 255));    
                    }
                    account.BillingState = readValueAsResults.state;
                    account.BillingCity = readValueAsResults.city;
                    account.BillingCountry = readValueAsResults.country;
                    account.Registered_Date__c = readValueAsResults.registereddate;
                    account.Grade__c = readValueAsResults.grade;
                    account.Gender__c = readValueAsResults.gender;
                    account.Time_Zone__c = readValueAsResults.timezone;
                    account.Id__c = readValueAsResults.id;
                    account.Student_Id__c = readValueAsResults.studentid;
                    account.Campaign_Source__c = readValueAsResults.campaignsource;
                    account.Campaign_Medium__c = readValueAsResults.campaignmedium;
                    account.Campaign_Name__c = readValueAsResults.campaignname;
                    account.Campaign_Content__c = readValueAsResults.campaigncontent;
                    account.Campaign_Term__c = readValueAsResults.campaignterm;
                    account.Campaign_Creative__c = readValueAsResults.campaigncreative;
                    account.Language__c = readValueAsResults.language;
                    account.Page__c = readValueAsResults.page;
                    account.Campaign_Id__c = readValueAsResults.campaignid;
                    account.Adset_Id__c = readValueAsResults.adsetid;
                    account.Ad_Id__c = readValueAsResults.adid;
                    account.Affiliate_Name__c = readValueAsResults.affiliatename;
                    account.List_Name__c = readValueAsResults.listname;
                    account.Location__c = readValueAsResults.location;
                    account.Match_Type__c = readValueAsResults.matchtype;
                    account.Device__c = readValueAsResults.device;
                    account.REF_Type__c = readValueAsResults.reftype;
                    account.REF_Description__c = readValueAsResults.refdescription;
                    account.Total_Discount__c = readValueAsResults.totaldiscount; 
                    
                    account.SalesRef__c = readValueAsResults.salesRef;  
                    account.course_short_name__c = readValueAsResults.course_short_name;
                    account.AdditionalContactNo__c = readValueAsResults.additionalContactNo;    
                    account.Subscription_Flag__c = readValueAsresults.subscriptionflag;
                    account.Additional_Email__c = readValueAsresults.additionalEmailId;
                    if(readValueAsresults.batchid != null && String.isNotBlank(readValueAsresults.batchid))
                    {
                        if(readValueAsresults.batchid.equalsIgnoreCase('Null'))
                        {
                            account.Batch_Id__c = null;
                        }
                        else {
                            account.Batch_Id__c = readValueAsresults.batchid;
                        }
                    }
                    if(readValueAsresults.batchstartdate != NULL) {
                        account.Batch_Start_Date__c = readValueAsresults.batchstartdate; //populating BatchStartDate if provided
                    }
                    if(readValueAsresults.batchtype != null && String.isNotBlank(readValueAsresults.batchtype))
                    {
                        account.Batch_Type__c = readValueAsresults.batchtype;
                    }
                    if(lstAccount[0].PersonEmail == readValueAsResults.primaryemail){
                        
                        account.Status__c = mapOfStatus.get(readValueAsResults.status).Status_Value__c;
                        
                        if(mapOfStatus.get(readValueAsResults.status).Target_Object__c == null)
                        {
                            account.Do_Not_Disturb__c =   true;
                        }else{
                            account.Do_Not_Disturb__c =  false;
                        }
                        
                    }else{
                        //  System.debug('Already Student Exist');
                    } 
                    
                    update account;
                    
                    //Else, insert student
                }else if(lstAccount.isEmpty() && (readValueAsResults.status == '1' || readValueAsResults.status == '2' || readValueAsResults.status == '3')){
                    Account account = new Account();
                    account.FirstName = readValueAsResults.firstname;
                    account.Alternate_Email__c = readValueAsResults.alternateemail;
                    account.LastName = readValueAsResults.lastname;
                    account.PersonMobilePhone = readValueAsResults.mobile;
                    account.PersonEmail = readValueAsResults.primaryemail;
                    account.Credit__c = readValueAsResults.credit;
                    account.Parent_Name__c = readValueAsResults.parentname;
                    if(readValueAsResults.street <> null){
                        account.BillingStreet = readValueAsResults.street.substring(0, Math.min(readValueAsResults.street.length(), 255));    
                    }
                    account.BillingState = readValueAsResults.state;
                    account.BillingCity = readValueAsResults.city;
                    account.BillingCountry = readValueAsResults.country;
                    account.Registered_Date__c = readValueAsResults.registereddate;
                    account.Grade__c = readValueAsResults.grade;
                    account.Gender__c = readValueAsResults.gender;
                    account.Time_Zone__c = readValueAsResults.timezone;
                    account.Id__c = readValueAsResults.id;
                    account.Student_Id__c = readValueAsResults.studentid;
                    account.Campaign_Source__c = readValueAsResults.campaignsource;
                    account.Campaign_Medium__c = readValueAsResults.campaignmedium;
                    account.Campaign_Name__c = readValueAsResults.campaignname;
                    account.Campaign_Content__c = readValueAsResults.campaigncontent;
                    account.Campaign_Term__c = readValueAsResults.campaignterm;
                    account.Campaign_Creative__c = readValueAsResults.campaigncreative;
                    account.Language__c = readValueAsResults.language;
                    account.Page__c = readValueAsResults.page;
                    account.Campaign_Id__c = readValueAsResults.campaignid;
                    account.Adset_Id__c = readValueAsResults.adsetid;
                    account.Ad_Id__c = readValueAsResults.adid;
                    account.Affiliate_Name__c = readValueAsResults.affiliatename;
                    account.List_Name__c = readValueAsResults.listname;
                    account.Location__c = readValueAsResults.location;
                    account.Match_Type__c = readValueAsResults.matchtype;
                    account.Device__c = readValueAsResults.device;
                    account.REF_Type__c = readValueAsResults.reftype;
                    account.REF_Description__c = readValueAsResults.refdescription;
                    account.Total_Discount__c = readValueAsResults.totaldiscount;    
                    
                    account.SalesRef__c = readValueAsResults.salesRef;
                    account.course_short_name__c = readValueAsResults.course_short_name;
                    account.AdditionalContactNo__c = readValueAsResults.additionalContactNo; 
                    account.Subscription_Flag__c = readValueAsresults.subscriptionflag;
                    account.Additional_Email__c = readValueAsresults.additionalEmailId;
                    account.Status__c = mapOfStatus.get(readValueAsResults.status).Status_Value__c;
                     if(readValueAsresults.batchid != null && String.isNotBlank(readValueAsresults.batchid))
                    {
                        if(readValueAsresults.batchid.equalsIgnoreCase('Null'))
                        {
                            account.Batch_Id__c = null;
                        }
                        else {
                            account.Batch_Id__c = readValueAsresults.batchid;
                        }
                    }
                    if(readValueAsresults.batchstartdate != NULL) {
                        account.Batch_Start_Date__c = readValueAsresults.batchstartdate; //populating BatchStartDate if provided
                    }
                    if(readValueAsresults.batchtype != null && String.isNotBlank(readValueAsresults.batchtype))
                    {
                        account.Batch_Type__c = readValueAsresults.batchtype;
                    }
                    if(mapOfStatus.get(readValueAsResults.status).Target_Object__c == null)
                    {
                        account.Do_Not_Disturb__c =   true;
                    }else{
                        account.Do_Not_Disturb__c =  false;
                    }
                    
                    
                    insert account;
                    //           System.debug('account::'+account);
                }
                
            }
        }
        
        catch(Exception e){
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
            String compName = 'WHJ_Lead_API';
            String compType = 'REST API Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();  
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
        }
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
        // public String error;
        // public Boolean success;
        public String error_Code, error_message;
        public ChildRecord( String errorCode, string message) {
            // this.error = error;
            this.error_Code = errorCode;
            this.error_message = message;
        }
    }
    
    private static Lead getLead(WHJ_LeadParser leadParser) {
        
        Map<String, WhJr_Lead_Status_Mapping__mdt> mapOfStatus = new Map<String, WhJr_Lead_Status_Mapping__mdt>();
        for(WhJr_Lead_Status_Mapping__mdt mapping: [select id, MasterLabel,Status_Value__c, Target_Object__c 
                                                    from WhJr_Lead_Status_Mapping__mdt])
        {
            mapOfStatus.put(mapping.MasterLabel, mapping);
        }
        
        List<Lead> lstLead = [Select id, IsConverted, Email from Lead where LeadId__c =:leadParser.LeadId ];
        Lead lead = new Lead();
        
        lead.FirstName =   leadParser.firstname != null ? leadParser.firstname : ''; 
        if(leadParser.lastname != null && String.isNotBlank(leadParser.lastname)) {
            lead.LastName = leadParser.lastname;
        }else if(leadParser.parentname != null && String.isNotBlank(leadParser.parentname)) {
            lead.LastName = leadParser.parentname;
        }else{
            lead.LastName = 'NA'; 
        }
        lead.Email =   leadParser.primaryemail != null ? leadParser.primaryemail : ''; 
        lead.Alternate_Email__c = leadParser.alternateemail != null ? leadParser.alternateemail : ''; 
        lead.State = leadParser.state != null ? leadParser.state : ''; 
        lead.City = leadParser.city != null ? leadParser.city : ''; 
        lead.Country = leadParser.country != null ? leadParser.country : ''; 
        lead.Parent_Name__c = leadParser.parentname != null ? leadParser.parentname : ''; 
        lead.MobilePhone = leadParser.mobile != null ? leadParser.mobile : ''; 
        lead.Registration_Date__c = leadParser.registereddate != null ? leadParser.registereddate : null ; 
        lead.Grade__c = leadParser.grade != null ? leadParser.grade : ''; 
        lead.Gender__c = leadParser.gender != null ? leadParser.gender : ''; 
        lead.Credit__c  = leadParser.credit != null ? leadParser.credit : null ; 
        lead.Timezone__c = leadParser.timezone != null ? leadParser.timezone : ''; 
        lead.Street = leadParser.street != null ?  leadParser.street.substring(0, Math.min(leadParser.street.length(), 255)) : ''; 
        lead.Appointment_Schedule__c = leadParser.appointmentschedule != null ? leadParser.appointmentschedule : null ; 
        lead.Appointment_Comments__c = leadParser.appointmentcomments != null ? leadParser.appointmentcomments : ''; 
        lead.Status = leadParser.status != null ? mapOfStatus.get(leadParser.status).Status_Value__c : ''; 
        lead.Id__c = leadParser.id != null ? leadParser.id : ''; 
        lead.Student_Id__c = leadParser.studentid != null ? leadParser.studentid : ''; 
        lead.Campaign_Source__c = leadParser.campaignsource != null ? leadParser.campaignsource : ''; 
        lead.Campaign_Medium__c = leadParser.campaignmedium != null ? leadParser.campaignmedium : ''; 
        lead.Campaign_Name__c = leadParser.campaignname != null ? leadParser.campaignname : ''; 
        lead.Campaign_Content__c = leadParser.campaigncontent != null ? leadParser.campaigncontent : ''; 
        lead.Campaign_Term__c = leadParser.campaignterm != null ? leadParser.campaignterm : ''; 
        lead.Campaign_Creative__c = leadParser.campaigncreative != null ? leadParser.campaigncreative : '';  
        lead.Language__c = leadParser.language != null ? leadParser.language : '';  
        lead.Page__c = leadParser.page != null ? leadParser.page : '';  
        lead.Campaign_Id__c = leadParser.campaignid != null ? leadParser.campaignid : '';  
        lead.Adset_Id__c = leadParser.adsetid != null ? leadParser.adsetid : '';  
        lead.Ad_Id__c = leadParser.adid != null ? leadParser.adid : '';  
        lead.Affiliate_Name__c = leadParser.affiliatename != null ? leadParser.affiliatename : '';  
        lead.List_Name__c = leadParser.listname != null ? leadParser.listname : '';  
        lead.Location__c = leadParser.location != null ? leadParser.location : '';  
        lead.Match_Type__c = leadParser.matchtype != null ? leadParser.matchtype : '';  
        lead.Device__c = leadParser.device != null ? leadParser.device : '';  
        lead.REF_Type__c = leadParser.reftype != null ? leadParser.reftype : '';  
        lead.REF_Description__c = leadParser.refdescription != null ? leadParser.refdescription : '';  
        lead.Total_Discount__c = leadParser.totaldiscount != null ? leadParser.totaldiscount : null ;  
        lead.SalesRef__c = leadParser.salesRef != null ? leadParser.salesRef : '';  
        lead.course_short_name__c = leadParser.course_short_name != null ? leadParser.course_short_name : '';  
        lead.AdditionalContactNo__c = leadParser.additionalContactNo != null ? leadParser.additionalContactNo : '';  
        lead.Subscription_Flag__c = leadParser.subscriptionflag;  
        lead.Additional_Email__c = leadParser.additionalEmailId != null ? leadParser.additionalEmailId : '';  
        lead.Lead_Type__c = leadParser.LeadType != null ? leadParser.LeadType : '';  
        lead.LeadId__c = leadParser.LeadId != null ? leadParser.LeadId : '';  
        lead.Registration_Link__c = leadParser.RegistrationLink != null ? leadParser.RegistrationLink : '';  
        if(leadParser.ReferralCustomer != NULL){
            lead.Referral_Customer__c = leadParser.ReferralCustomer; // populating referral customer if provided
            lead.LeadSource = system.Label.LeadSourceValueStudentReferral; //if lead have referral customer then making lead source as student referral
        }
        
        if(leadParser.ReferralManager != NULL){
            lead.Referral_Manager__c = leadParser.ReferralManager; //populating referral manager if provided
        }
        
        if(mapOfStatus.get(leadParser.status).Target_Object__c == null){
            lead.Do_Not_Disturb__c =  true;
        }else{
            lead.Do_Not_Disturb__c =  false;
        }
        if(!lstLead.isEmpty()){ // Update existing lead with matching leadid
            lead.Id = lstLead[0].Id;
            update lead;
        }else{  // else create lead
            insert lead;
        }
        
        return lead;
    }
    
    
}