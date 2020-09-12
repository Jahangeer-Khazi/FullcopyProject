public class UserDeactAura {
    Static String compNameUserDeactivate = 'WHJ_UserDeactivate';
    Static String compType = 'Apex Class';
    
    @AuraEnabled
    public static List<User> getUserData(Id UsrId )
    {
        return [SELECT Id, isActive FROM User where Id =: UsrId] ;
    }
    
    @AuraEnabled
    public static WHJ_UtilFunctions.ParentRecord deactivateUser(String userId) {
        WHJ_UtilFunctions.ParentRecord parent = new WHJ_UtilFunctions.ParentRecord();
        
        if(userId != null) {
            try {
                User usr = [Select id, email, isActive FROM User where Id =: userId];
                if(usr != null && usr.IsActive) {
                    usr.IsActive = false;
                    update usr; 
                    parent.success = true;
                    String email = usr!= null ? usr.email: null;
                    //call out for deactivating user in darwin box 
                    DarwinBoxConfiguration__mdt darwingMdtConfig = [SELECT name__c, value__c from DarwinBoxConfiguration__mdt where DeveloperName = 'Secret_Key' LIMIT 1];
                    DarwinBoxConfiguration__mdt darwinBoxBaseurl = [SELECT name__c, value__c from DarwinBoxConfiguration__mdt where DeveloperName = 'BaseURL' LIMIT 1];
                    DarwinBoxConfiguration__mdt darwinBoxDeactivateRelatedURL = [SELECT name__c, value__c from DarwinBoxConfiguration__mdt where DeveloperName = 'DeactivateRelatedURL' LIMIT 1];
                    //darwingMdtConfig.
                    Datetime dt = System.now();
                    Long timestamp = dt.getTime()/1000;
                    String targetString = email + darwingMdtConfig.Value__c + timestamp;
                    // Convert to BLOB
                    Blob targetBlob = Blob.valueOf(targetString);
                    List<wrapEmployeeData> wrapEmpList = new List<wrapEmployeeData>();
                    wrapEmployeeData wrapEmpData = new wrapEmployeeData();
                    wrapEmpData.employee_id = 'whjr-123112312';
                    wrapEmpData.deactivate_type = 'test';
                    wrapEmpData.deactivate_reason = 'internal job change';
                    wrapEmpData.date_of_resignation = System.today();
                    wrapEmpData.date_of_exit = System.today();
                    wrapEmpList.add(wrapEmpData);
                    String postBody = JSON.serialize(wrapEmpList);
                    String endPoint = darwinBoxBaseurl.Value__c + darwinBoxDeactivateRelatedURL.Value__c;
                    String method = 'Post';
                    String contentType = 'application/json;charset=UTF-8';
                    String auth = null;
                    String res = WHJ_UtilFunctions.performHttpRequest(postBody, endPoint, method, contentType, auth);
                } else {
                    parent.success = false;
                    parent.error.add(new WHJ_UtilFunctions.ChildRecord( '204', 'user is already deactivated'));
                }
            } catch (Exception e) {
                String recRef = 'User Deactivate';
                parent.success = false;
                parent.error.add(new WHJ_UtilFunctions.ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));
                String err = e.getMessage()  + e.getStackTraceString();  
                system.debug('error-- ' + err);
                //WHJ_ErrorLogHandler.log(compNameUserDeactivate, compType, err, 400,recRef,null);    
            }
        } else {
            parent.error.add(new WHJ_UtilFunctions.ChildRecord( '400', 'User Not found'));
        }      
        return parent;
    }
    
    //Wrapper Class
    public class wrapEmployeeData {
        public String employee_id {get; set;}
        public String deactivate_type {get; set;}
        public String deactivate_reason {get; set;}
        public Date date_of_resignation {get; set;}
        public Date date_of_exit {get; set;}
    }
}