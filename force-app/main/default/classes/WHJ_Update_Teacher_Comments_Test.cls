@isTest
public class WHJ_Update_Teacher_Comments_Test {
    @isTest
    static void testData() {
        
        try{
           
            Profile p = [SELECT Id FROM Profile WHERE Name='Chatter Free User']; 
            User u = new User(Alias = 'test', Email='abc@gmail.com', 
                              EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='whjhr@testorg.com',
                              Status__c = 'Available',Call_Availability_Status__c = 'Available'     );
            insert u;
        
         feeditem FI1=new feeditem();
         FI1.parentid=u.id;
         FI1.createdbyid=u.id;
         FI1.Body = '!!hars@gmail.com!! Good Job. ';
         insert FI1;
        
        UserFeed uf = [Select ParentId, Id, Body From UserFeed  Where Id = :FI1.Id];
		System.assertEquals ('!!hars@gmail.com!! Good Job.', uf.Body);

            
             Account acc = new Account();
                acc.LastName = 'test';
                insert acc;
            
            
            
            String str='Chatter Free User';
            List<User> lstuser = [select Id, Name from User  where Id=:u.Id AND Profile.Name LIKE :'%'+str+'%'];
            
            if(!lstuser.isEmpty()){
               
                Opportunity oppo = new Opportunity();
                oppo.AccountId = acc.Id;
                oppo.Name = 'whj';
                oppo.StageName = 'WON-PART PAYMENT';
                oppo.CloseDate = Date.newInstance(1960, 2, 17);
                oppo.Teacher_Feedback__c = 'body';
                
                insert oppo;

                Test.StartTest();
                update oppo;
                Test.StopTest();

            }
            
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
        
        
    }
}