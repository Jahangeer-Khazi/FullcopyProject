global class WHJ_AccountTriggerHandlerChaining {
    public static void handleBulkUpdate(List<Account> lstAccountUpdate,Map<Id, Account> lstOldAccount){
    Set<String> lstAccIds = new Set<String>();
    String email ;
        try{
        //Set<String> lstAccIds = new Set<String>();
        // String email ;
        if(lstAccountUpdate.size()>0){
        	for(Account acc : lstAccountUpdate){
                if(lstOldAccount!=null && lstOldAccount.get(acc.Id).ownerId != acc.OwnerId && acc.Status__c == 'Active'){
                    lstAccIds.add(acc.id);
                }
        	}
            List<Account> changedOwnerRecords = [Select Id, Owner.Email, PersonEmail from Account where Id IN:lstAccIds FOR UPDATE];
            List<String> personEmailList = new List<String>();
            system.debug('Number of owner ids change in Bulk:'+changedOwnerRecords.size());
            system.debug(' changedOwnerRecords --- ' + changedOwnerRecords);
            List<wrapStudentData> wrapList = new List<wrapStudentData>();
            for(Account account : changedOwnerRecords){
                //List<wrapStudentData> wrapList = new List<wrapStudentData>();
                email = account.PersonEmail;
                //Wrapper Class instance
                wrapStudentData wr = new wrapStudentData();
                wr.email = account.PersonEmail;
                wr.rmEmail = account.Owner.Email;
                System.debug('Email:'+ wr.email);
                System.debug('RM Email:'+wr.rmEmail);
                wrapList.add(wr);
                System.debug('JSON.serialize(wrapList)::'+JSON.serialize(wrapList));
                personEmailList.add(account.PersonEmail);
                //WHJ_AccountTriggerHandlerChaining.SendDataToZendesk(JSON.serialize(wrapList),account.PersonEmail);
               
            }
            System.debug('Wrapper size:'+wrapList.size());
            System.debug('Wrapper List:'+wrapList);
            if(wrapList.size()>0)
            {
               WHJ_AccountTriggerHandlerChaining.SendDataToZendesk(JSON.serialize(wrapList),personEmailList);

            }
        }
            
    }catch(Exception e){
         String compName = 'WHJ_AccountTriggerHandler';
         String compType = 'Apex Handler';
         String recRef = email;
         String err = e.getMessage()  + e.getStackTraceString();    
         String req = '';    
         WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);
    }
        
    }
     @future(callout=true)
     public static void SendDataToZendesk(String getData,List<String> recEmail) {
            Integer i = 0;
        	String email = recEmail[i];
        	String reqBody = '';
        	System.debug('Send Data to Zendesk:'+email);
        	System.debug('Get Data in Zendesk method:'+getData);
        
        	//Post wrapper class data to webhook url
        	//Savepoint sp = Database.setSavepoint();
        
        	Http http = new Http();
        	HttpRequest request = new HttpRequest();
        	request.setEndpoint(System.Label.Zendesk_Endpoint);
        	request.setMethod('POST');
        	request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        	//request.setHeader( 'Authorization', 'Bearer ' + System.Label.token );
        	request.setBody(getData);
        	HttpResponse response = new HttpResponse();    
        	if(!test.isRunningTest()){
            	response = http.send(request);
                if(response.getStatusCode()==200){
                    i=i+1;
                    System.debug('Response generate Message:'+response.getStatus());
				}
            	
        	}else{
            	response.setStatusCode(201);
        	}        
        	if (response.getStatusCode() != 200) {
            	String compName = 'WHJ_AccountTriggerHandler';
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
    
     public class wrapStudentData {
        public String email {get; set;}
        public String rmEmail {get; set;}
        
    }
}