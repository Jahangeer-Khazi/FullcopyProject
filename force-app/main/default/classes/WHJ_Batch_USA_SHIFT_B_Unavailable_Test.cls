@isTest
public class WHJ_Batch_USA_SHIFT_B_Unavailable_Test {
    
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
        usr.Shifts__c = 'USA_SHIFT_B';
        usr.Status__c = 'Available';
        insert usr;
        
        
        Test.startTest();
        WHJ_Batch_USA_SHIFT_B_Unavailable be1 = new WHJ_Batch_USA_SHIFT_B_Unavailable();
        database.executeBatch(be1);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, be1);  
        Test.stopTest(); 
        
        
    }
    
    
}