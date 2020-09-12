/*White Hat Junior Task API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 19/09/2019
 *Purpose: This Test class is to test Data for WHJ_Task_API class.
 */ 



@isTest
global class WHJ_Task_API_Test {

static testmethod void createtask() {
    String actual = '{"Subject": "Here is Email","AssignedTo": "Harsh Gughane","Priority": "High","Status": "Open","DueDate":"2018-07-25","Type": "Email","ToAddress": "harhghsh@gmail.com","TextBody": "Test","SubjectForEmailMessage": "Create Email","HtmlBody": "Hi this is Harsh","StatusofEmailMeassage": "3"}';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
	
     WHJ_Task_API.createTask();
    }

     static testmethod void createtaskElse() {
    String actual = '{"Subject": "Here is Email","AssignedTo": "Harsh Gughane","Priority": "High","Status": "Open","DueDate":"2018-07-25","Type": "SMS","ToAddress": "harhghsh@gmail.com","TextBody": "Test","SubjectForEmailMessage": "Create Email","HtmlBody": "Hi this is Harsh","StatusofEmailMeassage": "3"}';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
	
     WHJ_Task_API.createTask();
    }
  static testmethod void createtaskCatch() {
    String actual = '{"Subject": "Here is Email","AssignedTo": "","Priority": "High","Status": "Open","DueDate":"2018-07-25","Type": "SMS","ToAddress": "harhghsh@gmail.com","TextBody": "Test","SubjectForEmailMessage": "Create Email","HtmlBody": "Hi this is Harsh","StatusofEmailMeassage": "3"}';
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
//req.requestURI = '/services/apexrest/LeadTrialClass'; //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(actual);

    RestContext.request = req;
    RestContext.response= res;
	
     WHJ_Task_API.createTask();
    }
}