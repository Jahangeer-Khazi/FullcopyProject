global class WHJ_SubscriptionLeadsRenewal implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
	 global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        Date day = System.today().addDays(Integer.valueOf(System.Label.SubscriptionLeadsRenewalDay));
		Date d = date.newInstance(2020, 08, 01);
        String query = 'SELECT Id FROM Account WHERE DAY_ONLY(CreatedDate)  =: d AND Subscription_flag__c = true AND BillingCountry <> \''+System.Label.Country+'\' AND BillingCountry <> \''+System.Label.CountryV2+'\' limit 10 ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<Account> lstAccount = (List<Account>) records;
        System.debug('lstAccount::'+lstAccount);
        List<Opportunity> lstOpty = new List<Opportunity>();
        Set<Id> setofAccIds = new Set<Id>();
        Set<String> roleSet = new Set<String>();
        for(User user: [SELECT Id FROM User where (UserRole.Name =: System.Label.US_Renewal_Sales_Manager OR
                                                   UserRole.Name =: System.Label.US_Renewal_Team_Leader)])
        {
            roleSet.add(user.Id);
        }
        List<User> lstUsers = [SELECT Id,Name from User WHERE isActive = true AND Status__c = 'Available' 
                               AND Id IN: roleSet ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
        
        for(Account acc : lstAccount ){
            setofAccIds.add(acc.Id);
        }
        
        List<Payment__c> lstPayment = [Select Id from Payment__c where Account__c IN : setofAccIds];
        System.debug('lstPayment::'+lstPayment);
        if(lstPayment.isEmpty()){
            System.debug('inn');
            Integer i = 0;
            for(Account acc : [Select Id,FirstName,LastName,PersonEmail from Account where Id IN : setofAccIds] ){
                Opportunity oppo = new Opportunity();
                oppo.Name = 'Renewal - '+ acc.FirstName +' ' + acc.LastName;
                oppo.StageName = 'WIP';
                oppo.CloseDate = System.today() + 13;
                oppo.AccountId = acc.Id;
                oppo.Email__c = acc.PersonEmail;
                oppo.Type = 'Renewal';    
                if(!lstUsers.isEmpty()){
                    if(i<lstUsers.size()-1){
                        oppo.OwnerId = lstUsers[i].Id;
                        oppo.Do_Not_Assign__c = true;
                        lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                        i=i+1;
                    }else{
                        oppo.OwnerId = lstUsers[i].Id;
                        oppo.Do_Not_Assign__c = true;
                        lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                        i=0;
                    }
                }lstOpty.add(oppo);
            }insert lstOpty;
            update lstUsers;
        }
    }
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    }    
    global void execute(SchedulableContext sc) {       
        WHJ_SubscriptionLeadsRenewal feedBatch = new WHJ_SubscriptionLeadsRenewal();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }
}