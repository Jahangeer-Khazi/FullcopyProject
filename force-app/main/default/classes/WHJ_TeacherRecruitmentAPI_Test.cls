@isTest
global class WHJ_TeacherRecruitmentAPI_Test {
    
    @testSetup  static void setupTestData()
        
    {
        
                 
        List<Contact> lstContact = [SELECT Id,Name,Email FROM Contact WHERE Email ='testAPI1@gmail.com'];
        if(!lstContact.isEmpty()){
            Contact con = new Contact();
            con.Id = lstContact[0].Id;
            con.FirstName = 'FirstName';
            con.LastName = 'LastName';
            con.Email = 'testAPI1@gmail.com';
            con.MobilePhone = '7412589630';
            con.Date_of_registration__c = Date.newInstance(2019, 02, 25); 
            con.Phone_Recruiter_Email_Id__c = 'testmail@gmail.com';
            con.Type__c = 'Potential Teacher Recruitment'; 
            con.Teacher_Id__c = '123456789';
            Update con;
        } else{
            Contact con = new Contact();
            con.FirstName = 'FirstName';
            con.LastName = 'LastName';
            con.Email = 'testAPI1@gmail.com';
            con.MobilePhone = '7412589630';
            con.Date_of_registration__c = Date.newInstance(2019, 02, 25); 
            con.Phone_Recruiter_Email_Id__c = 'testmail@gmail.com';
            con.Type__c = 'Potential Teacher Recruitment';   
            con.Teacher_Id__c = '12345689';
            insert con;
        }    
        
    }
    
    
    static testmethod void createContact() {
       
        setupTestData();
       // String actual = '{"FirstName": "FName","LastName": "LName","email": "testAPI1@gmail.com",RecruiterID = "123456789","Mobile": "9798979596","PhoneRecruiterMailId":"testmail@gmail.com","DateOfRegistration":"2018-07-25"}';
        	String actual = '{'+
		'\"FirstName\": \"FName\",'+
		'\"LastName\": \"LName\",'+
		'\"email\": \"testAPI1@gmail.com\",'+
		'\"Mobile\": \"9798979596\",'+
		'\"DateOfRegistration\":\"2018-07-25\",'+
		'\"PhoneRecruiterMailId\":\"testmail@gmail.com\"'+
		'}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherRecruitmentAPI.createTeacherData();
    }    
    
    Static testmethod void createContactElse() {
        
        setupTestData();
        //String actual = '{"FirstName": "FName","LastName": "LName","email": "testAPI1@gmail.com","TeacherId":"12345689",RecruiterID = "123456789",Mobile": "9798979596","PhoneRecruiterMailId":"testmail@gmail.com","DateOfRegistration":"2018-07-25"}';
        String actual = '{'+
		'\"FirstName\": \"FName\",'+
		'\"LastName\": \"LName\",'+
		'\"email\": \"testAPI1@gmail.com\",'+
		'\"Mobile\": \"9798979596\",'+
        '\"RecruiterID\": \"123456789\",'+    
		'\"DateOfRegistration\":\"2018-07-25\",'+
		'\"PhoneRecruiterMailId\":\"testmail@gmail.com\"'+
		'}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherRecruitmentAPI.createTeacherData();
    } 
    
    Static testmethod void createContactElse1() {
        setupTestData();
        //String actual = '{"FirstName": "FName","LastName": "LName","email": "testAPI1@gmail.com","Mobile": "9798979596","TeacherId":"12345689",RecruiterID = "123456789","DateOfRegistration":"2018-07-25"}';
         Contact con = new Contact();
            con.FirstName = 'FirstName 1';
            con.LastName = 'LastName 1';
            con.Email = 'testAPI12121@gmail.com';
            con.MobilePhone = '7412589630';
            con.Date_of_registration__c = Date.newInstance(2019, 02, 25); 
            con.Phone_Recruiter_Email_Id__c = 'testmail741@gmail.com';
            con.Type__c = 'Potential Teacher Recruitment';   
            con.Teacher_Id__c = '12345689';
            insert con;
        
        String actual = '{'+
            '\"FirstName\": \"FName\",'+
            '\"LastName\": \"LName\",'+
            '\"email\": \"testAPI1@gmail.com\",'+
            '\"Mobile\": \"9798979596\",'+
            '\"RecruiterID\": \"123456789\",'+    
            '\"TeacherId\": \"12345689\",'+    
            '\"DateOfRegistration\":\"2018-07-25\",'+
            '\"PhoneRecruiterMailId\":\"testmail@gmail.com\"'+
            '}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherRecruitmentAPI.createTeacherData();
    }
    
    Static testmethod void createContactElse2() {
        setupTestData();
        //String actual = '{"FirstName": "FName","LastName": "LName","email": "testAPI122@gmail.com","TeacherId":"12345689","Mobile": "9798979596",RecruiterID = "123456789","DateOfRegistration":"2018-07-25"}';
        Contact con = new Contact();
            con.FirstName = 'FirstName 1';
            con.LastName = 'LastName 1';
            con.Email = 'testAPI12121@gmail.com';
            con.MobilePhone = '7412589630';
            con.Date_of_registration__c = Date.newInstance(2019, 02, 25); 
            con.Phone_Recruiter_Email_Id__c = 'testmail741@gmail.com';
            con.Type__c = 'Potential Teacher Recruitment';   
            con.Teacher_Id__c = '12345611';
            insert con;
        
        String actual = '{'+
            '\"FirstName\": \"FName\",'+
            '\"LastName\": \"LName\",'+
            '\"email\": \"testAPI1@gmail.com\",'+
            '\"Mobile\": \"9798979596\",'+
            '\"RecruiterID\": \"123456789\",'+    
            '\"TeacherId\": \"12345688\",'+    
            '\"DateOfRegistration\":\"2018-07-25\",'+
            '\"PhoneRecruiterMailId\":\"testmail@gmail.com\"'+
            '}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherRecruitmentAPI.createTeacherData();
    }
    
    /*Static testmethod void createContactElse3() {
        setupTestData();
        String actual = '{"FirstName": "FName","LastName": "LName","email": "testAPI122@gmail.com","TeacherId":"1234564589","Mobile": "9798979596",RecruiterID = "123456789","PhoneRecruiterMailId":"testmail@gmail.com","DateOfRegistration":"2018-07-25"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherRecruitmentAPI.createTeacherData();
    }
    
    Static testmethod void createContactCatch() {
        String actual = '';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherRecruitmentAPI.createTeacherData();
    }   */ 
    
}