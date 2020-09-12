global class WHJ_BatchClassForLastClassDate implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute

		String query = 'SELECT Id,  Last_Class_Date__c,OwnerId,Owner.isactive,IsOpen__c, Last_Class_taken_in_Days__c FROM Account WHERE Last_Class_taken_in_Days__c >= 14 AND IsOpen__c = false';
		return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<Account> lstAccount = (List<Account>) records;
        List<Account> lstAcc = new List<Account>();
        List<Task> lstTask = new List<Task>();
        Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'DefaultOwnerId'];
        if(!lstAccount.isEmpty()) {            
        for(Account account : records){
        	Task createTask = new Task();
            createTask.Subject = 'Dormant';
            createTask.WhatId = account.Id;
            if(account.owner.isactive == true){
            	createTask.OwnerId = account.OwnerId;    
            }else{
                createTask.OwnerId = config.Value__c;
            }
            createTask.Priority = 'Normal';
            createTask.Status = 'Open';
            createTask.Type = 'System';
            lstTask.add(createTask);
            account.IsOpen__c = true;
            lstAcc.add(account);
        }  insert lstTask;
           update lstAcc; 
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
        WHJ_BatchClassForLastClassDate feedBatch = new WHJ_BatchClassForLastClassDate();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
    
}