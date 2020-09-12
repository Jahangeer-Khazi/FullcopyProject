public class WHJ_CaseHandlerForZendesk implements Queueable, Database.AllowsCallouts{
	public List<Case> caseListforInsert ;
    public String caseOps;
    
    public WHJ_CaseHandlerForZendesk(List<Case> lstCaseInsert){
        this.caseListforInsert = lstCaseInsert ;
    }
    public WHJ_CaseHandlerForZendesk(List<Case> lstCaseInsert,String caseOps){
        this.caseOps = caseOps;
        this.caseListforInsert = lstCaseInsert;
    }
    public void execute(QueueableContext context) {
        System.debug('context::'+context);
        System.debug('caseListforInsert::'+caseListforInsert);
        String email ;
        try{
            
            
            if(caseListforInsert != null  && caseOps != 'Case_To_Zendesk'){
                //Iteration over Account object to store account ids in set
                for(Case c :caseListforInsert){
                    System.debug('c::'+c);
                    CaseWrapperClass parent = new CaseWrapperClass();
                    parent.ticket.add(new ticket(c.Subject,c.Description,c.Priority,c.Status));
                    System.debug('JSON.serialize(parent)::'+JSON.serialize(parent));
                    String abc = JSON.serialize(parent).remove('[');
                    String data = abc.remove(']');
                    // String abc = data.substring(12,data.length()-2);
                    System.debug('data::'+data);
                    
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint('https://whitehatjr123.zendesk.com/api/v2/tickets.json');
                    request.setMethod('POST');
                    request.setHeader('Content-Type', 'application/json');
                    //request.setHeader( 'Authorization', 'Bearer ' + System.Label.token );
                    request.setBody(data);
                    HttpResponse response = new HttpResponse();
                    if(!test.isRunningTest()){
                        response = http.send(request);
                        System.debug('response::'+response);
                    }else{
                        response.setStatusCode(201);
                    }        
                    if (response.getStatusCode() != 200) {
                        String compName = 'WHJ_CaseHandlerForZendesk';
                        String compType = 'Apex Handler';
                        String recRef = email;
                        String err = response.getStatusCode() + ' ' + response.getStatus();
                        String req = '';    
                        WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
                        System.debug('error -- ' + response.getBody());
                    } else {
                        System.debug('Success-- ' + response.getBody());
                    }
                }    
            }
            // To Send the Case details to the Zendesk.
            if(caseListforInsert != null && caseOps == 'Case_To_Zendesk' && caseListforInsert.size() == 1){
                set<Id> setOfCaseId = new Set<Id>();
                set<Id> set_caseOwnerID = new set<Id>();
                for(case cs : caseListforInsert){
                    setOfCaseId.add(cs.Id);                    
                }
                List<case> lst_Case = new list<case>([select id,casenumber,Account.PersonEmail,AccountId,Account.Parent_Name__c,subject,ownerId,Owner.Email,Category__c,origin,Type,Description,Send_to_Zendesk__c,Comments from case where Id IN: setOfCaseId]);
                for(Case cs : lst_Case){
                    set_caseOwnerID.add(cs.OwnerId);
                }
                map<Id,user> mapOwnerIdvsuser = new map<Id,user>();
                for(user u :[select id,name,email from user where Id In:set_caseOwnerID]){
                    mapOwnerIdvsuser.put(u.Id,u);
                }
                for(Case cs : lst_Case){
                    if(cs.Send_to_Zendesk__c == 'True'){
                        if(String.isNotBlank(cs.Account.PersonEmail) && String.isNotBlank(cs.origin) && String.isNotBlank(cs.Category__c) && String.isNotBlank(cs.Description)){
                            caseToZendesk cs_Zendesk = new caseToZendesk(cs.casenumber,cs.Account.PersonEmail,EncodingUtil.urlEncode(cs.Account.Parent_Name__c, 'UTF-8'),EncodingUtil.urlEncode(cs.subject, 'UTF-8'),EncodingUtil.urlEncode(cs.Description, 'UTF-8'),mapOwnerIdvsuser.get(cs.OwnerId).Email,cs.Category__c,cs.origin,null);
                            //caseToZendesk_data data = new caseToZendesk_data(cs_Zendesk);
                            WHJ_CaseHandlerForZendesk.SendDataToZendesk(JSON.serialize(cs_Zendesk),caseOps,cs.Id);
                        }else{
                            String error_msg='';
                            if(String.isBlank(cs.Account.PersonEmail)){
                                error_msg = 'Parent Email adrress is Blank. For Case number '+cs.casenumber+' and case Id '+cs.Id;
                            }
                            if(String.isBlank(cs.origin)){
                                error_msg += 'Case Origin is Blank. For Case number '+cs.casenumber+' and case Id '+cs.Id;
                            }
                            if(String.isBlank(cs.Category__c)){
                                error_msg += 'Case Type is Blank. For Case number '+cs.casenumber+' and case Id '+cs.Id;
                            }
                            if(String.isBlank(cs.Description)){
                                error_msg += 'Case Details is Blank. For Case number '+cs.casenumber+' and case Id '+cs.Id;
                            }
                            String compName = 'WHJ_CaseHandlerForZendesk';
                            String compType = 'Apex Handler';
                            String recRef = cs.Id;
                            //String err = e.getMessage()  + e.getStackTraceString();    
                            String req = '';    
                            WHJ_ErrorLogHandler.log(compName, compType, error_msg, 400,recRef,req);   
                        }
                    }
                }
            }
        }catch(Exception e){//Exception
            String compName = 'WHJ_CaseHandlerForZendesk';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = '';    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);    
        }
    }
    
    public static void SendDataToZendesk(String getData, String casOps, String csId) {
        System.debug('@@@@  getData '+getData);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        if(casOps == 'Case_To_Zendesk'){
            getData = 'data='+getData;
            request.setEndpoint(System.Label.Case_Zendesk_Endpoint);//For Sending Cases from Salesforce to Zendesk Endpoint.
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded charset=utf-8');
        }
        if(casOps =='Tickets'){
            request.setEndpoint('https://whitehatjr123.zendesk.com/api/v2/tickets.json');            
            request.setHeader('Content-Type', 'application/json');
        }
        request.setMethod('POST');
        //request.setHeader( 'Authorization', 'Bearer ' + System.Label.token );
        request.setBody(getData);
        
        HttpResponse response = new HttpResponse();
        if(!test.isRunningTest()){
            response = http.send(request);
        }else{
            response.setStatusCode(201);
        }        
        if (response.getStatusCode() != 200) {
            String compName = 'WHJ_CaseHandlerForZendesk';
            String compType = 'Apex Handler';
            String recRef = csId;
            String err = response.getStatusCode() + ' ' + response.getStatus();
            String req = '';    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
        } else {
            System.debug('Success-- ' + response.getBody());
            if(casOps == 'Case_To_Zendesk'){
                System.debug('Inside casOps-- ' );
                String res_body = response.getBody();
                try{
                	JSON2ApexZendeskToSF zendesk_response = (JSON2ApexZendeskToSF)JSON.deserialize(res_body, JSON2ApexZendeskToSF.class);    
                    Case cs = new Case();
                    cs.Id = csId;
                    cs.Zendesk_Support_Ticket_ID__c	 = String.valueOf(zendesk_response.ticket.id);
                    update cs;
                }catch(Exception e){
                    System.debug('@@@ Exception'+e);
                }
                
            }
        }
    }
    
    public class CaseWrapperClass {
        public ticket[] ticket;
        public CaseWrapperClass() {
            ticket = new ticket[0];
        }
        /*public String subject , description , priority , status;
        public CaseWrapperClass( String subject, String description,String priority,String status) {
            this.subject = subject;
            this.description = description;
            this.priority = priority;
            this.status = status;
        }*/
        
    }
    
    public class ticket {
        public String subject , description , priority , status;
         public ticket( String subject, String description,String priority,String status) {
             this.subject = subject;
             this.description = description;
             this.priority = priority;
             this.status = status;
        }
    }
    /*public class caseToZendesk_data{
    	public caseToZendesk data;
        public caseToZendesk_data(caseToZendesk data){
            this.data =data;
        }
    }*/
	public class caseToZendesk{
        public String caseNumber;
        public String parentEmail;
        public String parentName;
        public String subject;
        public String comments;
        public String rmEmaiIdId;
        public String issueType;
        public String origin;
        public String contacttype;
        public caseToZendesk(String caseNumber, String parentEmail, String parentName, String subject, String comments,String rmEmaiIdId, String issueType, String origin, String contacttype){
            this.caseNumber = caseNumber;
            this.parentEmail = parentEmail;
            this.parentName = parentName;
            this.subject = subject;
            this.rmEmaiIdId = rmEmaiIdId;
            this.issueType = issueType;
            this.origin = origin;
            this.contacttype = contacttype;
            this.comments = comments;
        }
    }
}