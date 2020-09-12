/*White Hat Junior Open_CTI API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 25/09/2019
 *Purpose: This Test class is to test Data for WHJ_Open_CTI_API class.
 */ 

@isTest
public class WHJ_Open_CTI_API_Test {
    public static testMethod void getPhone() {
        
        Account acc = new Account();
        acc.LastName = 'test';
        acc.PersonMobilePhone = '+917788765226';
        insert acc;    
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User usr = new User(Alias = 'standt', Email='standarduser@tt.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = pro.Id, MobilePhone = '+918605016556',
                            Call_Availability_Status__c = 'Available',                    
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser11@tt.com');
        insert usr;
        
        List<Account> lstAccount = [SELECT Id ,LastName ,PersonMobilePhone, OwnerId From Account limit 1];
        System.debug('lstAccount::'+lstAccount);
        list<User> user = [Select id, name, UserRoleId, MobilePhone from User where Id =: usr.Id And Call_Availability_Status__c = 'Available'];
        System.debug('user::'+user);
        String PrimaryNo = user[0].MobilePhone;
        System.debug('PrimaryNo::'+PrimaryNo);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        req.requestURI = '/services/apexrest/Open_CTI/+917788765226'; 
        req.requestBody = Blob.valueof('{}');
        
        RestContext.request = req;
        RestContext.response= res;
        //    System.assertEquals(PrimaryNo,req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        WHJ_Open_CTI_API.getMobNo();
        
    }
    
    public static testMethod void getPhoneCatch() {
        
        Account acc = new Account();
        acc.LastName = 'test';
        acc.PersonMobilePhone = '+917788765226';
        insert acc;    
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User usr = new User(Alias = 'standt1', Email='standarduser@tt.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = pro.Id, MobilePhone = '+918605016551',
                            Call_Availability_Status__c = 'Available',                    
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser12@tt.com');
        insert usr;
        
        List<Account> lstAccount = [SELECT Id ,LastName ,PersonMobilePhone, OwnerId From Account limit 1];
        System.debug('lstAccount::'+lstAccount);
        list<User> user = [Select id, name, UserRoleId, MobilePhone from User where Id =: usr.Id And Call_Availability_Status__c = 'Available'];
        System.debug('user::'+user);
        String PrimaryNo = user[0].MobilePhone;
        System.debug('PrimaryNo::'+PrimaryNo);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        req.requestURI = '/services/apexrest/Open_CTI/+9177887'; 
        req.requestBody = Blob.valueof('{}');
        
        RestContext.request = req;
        RestContext.response= res;
        //    System.assertEquals(PrimaryNo,req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        WHJ_Open_CTI_API.getMobNo();
        
    }
    
}