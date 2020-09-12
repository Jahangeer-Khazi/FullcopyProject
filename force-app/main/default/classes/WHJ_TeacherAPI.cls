@RestResource(urlMapping='/TeacherAPI')
global class WHJ_TeacherAPI {
    @HttpPut
    global static Void createTeacherData() 
    {
        try{
            // RestRequest Method to get JSON Request
            RestRequest request = RestContext.request;
            // Convert JSON data blob to String
            String reqBody = request.requestBody.toString(); 
            system.debug('reqBody  :: '+ reqBody);
            
            
            
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));                
            
            
            
            
            // Parser Class instance to Parse JSON Data
            WHJ_TeacherAPIParser parsedData = WHJ_TeacherAPIParser.parse(reqBody);
            system.debug('parsedData  :: ' + parsedData);
            
            // Select the Contact record for the email address in the request
            List<Contact> lstContact = [SELECT Id,Name,Email,Language__c,Region__c FROM Contact WHERE Email =: parsedData.email];
            // If Contact found, Update same Contact
            Id OwnerId;
            List<User> lstUser1 = [Select Id From User Where Email =:parsedData.RMemailId ];
            List<User> lstUser2 = [Select Id From User Where UserRole.Name =:system.Label.Role_Teacher_OPS_Leader];
            if(!lstUser1.isEmpty()){
                OwnerId =lstUser1[0].Id;
            }
            else{
                OwnerId =lstUser2[0].Id;
            }
            
            
            
            List<String> parsedValuesLanguage = new List<String>();
            parsedValuesLanguage = parsedData.Language.split(';');
            List<String> pickListLanguage= new List<String>();
            List<String> UpdatedLanguage = new List<String>();
            Schema.DescribeFieldResult fieldResult = Contact.Language__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListLanguage.add(pickListVal.getLabel());
            } 
            
            for (String a : parsedValuesLanguage)
            {
                if(pickListLanguage.contains(a))
                    UpdatedLanguage.add(a);
                else
                    UpdatedLanguage.add('English');
            }
            
            Set<String> TempSet = new Set<String>();
            TempSet.addAll(UpdatedLanguage);
            UpdatedLanguage.clear(); 
            UpdatedLanguage.addAll(TempSet);
            
            String UpdatedLanguageSt = String.join(UpdatedLanguage, ';');
            
            
            
            
            
            
            List<String> parsedValuesRegion = new List<String>();
            parsedValuesRegion = parsedData.Region.split(';');
            List<String> pickListRegion= new List<String>();
            List<String> UpdatedRegion = new List<String>();
            Schema.DescribeFieldResult fieldResult2 = Contact.Region__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            for( Schema.PicklistEntry pickListVal2 : ple2){
                pickListRegion.add(pickListVal2.getLabel());
            } 
            
            for (String a : parsedValuesRegion)
            {
                if(pickListRegion.contains(a))
                    UpdatedRegion.add(a);
                else
                    UpdatedRegion.add('International');
            }
           
            Set<String> TempSet2 = new Set<String>();
            TempSet2.addAll(UpdatedRegion);
            UpdatedRegion.clear(); 
            UpdatedRegion.addAll(TempSet2);
    
            String UpdatedRegionSt = String.join(UpdatedRegion, ';');
            
           
          //  Id RecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Teacher').getRecordTypeId();
            
            
            
            if(!lstContact.isEmpty()){
                Contact contact = new Contact();
                contact.Id = lstContact[0].Id;
                contact.FirstName = parsedData.FirstName;
                contact.LastName = parsedData.LastName;
                contact.Email = parsedData.Email;
                contact.MobilePhone = parsedData.Mobile;
                contact.Type__c = 'Teacher';
                contact.RM_Name__c = parsedData.RMname;
                contact.RM_email_Id__c = parsedData.RMemailId;
                contact.Status__c = parsedData.Status;
                contact.Curriculum_Level__c = parsedData.CurriculumLevel;
                contact.Language__c = UpdatedLanguageSt;
                contact.Region__c = UpdatedRegionSt;
                contact.Date_of_Onboarding__c = parsedData.DateOfOnboarding;
                contact.Induction_Owner__c = parsedData.InductionOwner;                
                contact.OwnerId = OwnerId;
              //  contact.RecordTypeId = RecType;
                Update contact;
                //Else , create Contact
            }else{
                Contact contact = new Contact();
                contact.FirstName = parsedData.FirstName;
                contact.LastName = parsedData.LastName;
                contact.Email = parsedData.Email;
                contact.MobilePhone = parsedData.Mobile;
                contact.Type__c = 'Teacher';
                contact.RM_Name__c = parsedData.RMname;
                contact.RM_email_Id__c = parsedData.RMemailId;
                contact.Status__c = parsedData.Status;
                contact.Region__c = UpdatedRegionSt;
                contact.Curriculum_Level__c = parsedData.CurriculumLevel;
                contact.Language__c = UpdatedLanguageSt;
                contact.Date_of_Onboarding__c = parsedData.DateOfOnboarding;
                contact.Induction_Owner__c = parsedData.InductionOwner;
                contact.OwnerId = OwnerId;
            //    contact.RecordTypeId = RecType;
                Insert contact;
            }
        }catch(Exception e){
            System.debug('Exception::'+e);
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
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