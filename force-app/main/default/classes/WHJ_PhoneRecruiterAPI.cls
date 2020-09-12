@RestResource(urlMapping='/PhoneRecruiterAPI')
global class WHJ_PhoneRecruiterAPI {
    @HttpPut
    global static Void createUserData() 
    {
        
        
        String email = '';
        String reqBody = '';
        
        try{
            // RestRequest Method to get JSON Request
            RestRequest request = RestContext.request;
            // Convert JSON data blob to String
            reqBody = request.requestBody.toString(); 
            system.debug('reqBody  :: '+ reqBody);
            
            
            
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));                
            
            
            WHJ_PhoneRecruiterAPIParser parsedData = WHJ_PhoneRecruiterAPIParser.parse(reqBody);
            system.debug('parsedData  :: ' + parsedData);
            
            email = parsedData.Email;
            
            if (parsedData.RecruiterID != null)
            {
                Profile profileId = [SELECT Id FROM Profile WHERE Name =: system.Label.Profile_Teacher_Recruiter];
                UserRole roleId = [SELECT Id FROM UserRole WHERE Name =: system.Label.Role_Teacher_Recruiter];			
                
                
                List<User> usr = [SELECT Id,FirstName,LastName,Name,Email,ProfileId,Username,UserRoleId,Alias,isActive,EmployeeId__c,MobilePhone,TimeZoneSidKey,LanguageLocaleKey,EmailEncodingKey ,LocaleSidKey FROM User WHERE EmployeeId__c =: parsedData.RecruiterID];
                
                
                if(!usr.isEmpty()){ // if then update
                    
                    List<User> usrtemp = [SELECT Id,FirstName,LastName,Name,Email,Username FROM User WHERE Email =: parsedData.Email OR Username =: parsedData.Email];
                    
                    
                    if(!usrtemp.isEmpty()){
                        if((usr[0].id == usrtemp[0].id))
                        {
                            User usr1 = new User();
                            usr1.Id = usr[0].Id;
                            if(parsedData.FirstName != null)
                                usr1.FirstName= parsedData.FirstName;
                            
                            if(parsedData.LastName != null)
                                usr1.LastName = parsedData.LastName;
                            
                            if(parsedData.FirstName != null){
                                if(parsedData.FirstName.length()>8)
                                    usr1.Alias = parsedData.FirstName.substring(0,8);
                                else
                                    usr1.Alias = ParsedData.FirstName; 
                            }
                            
                            if(parsedData.Email != null)
                                usr1.Email = parsedData.Email;
                            
                            if(parsedData.Email != null)
                                usr1.Username = parsedData.Email;
                            
                            
                            usr1.ProfileId = profileId.Id;
                            usr1.UserRoleId = roleId.Id;
                            
                            if(parsedData.statusActive != null)
                                usr1.isActive = parsedData.statusActive;
                            
                            if(parsedData.Mobile != null)
                                usr1.MobilePhone = parsedData.Mobile;
                            
                            usr1.TimeZoneSidKey = 'Asia/Kolkata';
                            usr1.LanguageLocaleKey = 'en_US';
                            usr1.EmailEncodingKey = 'ISO-8859-1';
                            usr1.LocaleSidKey = 'en_IN';
                            
                            update usr1;
                        }
                        else
                        {
                            CalloutException e = new CalloutException();
                            e.setMessage('Email / Username already exist in Salesforce Org');
                            throw e; 
                        }
                        
                    }
                    else
                    {
                        User usr1 = new User();
                        usr1.Id = usr[0].Id;
                        if(parsedData.FirstName != null)
                            usr1.FirstName= parsedData.FirstName;
                        
                        if(parsedData.LastName != null)
                            usr1.LastName = parsedData.LastName;
                        
                        if(parsedData.FirstName != null){
                            if(parsedData.FirstName.length()>8)
                                usr1.Alias = parsedData.FirstName.substring(0,8);
                            else
                                usr1.Alias = ParsedData.FirstName; 
                        }
                        
                        if(parsedData.Email != null)
                            usr1.Email = parsedData.Email;
                        
                        if(parsedData.Email != null)
                            usr1.Username = parsedData.Email;
                        
                        
                        usr1.ProfileId = profileId.Id;
                        usr1.UserRoleId = roleId.Id;
                        
                        if(parsedData.statusActive != null)
                            usr1.isActive = parsedData.statusActive;
                        
                        if(parsedData.Mobile != null)
                            usr1.MobilePhone = parsedData.Mobile;
                        
                        usr1.TimeZoneSidKey = 'Asia/Kolkata';
                        usr1.LanguageLocaleKey = 'en_US';
                        usr1.EmailEncodingKey = 'ISO-8859-1';
                        usr1.LocaleSidKey = 'en_IN';
                        
                        update usr1;
                        
                        
                    }
                    
                    
                    
                }
                else{ // else insert the user
                    
                    List<User> usr1 = [SELECT Id,FirstName,LastName,Name,Email,Username FROM User WHERE Email =: parsedData.Email OR Username =: parsedData.Email];
                    
                    if(usr1.isEmpty())
                    {
                        
                        User user = new User();
                        user.FirstName= parsedData.FirstName;
                        user.LastName = parsedData.LastName;
                        if(parsedData.FirstName.length()>8)
                            user.Alias = parsedData.FirstName.substring(0,8);
                        else
                            user.Alias = ParsedData.FirstName;    
                        user.Email = parsedData.Email;
                        user.Username = parsedData.Email;
                        user.ProfileId = profileId.Id;
                        user.UserRoleId = roleId.Id;
                        user.isActive = parsedData.statusActive;
                        user.EmployeeId__c = parsedData.RecruiterID;
                        
                        
                        user.MobilePhone = parsedData.Mobile;
                        user.TimeZoneSidKey = 'Asia/Kolkata';
                        user.LanguageLocaleKey = 'en_US';
                        user.EmailEncodingKey = 'ISO-8859-1';
                        user.LocaleSidKey = 'en_IN';
                        
                        
                        insert user; 
                        System.resetPassword(user.Id, true);
                    }
                    else
                    {
                        CalloutException e = new CalloutException();
                        e.setMessage('Email / Username already exist in Salesforce Org');
                        throw e;
                    }
                    
                }
            }
            else
            {
                CalloutException e = new CalloutException();
                e.setMessage('Recruiter Id : Required Field');
                throw e;
                
            }
            
            
            
        }catch(Exception e){
            System.debug('Exception::'+e);
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage())); 
            String compName = 'WHJ_PhoneRecruiterAPI';
            String compType = 'REST API Class';
            String recRef = email;
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