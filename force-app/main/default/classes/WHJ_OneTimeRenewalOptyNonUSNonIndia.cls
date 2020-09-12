global class WHJ_OneTimeRenewalOptyNonUSNonIndia implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id from Account where  Status__c =\''+'Active'+'\' AND Activation_Date__c > 2020-01-10  AND Credit__c < 8 AND Credit__c > 0 AND Rnwl_Opty_Count__c = 0 AND (BillingCountry != \''+'India'+'\' AND BillingCountry != \''+'IndiaV2'+'\' AND BillingCountry != \''+'United States of America'+'\' AND BillingCountry != \''+'USA'+'\' AND BillingCountry != \''+'US'+'\') AND Subscription_Flag__c = false limit 10';
        return Database.getQueryLocator(query);
        
    
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
       
        List<Account> lstacc = (List<Account>) records;
        
        List<Opportunity> lstOpty = new List<Opportunity>();
        Set<Id> SetOfAccIds = new Set<Id>();
        for(Account accnt : lstacc){
            SetOfAccIds.add(accnt.Id);
        }
        
        
        
           List<User> lstUsers = [SELECT Id, Name FROM User where UserRole.Name =:System.Label.US_Renewal_Sales_Manager AND isactive = true
                                     ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
            
        
       
        List<Opportunity> lstOppo  = [Select Id,Name,OwnerId from Opportunity Where AccountId =: SetofAccIds 
                                      AND Type = 'Renewal' ORDER BY CreatedDate DESC];
        List<User> lstUsers1;
        if(!lstOppo.isEmpty()){
            lstUsers1 = [Select Id,Name,isactive from User Where Id=: lstOppo[0].OwnerId AND isactive = true];
        }   
		
		
		
		 List<User> lstUser2 = [Select Id From User Where UserRole.Name =:System.Label.US_Renewal_Team_Leader AND isactive = true];            
            
            
        List<Account> lstAccount = [Select Id,PersonEmail,FirstName,LastName,Credit__c From Account Where Id In : SetOfAccIds ];
        Integer i = 0;
        for(Account acc : lstAccount){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Renewal - '+ acc.FirstName +' ' + acc.LastName;
            oppo.StageName = 'WIP';
            oppo.CloseDate = System.today() + 13;
            oppo.AccountId = acc.Id;
            oppo.Email__c = acc.PersonEmail;
            oppo.Type = 'Renewal';
            oppo.Renewal_Opty_No__c = 1 ;             
            if(acc.Credit__c <=4)            
            {
                oppo.Hot_Renewal__c = true;
                oppo.Hot_Renewal_Date__c = System.today();
            }
            
           
           if(!lstacc.isEmpty()) {
                if(lstOppo.size() > 0 ){
                    system.debug('##1');
                    if(!lstUsers1.isEmpty()){
                        oppo.OwnerId = lstUsers1[0].Id;
                        oppo.Do_Not_Assign__c = true;   
                        oppo.Renewal_Opty_No__c = lstOppo.size() +  1;    
                    }else{
                        oppo.OwnerId =lstUser2[0].Id;  
                        oppo.Renewal_Opty_No__c = lstOppo.size() + 1;
                    }
                    lstOpty.add(oppo);
                }else{
                    if(!lstUsers.isEmpty()){
                        if(i<lstUsers.size()-1){
                            oppo.Do_Not_Assign__c = true;   
                            oppo.OwnerId = lstUsers[i].Id;
                            lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                            i=i+1;
                        }else{
                            oppo.Do_Not_Assign__c = true;
                            oppo.OwnerId = lstUsers[i].Id;
                            lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                            i=0;
                        }
                    }else{
                        oppo.OwnerId =lstUser2[0].Id;   
                    }lstOpty.add(oppo);    
                }
            }  
        }   
        insert lstOpty;
        update lstUsers;
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
        WHJ_OneTimeRenewalOptyUS feedBatch = new WHJ_OneTimeRenewalOptyUS();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }
    
}