public class WHJ_ContactHandlerController {
    
    public static void SendTeacherDisposition(List<Contact> lstContact, Map<Id, Contact> mapContactOld) {
        String email = '';
        String reqBody = '';
        try{
            set<ID> SetOfIds = new set<ID>();
            
            for(Contact con : lstContact)
            {
             if((mapContactOld.get(con.id).Stages__c <> con.Stages__c )
                && (con.Stages__c == 'Selected'  ||  con.Stages__c == 'Rejected' || con.Stages__c == 'WithHeld' || con.Stages__c == 'NoShow'))
             {
              SetOfIds.add(con.LastModifiedById);
             }
            }
            
            Map<Id,User>mapUsr = new Map<Id,User>([select id,EmployeeId__c from User where Id IN: SetOfIds]);
            
            if(!SetOfIds.isEmpty())//checking triggering  contacts is null
            {
                for(Contact cont : lstContact)//loop all triggering accounts
                {
                 JSONGenerator gen = JSON.createGenerator(true);    
                 gen.writeStartObject();      
                 gen.writeStringField('status',cont.Stages__c );
                 gen.writeStringField('comments',cont.Comments_If_Selected_Rejected__c);
                 if(mapUsr.get(cont.LastModifiedById).EmployeeId__c != null)
                     gen.writeStringField('recruiterId',mapUsr.get(cont.LastModifiedById).EmployeeId__c);
                 else
                     gen.writeStringField('recruiterId','No Recruiter ID');
                 gen.writeEndObject();    
                 
                 String jsonS = gen.getAsString();
                    system.debug('############jsonS'+jsonS);
                 
                 WHJ_ContactHandlerController.SendData(jsonS,email,cont.Teacher_Id__c);
                 
                }    
            }       
        }catch(Exception e) {
            String compName = 'WHJ_ContactHandlerController';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);            
        }
    }
    
    @future(callout=true)
    public static void SendData(String getData,String emailrec , String TeacherId) {
        System.debug('getData::'+getData);
        String email = emailrec;
        String reqBody = '';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://join-dev.whitehatjr.com/api/V1/salesforce/candidates/'+TeacherId+'/disposition');
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader( 'Authorization', 'Bearer ' + System.Label.TokenForTeacherDisposition );
        // Set the body as a JSON object
        request.setBody(getData);
        HttpResponse response = new HttpResponse();
        if(!test.isRunningTest()) {
            response = http.send(request);
        }else {
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
}