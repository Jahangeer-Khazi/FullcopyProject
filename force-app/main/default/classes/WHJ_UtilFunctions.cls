public class WHJ_UtilFunctions {
    
    public static HttpResponse testResponse; // use it for testing
    
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
    
    public static String performHttpRequest(String postBody,String endPoint,String method, String contentType, String auth){
        HttpRequest req = new HttpRequest();
        Http http       = new Http();
        system.debug('inside performHttpRequest function -- ');
        req.setmethod(method);
        if(auth != null && auth != '') {
            req.setHeader('Authorization',auth);
        }
        
        if(contentType != null && contentType != '') {
            req.setHeader('Content-Type',contentType);
        }
        req.setEndpoint(endpoint);
        if((method == 'POST' || method == 'PUT') && (postBody != null)) {
            req.setBody(postBody);
        }
        
        HttpResponse res = new HttpResponse();
        try {
            
            system.debug('------------------- HTTP Request --------------------------------- ');
            system.debug(req);
            system.debug(req.getBody());
            system.debug('------------------- END HTTP Request --------------------------------- ');
            
            if(!Test.isRunningTest()) {
                res = http.send(req);
            } else {
                res = testResponse;
            }
                
            
            system.debug('------------------- HTTP RESPONSE --------------------------------- ');
            system.debug(res.getBody());
            system.debug('------------------- END HTTP RESPONSE --------------------------------- ');   
                
            if(res.getStatusCode() > 300){
                //throw new SocialTwitterFollowException(GENERIC_ERR + ' ' + res.getBody());
            }       
        } catch(CalloutException e) {
            //throw new SocialTwitterFollowException(GENERIC_ERR + ' ' + e.getMessage());
        }
        return res.getBody(); // Return the body   
    }
}