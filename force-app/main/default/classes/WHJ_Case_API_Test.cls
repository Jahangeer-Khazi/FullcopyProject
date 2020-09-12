@isTest
public class WHJ_Case_API_Test {
    
    static testmethod void testmethod_Success(){
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'test@stu.com');
        account.SLA_First_Calll__c = true;
        insert account;
        account.Status__c = 'Active';
        update account; 
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Email = 'testapi1@gmail.com';
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
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON - UPGRADE POTENTIAL';
        oppo.Type = 'New Student';
        oppo.Teacher_Email__c = 'test@abc.com';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        insert oppo;
        Test.startTest();
        String input_body = '{"ticket_category":"TEACHER_LEAVING","lst_caseDetails" :[{"teacher_email":"testapi1@gmail.com","student_email":"test@stu.com","issue_type":null,"agent_role":null,"subject":null,"description":null,"parent_case":null,"status":null,"origin":null}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(input_body);
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Case_API.createCase();
        Test.stopTest();
    }
    static testmethod void testmethod_failure(){
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'test@stu.com');
        account.SLA_First_Calll__c = true;
        insert account;
        account.Status__c = 'Active';
        update account; 
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON - UPGRADE POTENTIAL';
        oppo.Type = 'New Student';
        oppo.Teacher_Email__c = 'Test@abc.com';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        insert oppo;
        System.debug('@@@ oppo '+oppo);
        Test.startTest();
        String input_body = '{ Test, "ticket_category":"TEACHER_LEAVING","lst_caseDetails" :[{"teacher_email":"Test@abc.com","student_email":"test@stu.com","issue_type":null,"agent_role":null,"subject":null,"description":null,"parent_case":null,"status":null,"origin":null}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(input_body);
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Case_API.createCase();
        Test.stopTest();
        
    }
    static testmethod void testalert_Success(){
        
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Account acc = new Account( Status__c = 'Active',RecordTypeId =recordTypeId );
        acc.NAME = 'Test';
        acc.SLA_First_Calll__c = true;
        acc.Status__c = 'Active';
        insert acc;
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON - UPGRADE POTENTIAL';
        oppo.Type = 'New Student';
        oppo.Teacher_Email__c = 'testapi1@gmail.com';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        insert oppo;
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Email = 'testapi1@gmail.com';
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
        contact.AccountId = acc.id;
        Insert contact;
        
        
        Account acc1 = new Account( Status__c = 'Active',RecordTypeId =recordTypeId );
        acc1.NAME = 'Test1';
        acc1.SLA_First_Calll__c = true;
        acc1.Status__c = 'Active';
        insert acc1;
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj';
        oppo1.StageName = 'WON - UPGRADE POTENTIAL';
        oppo1.Type = 'New Student';
        oppo1.Teacher_Email__c = 'testapi11@gmail.com';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        insert oppo1;
        
        Contact contact1 = new Contact();
        contact1.FirstName = 'FirstName1';
        contact1.LastName = 'LastName1';
        contact1.Email = 'testapi11@gmail.com';
        contact1.MobilePhone = '9878459856';
        contact1.Type__c = 'Teacher';
        contact1.RM_Name__c = 'RMname';
        contact1.RM_email_Id__c = 'testrmmail@gmail.com';
        contact1.Status__c = false;
        contact1.Region__c = 'INDIA';
        contact1.Curriculum_Level__c = 'ADVANCED';
        contact1.Language__c = 'English';
        contact1.Date_of_Onboarding__c = Date.newInstance(2019, 02, 25);
        contact1.Induction_Owner__c = 'testInductor@gmail.com';
        contact1.AccountId = acc1.id;
        Insert contact1;
        
        
        
        Case caserecord = new Case();
        caserecord.Category__c = 'Language Issue';
        caserecord.Teacher_Email__c = 'testapi1@gmail.com';
        caserecord.Comments ='Comment1';
        insert caserecord;
        Test.startTest();
        String input_body = '{"ticket_category":"TEACHER_ALERT","lst_caseDetails" :[{"teacher_email":"testapi1@gmail.com","issue_type":"Language Issue","description":"Comment"}]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(input_body);
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_Case_API.createCase();
       
        String input_body1 = '{"ticket_category":"TEACHER_ALERT","lst_caseDetails" :[{"teacher_email":"testapi1@gmail.com","issue_type":"Technical Issues","description":"Comment"}]}';
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueOf(input_body1);
        RestContext.request = req1;
        RestContext.response= res1;
        
        WHJ_Case_API.createCase();
        
        String input_body2 = '{"ticket_category":"TEACHER_ALERT","lst_caseDetails" :[{"teacher_email":"testapi11@gmail.com","issue_type":"Technical Issues","description":"Comment"}]}';
        RestRequest req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueOf(input_body2);
        RestContext.request = req2;
        RestContext.response= res2;
        
        WHJ_Case_API.createCase();
        
        String input_body3 = '{"ticket_category":"TEACHER_ALERT","lst_caseDetails" :[{"teacher_email":"testapi12@gmail.com","issue_type":"Technical Issues","description":"Comment"}]}';
        RestRequest req3 = new RestRequest();
        RestResponse res3 = new RestResponse();
        req3.httpMethod = 'POST';
        req3.requestBody = Blob.valueOf(input_body3);
        RestContext.request = req3;
        RestContext.response= res3;
        
        WHJ_Case_API.createCase();
        Test.stopTest();
    }
    
}