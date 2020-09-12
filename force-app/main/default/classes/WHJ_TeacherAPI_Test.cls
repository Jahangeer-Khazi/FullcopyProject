@isTest
global class WHJ_TeacherAPI_Test {
    
    @testSetup  static void setupTestData()
        
    {
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Email = 'testAPI1@gmail.com';
        contact.MobilePhone = '9878459856';
        contact.Type__c = 'Teacher';
        contact.RM_Name__c = 'RMname';
        contact.RM_email_Id__c = 'testrmmail@gmail.com';
        contact.Status__c = false;
        contact.Region__c = 'INDIA';
        contact.Curriculum_Level__c = 'ADVANCED';
        contact.Language__c = 'English';
        contact.Date_of_Onboarding__c = Date.newInstance(2019, 02, 25);
        contact.Induction_Owner__c = 'testInductor@gmail.com';                
        Insert contact;
        
        List<Contact> lstContact = [SELECT Id,Name,Email FROM Contact WHERE Email ='testAPI1@gmail.com'];
        if(!lstContact.isEmpty()){
            Contact con = new Contact();
            con.Id = lstContact[0].Id;
            con.FirstName = 'FirstName';
            con.LastName = 'LastName';
            con.Email = 'testAPI1@gmail.com';
            con.MobilePhone = '7412589630';
            con.Type__c = 'Teacher';
            contact.RM_Name__c = 'RMname';
            contact.RM_email_Id__c = 'testrmmail@gmail.com';
            contact.Status__c = false;
            contact.Region__c = 'INDIA';
            contact.Curriculum_Level__c = 'ADVANCED';
            contact.Language__c = 'English';
            contact.Date_of_Onboarding__c = Date.newInstance(2019, 02, 25);
            contact.Induction_Owner__c = 'testInductor@gmail.com';   
            Update con;
        } else{
            Contact con = new Contact();
            con.FirstName = 'FirstName';
            con.LastName = 'LastName';
            con.Email = 'testAPI1@gmail.com';
            con.MobilePhone = '7412589630';
            con.Type__c = 'Teacher';
            contact.RM_Name__c = 'RMname';
            contact.RM_email_Id__c = 'testrmmail@gmail.com';
            contact.Status__c = true;
            contact.Region__c = 'INDIA';
            contact.Curriculum_Level__c = 'ADVANCED';
            contact.Language__c = 'English';
            contact.Date_of_Onboarding__c = Date.newInstance(2019, 02, 25);
            contact.Induction_Owner__c = 'testInductor@gmail.com';   
            insert con;
        }    
        
    }
    
    
    static testmethod void createContact() {
        String actual = '{"FirstName": "FName","LastName": "LName","email": "testAPI1@gmail.com","type": "Teacher","Mobile": "9798979596","RMname":"RMname","RMemailId":"testrmmail@gmail.com","Status":true,"Region":"INDIA","CurriculumLevel":"ADVANCED","Language":"English","DateOfOnboarding":"2018-07-25","InductionOwner":"testInductor@gmail.com"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherAPI.createTeacherData();
    }    
    
    Static testmethod void createContactElse() {
        String actual = '{"FirstName": "FName","LastName": "LName","email": "test@gmail.com","type": "Teacher","Mobile": "9798979596","RMname":"RMname","RMemailId":"testrmmail@gmail.com","Status":true,"Region":"INDIA","CurriculumLevel":"ADVANCED","Language":"English","DateOfOnboarding":"2018-07-25","InductionOwner":"testInductor@gmail.com"}';
      
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherAPI.createTeacherData();
    }    
     Static testmethod void createContactCatch() {
        String actual = '';
      
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_TeacherAPI.createTeacherData();
    }    
    
}