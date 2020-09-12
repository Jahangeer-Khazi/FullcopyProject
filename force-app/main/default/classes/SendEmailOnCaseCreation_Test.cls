@isTest
public class SendEmailOnCaseCreation_Test {
     static testMethod void SendEmail() {
     	Contact con = new Contact();
         con.FirstName = 'Fname';
         con.LastName = 'Lname';
         con.Email = 'abc@gmail.com';
         
         insert con;
         
         Case c = new Case();
         c.Origin = 'Email';
         c.Status ='New';
         insert c;
         
        
         c.ContactId = con.Id;
         //c.CategoryInClass__c = 'Cannot see student';
         c.Category__c = c.CategoryInClass__c;
         update c;
     }	
}