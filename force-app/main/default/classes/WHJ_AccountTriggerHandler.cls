public class WHJ_AccountTriggerHandler implements Queueable, Database.AllowsCallouts{
    public List<Account> accListforUpdate ;
    public Map<Id,Account> mapofOldAccUpdate ; 
    public List<Account> accListforInsert ;
    public WHJ_AccountTriggerHandler(List<Account> lstAccountUpdate, Map<Id, Account> lstOldAccount){
        this.accListforUpdate = lstAccountUpdate ; 
        this.mapofOldAccUpdate = lstOldAccount ;
    }
    
    public WHJ_AccountTriggerHandler(List<Account> lstAccountInsert){
        this.accListforInsert = lstAccountInsert ;
    }
    
    public void execute(QueueableContext context) {
        System.debug('context::'+context);
        String email ;
        //Set of string to store account ids
        Set<String> lstAccIds = new Set<String>();
        Savepoint sp;
        try{
            if(accListforUpdate != null){
                //Iteration over Account object to store account ids in set
                for(Account accUpdate :accListforUpdate){
                    if(mapofOldAccUpdate!= null && mapofOldAccUpdate.get(accUpdate.id).ownerId != accUpdate.OwnerId && accUpdate.Status__c == 'Active') {
                    //if(mapofOldAccUpdate!= null && mapofOldAccUpdate.get(accUpdate.id).ownerId != accUpdate.OwnerId) {
                        lstAccIds.add(accUpdate.Id);
                    }   
                }
                system.debug('in update-- ' + lstAccIds);
            }
            
            if(accListforInsert != null){
                for(Account accInsert :accListforInsert){
                    if(accInsert.Status__c == 'Active') {
                        system.debug('in insert-- ' );
                        lstAccIds.add(accInsert.Id);
                    }   
                }
                system.debug('in insert-- ' + lstAccIds);
            }
            
            List<Account> changedOwnerRecords = [Select Id, Owner.Email, PersonEmail from Account where Id IN:lstAccIds FOR UPDATE];
            system.debug('Number of owner ids change in Bulk:'+changedOwnerRecords.size());
            system.debug(' changedOwnerRecords --- ' + changedOwnerRecords);
            //List<wrapStudentData> wrapList = new List<wrapStudentData>();
            sp = Database.setSavepoint();

            for(Account account : changedOwnerRecords){
                List<wrapStudentData> wrapList = new List<wrapStudentData>();
                email = account.PersonEmail;
                //Wrapper Class instance
                wrapStudentData wr = new wrapStudentData();
                wr.email = account.PersonEmail;
                wr.rmEmail = account.Owner.Email;
                System.debug('Email:'+ wr.email);
                System.debug('RM Email:'+wr.rmEmail);
                wrapList.add(wr);
                System.debug('JSON.serialize(wrapList)::'+JSON.serialize(wrapList));
                WHJ_AccountTriggerHandler.SendDataToZendesk(JSON.serialize(wrapList),account.PersonEmail);
                //Savepoint sp = Database.setSavepoint();
                //System.enqueueJob(new WHJ_AccountTriggerHandler());
                //break;
            }
          /*  if(wrapList.size()>0)
            {
               WHJ_AccountTriggerHandler.SendDataToZendesk(JSON.serialize(wrapList));
  
            }*/
            //System.enqueueJob(new WHJ_AccountTriggerHandlerChaining(accListforUpdate,mapofOldAccUpdate));

        }catch(Exception e){//Exception
            String compName = 'WHJ_AccountTriggerHandler';
            String compType = 'Apex Handler';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = '';    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);
            Database.rollback(sp);
        }
    }
    
    public static void SendDataToZendesk(String getData,String recEmail) {
        String email = recEmail;
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
            	System.debug('Exception generate Message:'+response.getStatus());
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
    
    
    
    
    /*public void execute1(QueueableContext context) {
System.debug('qwertyui');
String email ;
//Set of string to store account ids
Set<String> lstAccIds = new Set<String>();
if(!accListforInsert.isEmpty()){
for(Account accInsert :accListforInsert){
if(accInsert.Status__c == 'Active') {
lstAccIds.add(accInsert.Id);
}   
}
}

List<Account> changedOwnerRecords = [Select Id, Owner.Email, PersonEmail from Account where Id IN:lstAccIds];
List<wrapStudentData> wrapList = new List<wrapStudentData>();
for(Account account : changedOwnerRecords){
email = account.PersonEmail;
//Wrapper Class instance
wrapStudentData wr = new wrapStudentData();
wr.email = account.PersonEmail;
wr.rmEmail = account.Owner.Email;
wrapList.add(wr);
System.debug('JSON.serialize(wrapList)::'+JSON.serialize(wrapList));
//Post wrapper class data to webhook url
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint(System.Label.Zendesk_Endpoint);
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');
//request.setHeader( 'Authorization', 'Bearer ' + System.Label.token );
request.setBody(JSON.serialize(wrapList));
HttpResponse response = new HttpResponse();
if(!test.isRunningTest()){
response = http.send(request);
}else{
response.setStatusCode(201);
}        
if (response.getStatusCode() != 200) {
String compName = 'WHJ_AccountTriggerHandler';
String compType = 'Apex Handler';
String recRef = email;
String err = response.getStatusCode() + ' ' + response.getStatus();
String req = '';    
WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
System.debug('error -- ' + response.getBody());
} else {
System.debug('Success-- ' + response.getBody());
}


break;
}                                           
}

*/
    /* 
//Method to send data over Zendesk portal on after updation on owner
public static void onAfterUpdate(List<Account> lstAccount, Map<Id, Account> lstOldAccount){
String email ;
//Set of string to store account ids
Set<String> lstAccIds = new Set<String>();
try{
//Iteration over Account object to store account ids in set
for(Account acc : lstAccount){
if(lstOldAccount!= null && lstOldAccount.get(acc.id).ownerId != acc.OwnerId) {
lstAccIds.add(acc.Id);
}   
}

List<Account> changedOwnerRecords = [Select Id, Owner.Email, PersonEmail from Account where Id IN:lstAccIds];
List<wrapStudentData> wrapList = new List<wrapStudentData>();
for(Account account : changedOwnerRecords){
email = account.PersonEmail;
//Wrapper Class instance
wrapStudentData wr = new wrapStudentData();
wr.email = account.PersonEmail;
wr.rmEmail = account.Owner.Email;
wrapList.add(wr);

WHJ_AccountTriggerHandler.SendDataToZendesk(JSON.serialize(wrapList),account.PersonEmail);
break;
} 
}catch(Exception e){//Exception
String compName = 'WHJ_AccountTriggerHandler';
String compType = 'Apex Handler';
String recRef = email;
String err = e.getMessage()  + e.getStackTraceString();    
String req = '';    
WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);    
}
}

//Method to send data over Zendesk portal on after student creation
public static void onAfterInsert(List<Account> lstAccount){
String email ;
//Set of string to store account ids
Set<String> lstAccIds = new Set<String>();
try{
//Iteration over Account object to store account ids in set
for(Account acc : lstAccount){
if(acc.Status__c == 'Active') {
lstAccIds.add(acc.Id);
}   
}

List<Account> changedOwnerRecords = [Select Id, Owner.Email, PersonEmail from Account where Id IN:lstAccIds];
List<wrapStudentData> wrapList = new List<wrapStudentData>();
for(Account account : changedOwnerRecords){
email = account.PersonEmail;
//Wrapper Class instance
wrapStudentData wr = new wrapStudentData();
wr.email = account.PersonEmail;
wr.rmEmail = account.Owner.Email;
wrapList.add(wr);

WHJ_AccountTriggerHandler.SendDataToZendesk(JSON.serialize(wrapList),account.PersonEmail);
break;
} 
}catch(Exception e){//Exception
String compName = 'WHJ_AccountTriggerHandler';
String compType = 'Apex Handler';
String recRef = email;
String err = e.getMessage()  + e.getStackTraceString();    
String req = '';    
WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);    
}
}

// send to Zendesk
@future(callout=true)
public static void SendDataToZendesk(String getData,String recEmail) {
String email = recEmail;
String reqBody = '';
//Post wrapper class data to webhook url
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
}*/
    
    //Wrapper Class
    public class wrapStudentData {
        public String email {get; set;}
        public String rmEmail {get; set;}
        
    }
    
    public static void SLAbreach(List<Account> lstAccount, Map<Id, Account> lstOldAccount) {
        /*
        Set<Id> ownerSet = new Set<Id>();
        Set<Id> SetofAccIds = new Set<Id>();
        if(lstAccount != null){
            for(Account acc : lstAccount) {
                if(acc.SendMailSLAbreach__c == true && lstOldAccount.get(acc.id).SendMailSLAbreach__c <> acc.SendMailSLAbreach__c) {
                    System.debug('inn');
                    ownerSet.add(acc.ownerId);       
                    SetofAccIds.add(acc.Id);
                }
            }    
        }
        
        
        Map<Id,User> ownerMap = new Map<Id,User>([select id,Name,email from User where id in: ownerSet]);
        System.debug('ownerMap::'+ownerMap);
        Map<Id,User> ManagerMap = new Map<Id,User>([SELECT  Id,Name,Manager.email,Manager.Manager.email,Manager.Manager.Manager.email FROM User where id in: ownerSet]);
        System.debug('ManagerMap::'+ManagerMap);
        List<Account> lstAcc = [Select Id,Name,OwnerId From Account where Id IN : SetofAccIds ];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(lstAccount != null){
            for(Account account : lstAccount) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{ ManagerMap.get(account.OwnerId).Manager.email, ManagerMap.get(account.OwnerId).Manager.Manager.email , ManagerMap.get(account.OwnerId).Manager.Manager.Manager.email});
            System.Debug('##1'+ManagerMap.get(account.OwnerId).Manager.email);
            System.Debug('##2'+ManagerMap.get(account.OwnerId).Manager.Manager.email);
            System.Debug('##3'+ ManagerMap.get(account.OwnerId).Manager.Manager.Manager.email);
            
            mail.setSubject('SLA Breach for 2 hour calling window');
            String body = 'SLA Breach for '+ ownerMap.get(account.OwnerId).Name +' for Student Name : '+account.PersonEmail +'<br><br>';
            body +='<br>';
            body +='System Generated Email';
            mail.setHtmlBody(body);
            mails.add(mail);
        }
        
        //Triggering the email
        Messaging.sendEmail(mails);
        
    }*/
        }
        
    
}