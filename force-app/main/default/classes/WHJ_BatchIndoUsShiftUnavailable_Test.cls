@isTest
public class WHJ_BatchIndoUsShiftUnavailable_Test {
    
    static testmethod void test() 
    {
        User usr = new User();
        
        usr.LastName = 'testuser';
        usr.Email= 'testuserbatchavailable@gmail.com';
        usr.Alias = 'testuser';
        usr.Username = 'testuserbatchavailable@gmail.com';
        usr.CommunityNickname ='test';
        usr.TimeZoneSidKey = 'Asia/Kolkata';
        usr.LocaleSidKey= 'en_IN';
        usr.EmailEncodingKey= 'ISO-8859-1';
        usr.ProfileId= '00e2v000003UNxNAAW';
        usr.LanguageLocaleKey= 'en_US';
        usr.Shifts__c = 'Indo-Us';
        usr.Status__c = 'Available';
        insert usr;
        
        
        Test.startTest();
        WHJ_BatchIndoUsShiftUnavailable be1 = new WHJ_BatchIndoUsShiftUnavailable();
        database.executeBatch(be1);
        Test.stopTest(); 
        
        
    }
    
    
}