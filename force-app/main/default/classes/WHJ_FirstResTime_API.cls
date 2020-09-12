/*White Hat Junior FirstResTime API REST Class 
*Created By: HGUGHANGE
*Release No: 3
*Created Date: 27/02/2020
*Purpose: This Apex REST API class is to stamp first
*         responce time of web chat agent on related case and chat transcript.
*/ 
@RestResource(urlMapping='/FirstResponseTime')
global class WHJ_FirstResTime_API {
    @HttpPut
    global static Void getFRT() 
    {
        String sessionkey = '';
        String reqBody = '';
        
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            System.debug('reqBody::'+reqBody);
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
            WHJ_FirstResTime_API_Parser parsedData = WHJ_FirstResTime_API_Parser.parse(reqBody);
            system.debug('parsedData  :: ' + parsedData);
            //sessionkey = parsedData.sessionkey;
            Set<Id> setofcaseId = new Set<Id>();
            Set<Id> setoftranscriptId = new Set<Id>();

            
            List<LiveChatTranscript> lstlct =[Select Id , name,caseid,Status,ChatKey,Createddate,First_Response_Time__c,Chat_FRT_Duration__c from LiveChatTranscript where Status = 'InProgress'
                                              AND ChatKey =:parsedData.sessionkey ORDER BY Createddate DESC NULLS LAST];
            
            if(!lstlct.isEmpty()){
                sessionkey = lstlct[0].Name;
                List<Case> lstCase = [Select Id,First_Response_Time__c,Chat_FRT_Duration__c from Case where Id =: lstlct[0].caseid];
                //System.debug('lstCase before update::'+lstCase);
                if(!lstCase.isEmpty()){
                        lstCase[0].First_Response_Time__c = parsedData.firstresponsetime;    
						lstCase[0].Chat_FRT_Duration__c = parsedData.frtduration;                        
                        
                    	lstlct[0].First_Response_Time__c = parsedData.firstresponsetime;
                    	lstlct[0].Chat_FRT_Duration__c = parsedData.frtduration;
                }
                update lstCase;
            }            
            update lstlct;

            
        }catch(Exception e){
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));
            String compName = 'WHJ_FirstResTime_API';
            String compType = 'REST API Class';
            String recRef = 'Chat Transcript Name : '+sessionkey;
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