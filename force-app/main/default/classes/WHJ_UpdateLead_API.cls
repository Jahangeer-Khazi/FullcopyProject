/*White Hat Junior Update Lead API REST Class 
*Created By: Rajeev Dubey
*Release No: 1
*Created Date: 11/08/2020
*Purpose: This Apex REST API class is to creates a Lead And Student record
*/ 


@RestResource(urlMapping='/UpdateStudents')
global class WHJ_UpdateLead_API {
    
    @HttpPut
    global static Void updateLead() 
    {
        String email = '';
        String reqBody = '';
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            system.debug('updateLead  :: '+ reqBody);
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
            
            
            
            Type resultType = Type.forName('WHJ_LeadParser');
            WHJ_LeadParser readValueAsResults = (WHJ_LeadParser)JSON.createParser(reqBody).readValueAs(resultType);
            System.debug('==========> createParser().readValueAs() results = ' + readValueAsResults);
            
            Map<String, WhJr_Lead_Status_Mapping__mdt> mapOfStatus = new Map<String, WhJr_Lead_Status_Mapping__mdt>();
            for(WhJr_Lead_Status_Mapping__mdt mapping: [select id, MasterLabel,Status_Value__c, Target_Object__c 
                                                        from WhJr_Lead_Status_Mapping__mdt])
            {
                mapOfStatus.put(mapping.MasterLabel, mapping);
            }
            //get leads based on student id  //limit 1 should not use and change in next phase
            Lead leadData = [SELECT Id, Name from Lead where student_id__c = :readValueAsResults.studentid limit 1];
            
            if(readValueAsResults.status == '12' && leadData != null) {
                system.debug('readValueAsResults.trialbookingdate---  ' + readValueAsResults.trialbookingdate);
                leadData.Trial_Booking_Date_Time__c = readValueAsResults.trialbookingdate;
                leadData.Status = mapOfStatus.get(readValueAsResults.status).Status_Value__c;
                update leadData;
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
            system.debug('errormessage---  ' + e);
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
    

}