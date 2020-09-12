@RestResource(urlMapping='/TeacherRecruitmentAPI')
global class WHJ_TeacherRecruitmentAPI {
    @HttpPut
    global static Void createTeacherData() 
    {
        
        String email = '';
        String reqBody = '';
        try{
            // RestRequest Method to get JSON Request
            RestRequest request = RestContext.request;
            // Convert JSON data blob to String
            reqBody = request.requestBody.toString(); 
            system.debug('reqBody  :: '+ reqBody);
            
            
            
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));                
            
            
            // Parser Class instance to Parse JSON Data
            WHJ_TeacherRecruitmentAPIParser parsedData = WHJ_TeacherRecruitmentAPIParser.parse(reqBody);
            system.debug('parsedData  :: ' + parsedData);
            Id RecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(system.Label.RecordTypeTeacherRecruitment).getRecordTypeId();
            if(parsedData.Email != null)
            {
                email = parsedData.Email;
            }
            Id OwnerId = null;
            String MailId = null;
            if(parsedData.RecruiterID != null)
            {
                List<User> lstUser1 = [Select Id,EmployeeId__c,Email From User Where EmployeeId__c =:parsedData.RecruiterID ];
                List<User> lstUser2 = [Select Id , Email From User Where UserRole.Name =:system.label.Role_Teacher_Recruitment_Team_Leader];
                if(!lstUser1.isEmpty()){
                    OwnerId =lstUser1[0].Id;
                    MailId = lstUser1[0].Email;
                }
                else{
                    OwnerId =lstUser2[0].Id;
                    MailId = lstUser2[0].Email;
                }
                
            }
            
            // Select the Contact record for the email address in the request
            if(parsedData.TeacherId != null)
            {
                
                List<Contact> lstContact = [SELECT Id,Name,Email,Language__c,Region__c,Teacher_Id__c FROM Contact WHERE Teacher_Id__c =: parsedData.TeacherId];            
                
                // If Contact found, Update same Contact
                if(!lstContact.isEmpty()){
                    Contact contact = new Contact();
                    contact.Id = lstContact[0].Id;
                    if(parsedData.FirstName != null)
                    {
                        contact.FirstName = parsedData.FirstName;    
                    }
                    
                    if(parsedData.LastName != null)
                    {
                        contact.LastName = parsedData.LastName;
                    }
                    
                    if(parsedData.Email != null)
                    {
                        contact.Email = parsedData.Email;
                    }
                    
                    if(parsedData.Mobile != null)
                    {
                        contact.MobilePhone = parsedData.Mobile;  
                    }
                    
                    if(parsedData.DateOfRegistration != null)
                    {
                        contact.Date_of_registration__c = parsedData.DateOfRegistration;
                    }
                    
                    if(MailId != null)
                    {
                        contact.Phone_Recruiter_Email_Id__c = MailId;  
                    }
                    if(OwnerId != null)
                    {
                        contact.OwnerId = OwnerId;
                    }
                    contact.Type__c = 'Potential Teacher Recruitment';              
                    contact.RecordTypeId = RecType;
                    contact.Teacher_Id__c = parsedData.TeacherId;
                    contact.Stages__c = 'New';
                    contact.Comments_If_Selected_Rejected__c = null;
                    Update contact;
                    //Else , create Contact
                }else{
                    if(parsedData.RecruiterID != null)
                    {
                        Contact contact = new Contact();
                        contact.FirstName = parsedData.FirstName;
                        contact.LastName = parsedData.LastName;
                        contact.Email = parsedData.Email;
                        contact.MobilePhone = parsedData.Mobile;
                        contact.Date_of_registration__c = parsedData.DateOfRegistration;
                        contact.Phone_Recruiter_Email_Id__c = MailId;  
                        contact.OwnerId = OwnerId;
                        contact.Type__c = 'Potential Teacher Recruitment';
                        contact.RecordTypeId = RecType;
                        contact.Teacher_Id__c = parsedData.TeacherId;
                        contact.Stages__c = 'New';
                        Insert contact;
                    }
                    else
                    {
                        CalloutException e = new CalloutException();
                        e.setMessage('Recruiter Id : Required Field');
                        throw e;  
                    }
                }
            }
            else
            {
                CalloutException e = new CalloutException();
                e.setMessage('Teacher Id : Required Field');
                throw e;
            }
        }catch(Exception e){
            System.debug('Exception::'+e);
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage())); 
            String compName = 'WHJ_TeacherRecruitment_API';
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
        public String error_Code, error_message;
        public ChildRecord( String errorCode, string message) {
            this.error_Code = errorCode;
            this.error_message = message;
        }
    }
    
}