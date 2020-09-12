/*White Hat Junior CASE API REST Class 
*Created By: Mohit
*Release No: 1
*Created Date: 24/08/2020
*Purpose: This Apex REST API class is to creates a Case Records for Teacher Leaving & Teacher Alert module
*/ 

@RestResource(urlMapping='/Notification_Unsubscription/*')
global class WHJ_Unsubscription_API {

    @HttpPost
    global static void notificationSubscripe(){
        String email='';
        String reqBody = '';
        ParentRecord parent = new ParentRecord();
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            System.debug('@@@ reqBody '+reqBody);
            
            //Type resultType = Type.forName('WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe');
            //WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe readValueAsResults = (WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe)JSON.createParser(reqBody).readValueAs(resultType);
            WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe readValueAsResults = (WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe)JSON.deserialize(reqBody,WHJ_Unsubscription_API.WHJ_Notification_Unsubscribe.class);
            map<String,String> emailvsFlag_map = new map<String,String>();
            map<String,String> phonevsFlag_map = new map<String,String>();
            for(Unsubscribe_parser up : readValueAsResults.unsubscriber_lst){
                if(String.isNotBlank(up.email)){
                	emailvsFlag_map.put(up.email,up.flag);    
                }
                if(String.isNotBlank(up.phone)){
                	phonevsFlag_map.put(up.phone,up.flag);
                }
            }
            List<Account> accupdate_lst = new List<Account>();
            List<Opportunity> oppUpdate_lst = new List<Opportunity>();
            List<Lead> leadUpdate_lst = new List<Lead>();
            for(Account acc :[select Id,PersonEmail,Phone from Account where PersonEmail IN: emailvsFlag_map.keySet() OR  Phone IN: phonevsFlag_map.keySet() limit 2000]){
                if(emailvsFlag_map.get(acc.PersonEmail) == 'True' || phonevsFlag_map.get(acc.Phone) == 'True'){
                    acc.Notification_Unsubscription__c = 'True';
                }else{
                    acc.Notification_Unsubscription__c = 'False';
                }
                accupdate_lst.add(acc);
            }
            for(Opportunity opp : [select id,Email__c,MobileNumber__c from Opportunity where Email__c IN: emailvsFlag_map.keySet() OR MobileNumber__c IN: phonevsFlag_map.keySet() limit 2000]){
                if(emailvsFlag_map.get(opp.Email__c) == 'True' || phonevsFlag_map.get(opp.MobileNumber__c) == 'True'){
                    opp.Notification_Unsubscription__c = 'True';
                }else{
                    opp.Notification_Unsubscription__c = 'False';
                }
                oppUpdate_lst.add(opp);
            }
            for(Lead ld : [select id,Email,Phone from Lead where Email IN: emailvsFlag_map.keySet() OR Phone IN: phonevsFlag_map.keySet() limit 2000]){
                if(emailvsFlag_map.get(ld.Email) == 'True' || phonevsFlag_map.get(ld.Phone) == 'True'){
                    ld.Notification_Unsubscription__c = 'True';
                }else{
                    ld.Notification_Unsubscription__c = 'False';
                }
                leadUpdate_lst.add(ld);
            }
            System.debug('@@ accupdate_lst '+accupdate_lst);
            System.debug('@@ oppUpdate_lst '+oppUpdate_lst);
            System.debug('@@ leadUpdate_lst '+leadUpdate_lst);
            if(!accupdate_lst.isEmpty()){
                update accupdate_lst;
                parent.error.add(new ChildRecord( '200','Account Records have been Unsubscripe for Notification.' ));       
            }else{
                parent.error.add(new ChildRecord( '200','There is no Account Records have been Unsubscripe for Notification.' ));       
            }
            if(!oppUpdate_lst.isEmpty()){
                update oppUpdate_lst;
                parent.error.add(new ChildRecord( '200','Opportunity Records have been Unsubscripe for Notification.' ));       
            }else{
                parent.error.add(new ChildRecord( '200','There is no Opportunity Records have been Unsubscripe for Notification.' ));       
            }
            if(!leadUpdate_lst.isEmpty()){
                update leadUpdate_lst;
                parent.error.add(new ChildRecord( '200','Lead Records have been Unsubscripe for Notification.' ));       
            }else{
                parent.error.add(new ChildRecord( '200','There is no Lead Records have been Unsubscripe for Notification.' ));       
            }
            parent.success = true;
            
            
        }catch(Exception e){
            RestContext.response.statusCode = 400;
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
            String compName = 'WHJ_Unsubscription_API';
            String compType = 'REST API Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent)); 
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
    public class WHJ_Notification_Unsubscribe{
        public List<Unsubscribe_parser> unsubscriber_lst{get;set;}
    }
    public class Unsubscribe_parser{
        public String email{get;set;}
        public String phone{get;set;}
        public String flag{get;set;}
    }
}