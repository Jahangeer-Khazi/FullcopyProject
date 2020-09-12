@isTest
public class WHJ_AccountTriggerHandler_Test {
	 @isTest
      static void coverZendeskMethod() {      
        Account account = new Account();
        account.LastName = 'Test Account';
        account.BillingCountry = 'IndiaV2';
        account.Last_Teacher_Feedback_Date__c=System.today();
        //            account.Activation_Date__c = System.today();
        account.Status__c = 'Opportunity';
        account.PersonMobilePhone = '8787878787';  
        insert account;   
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = account.Id;
        oppo.Name = 'Test Opty';
        oppo.CloseDate = System.today();
        oppo.StageName = 'WIP';  
        oppo.MobileNumber__c = '7485961230';
        insert oppo;  
       
        account.LastName = 'Test Account1';
        account.Status__c = 'Active';
        account.Last_Teacher_Feedback_Date__c=System.today();
        account.PersonMobilePhone = '7412589630';  
        update account;      
          
    }
    
   /* public static testmethod void testZendesk()
       {
			List<Account> listacc = new List<Account>();
			Account acc1 = new Account(Name = 'TestAccountName');
			Insert acc1;
			List<Opportunity> listOpportunity  = new list<Opportunity >();
			for(Integer i = 0 ; i<=100 ;i++)
			{
                Account acc1 = new Account();
                acc1.FirstName = 'FName';
                acc1.LastName = 'LName'+i;
                acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
				Opportunity opp1 = new Opportunity() ;
				opp1.Name ='Test'+i;
				opp1.accountid = acc1.id;
				opp1.StageName = 'Closed Won';
				opp1.CloseDate=Date.Today();
				listacc.add(acc1);
			}         

			Test.startTest();
			insert listacc;
			Test.stopTest();
       }*/
    
    
}