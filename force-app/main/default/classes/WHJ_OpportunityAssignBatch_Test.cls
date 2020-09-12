@isTest
public class WHJ_OpportunityAssignBatch_Test {
    
    
    @testSetup static void setup() {
        UserRole r1 = [Select id from UserRole where Name = 'Sales Manager'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available',Sales_Region__c = 'International'    );
        insert u;
        
        User u1 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1test1@testorg.com',Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International');
        insert u1; 
        
        
    }
    
    
    static testmethod void test() 
    {
        Account account = new Account(FirstName = 'Test', LastName = 'Test', PersonEmail = 'abc@gmail.com' ,Referral_Call__c=false, BillingCountry = 'India');
        insert account;
        
        Opportunity oppo1 = new Opportunity(Name = 'Test1' , accountId= account.id, StageName = 'WIP', CloseDate = date.today() , Owner_Assigned__c = false );
        insert oppo1;
        
        
        Test.startTest();
        WHJ_OpportunityAssignBatch be1 = new WHJ_OpportunityAssignBatch();
        database.executeBatch(be1);
        Test.stopTest(); 
        
        
    }
    
    
}