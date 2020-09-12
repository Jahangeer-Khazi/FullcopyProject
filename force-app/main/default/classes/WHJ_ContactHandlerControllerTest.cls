@isTest
public class WHJ_ContactHandlerControllerTest {
    static testmethod void createUserData1(){
        
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.Stages__c = 'Selected';
        insert con;
        
        user us =  [select id from user where id=: UserInfo.getUserId() ];
        
        String caseJSON = '{"attributes":{"type":"Contact","url":"/services/data/v25.0/sobjects/Contact/0032v00003aWCe0AAG"},"Id":"0032v00003aWCe0AAG","Stages__c":"Selected","LastModifiedById": "\''+us.id+'\'" }'; 
        Contact c = (Contact) JSON.deserialize(caseJSON, Contact.class); 
        
        Contact c1 = new Contact(); 
        c1.Id = c.Id; 
        c1.Stages__c = 'Rejected';
        c1.Comments_If_Selected_Rejected__c = 'qwertyu';
        test.startTest();
        update c1;
        test.stopTest();
        
        WHJ_ContactHandlerController.SendTeacherDisposition(null, null);
         
    }
}