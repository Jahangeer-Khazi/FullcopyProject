@isTest
public class WHJ_Batch_Challengers_2_Unavailable_Test {
    
    static testmethod void test() 
    {
        User usr = new User();
        
        usr.LastName = 'testuser';
        usr.Email= 'testuserbatchavailable4@gmail.com';
        usr.Alias = 'testuser';
        usr.Username = 'testuserbatchavailable4@gmail.com';
        usr.CommunityNickname ='test';
        usr.TimeZoneSidKey = 'Asia/Kolkata';
        usr.LocaleSidKey= 'en_IN';
        usr.EmailEncodingKey= 'ISO-8859-1';
        usr.ProfileId= '00e2v000003UNxNAAW';
        usr.LanguageLocaleKey= 'en_US';
        usr.Shifts__c = 'Challengers 2';
        usr.Status__c = 'Available';
        insert usr;
        
        
        Test.startTest();
        WHJ_Batch_Challengers_2_Unavailable be1 = new WHJ_Batch_Challengers_2_Unavailable();
        database.executeBatch(be1);
            String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, be1);  
        Test.stopTest(); 
        
        
    }
    
    
}