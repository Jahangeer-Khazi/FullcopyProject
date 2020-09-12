/*White Hat Junior PhoneRecruiter API TEST Class 
 *Created By: GAUTAM
 *Release No: 1
 *Created Date: 25/06/2020
 *Purpose: This Test class is to test Data for WHJ_PhoneRecruiterAPI_Test class.
 */ 

@isTest
public class WHJ_PhoneRecruiterAPI_Test {
    
    /*
    @testSetup  static void setupTestData()
    {
        
         UserRole r = [Select id from UserRole where Name = 'Teacher Recruiter'];
     
         UserRole r1 = [Select id from UserRole where Name = 'Renewals Manager'];
         Profile p = [SELECT Id FROM Profile WHERE Name='Teacher Recruiter']; 
        
        //User u1 = new  User(Name='test',Email='gautam@gmail.com',isActive='true',EmployeeId__c='55');
        User usr = new User(LastName = 'flagUser',
                            FirstName='test',
                            Alias = 'flag',
                            Email = 'flag.test1@sfdc.com',
                            Username = 'flag.test1@sfdc.com',
                            ProfileId = p.id,
                            userroleid = r1.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US');
        insert usr;
       // insert u1;
        
        
          List<User> lstUser = [SELECT Id,Name,Email,isActive,EmployeeId__c FROM User WHERE EmployeeId__c='55'];
        
          if(!lstUser.isEmpty()){ // if then update
                User user = new User();
                user.Id = lstUser[0].Id;
                user.FirstName= 'gautam';
                user.LastName = 'bohra';
               
                user.Email = 'gautam1111@gmail.com';
                user.Username = 'gauta111m@gmail.com';
                user.UserRoleId = 'Renewals Manager';
                user.isActive = true;
                user.EmployeeId__c = '557';
                user.MobilePhone = '8855258454';
                user.TimeZoneSidKey = 'Asia/Kolkata';
                user.LanguageLocaleKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.LocaleSidKey = 'en_IN';
                
                update user;
                
            }else{ // else insert the user
                
                User user = new User();
                
                user.FirstName= 'gautam';
                user.LastName = 'bohra';
                user.Email = 'gautam11@gmail.com';
                user.Username = 'gauta11m@gmail.com';
                user.isActive = true;
                user.EmployeeId__c = '557';
                user.MobilePhone = '8855258454';
                user.TimeZoneSidKey = 'Asia/Kolkata';
                user.LanguageLocaleKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.LocaleSidKey = 'en_IN';
                user.Alias = 'gbohra';
                    user.ProfileId = p.id;
                
                insert user; 
               // System.debug(user);
                
            }
    
    }*/
    
    static testmethod void createUserData1()  
    {  
        
       // setupTestData(); 
          String actual ='{"FirstName":"gautam", "LastName":"bohra", "Email":"qwerty@aethereus.com", "RecruiterID":"12345678", "isActive":"true", "MobilePhone":"648484"}';
             RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_PhoneRecruiterAPI.createUserData();
    }
    
    static testmethod void createUserData2()  
    { 
              UserRole r = [Select id from UserRole where Name = 'Teacher Recruiter'];
         Profile p = [SELECT Id FROM Profile WHERE Name='Teacher Recruiter']; 
         User user = new User();
                
                user.FirstName= 'gautam';
                user.LastName = 'bohra';
                user.Email = 'gautam11@gmail.com';
                user.Username = 'gauta11m@gmail.com';
                user.isActive = true;
                user.EmployeeId__c = '557';
                user.MobilePhone = '8855258454';
                user.TimeZoneSidKey = 'Asia/Kolkata';
                user.LanguageLocaleKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.LocaleSidKey = 'en_IN';
                user.Alias = 'gbohra';
                    user.ProfileId = p.id;
        user.UserRoleId = r.id;
                
                insert user; 
        
       // setupTestData(); 
          String actual ='{"FirstName":"gautam", "LastName":"bohra", "Email":"qwerty@aethereus.com", "RecruiterID":"557", "isActive":"true", "MobilePhone":"648484"}';
             RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_PhoneRecruiterAPI.createUserData();
    }
     
    static testmethod void createUserData3()  
    { 
              UserRole r = [Select id from UserRole where Name = 'Teacher Recruiter'];
         Profile p = [SELECT Id FROM Profile WHERE Name='Teacher Recruiter']; 
         User user = new User();
                
                user.FirstName= 'gautam';
                user.LastName = 'bohra';
                user.Email = 'gautam11@gmail.com';
                user.Username = 'gauta11m@gmail.com';
                user.isActive = true;
                user.EmployeeId__c = '557';
                user.MobilePhone = '8855258454';
                user.TimeZoneSidKey = 'Asia/Kolkata';
                user.LanguageLocaleKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.LocaleSidKey = 'en_IN';
                user.Alias = 'gbohra';
                    user.ProfileId = p.id;
        user.UserRoleId = r.id;
                
                insert user; 
        
       // setupTestData(); 
          String actual ='{"FirstName":"gautam", "LastName":"bohra", "Email":"gautam11@gmail.com", "RecruiterID":"557", "isActive":"true", "MobilePhone":"648484"}';
             RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_PhoneRecruiterAPI.createUserData();
    }

    
       
    /*static testmethod void createUserData4()  
    { 
              UserRole r = [Select id from UserRole where Name = 'Teacher Recruiter'];
         Profile p = [SELECT Id FROM Profile WHERE Name='Teacher Recruiter']; 
         User user = new User();
                
                user.FirstName= 'gautam';
                user.LastName = 'bohra';
                user.Email = 'gautam11@gmail.com';
                user.Username = 'gauta11m@gmail.com';
                user.isActive = true;
                user.EmployeeId__c = '557';
                user.MobilePhone = '8855258454';
                user.TimeZoneSidKey = 'Asia/Kolkata';
                user.LanguageLocaleKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.LocaleSidKey = 'en_IN';
                user.Alias = 'gbohra';
                    user.ProfileId = p.id;
        user.UserRoleId = r.id;
                
                insert user; 
        
       // setupTestData(); 
          String actual ='{"FirstName":"gautam", "LastName":"bohra", "Email":"gautam11@gmail.com", "RecruiterID":"5574544", "isActive":"true", "MobilePhone":"648484"}';
             RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_PhoneRecruiterAPI.createUserData();
    }*/
}