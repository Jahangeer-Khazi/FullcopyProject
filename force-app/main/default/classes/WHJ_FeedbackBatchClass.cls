/*White Hat Junior FeedBack Batch Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 24/09/2019
 *Purpose: This Batch class is to schedule a Teacher Feedback task.
 */ 


global class WHJ_FeedbackBatchClass implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        Date d = System.today().addDays(-30);
        return Database.getQueryLocator(
            'SELECT ID , Last_Teacher_Feedback_Date__c , Credit__c, OwnerId FROM Account  WHERE Last_Teacher_Feedback_Date__c =: d AND Credit__c >= 8 '
       );
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
        // process each batch of records
        List<Account> lstAccount = (List<Account>) records;
        List<Account> lstAcc = new List<Account>();
        List<Task> lstTask = new List<Task>();
        if(!lstAccount.isEmpty()) {            
        for(Account account : records){
      //      account.Last_Teacher_Feedback_Date__c = System.Today();
        	Task createTask = new Task();
            createTask.Subject = 'Teacher Feedback';
            createTask.ActivityDate = System.Today() + 2 ;
            createTask.Description = 'Please collect feedback from teacher.';
            createTask.WhatId = account.Id;
            createTask.OwnerId = account.OwnerId;
            createTask.Priority = 'Normal';
            createTask.Status = 'Open';
            createTask.Type = 'System';
            lstTask.add(createTask);
        insert lstTask;
        account.Last_Teacher_Feedback_Date__c = System.Today();
     	lstAcc.add(account);
	     update lstAcc;    
        }
		// 	
            System.debug('lstTask::'+lstTask);
            System.debug('lstAccount::'+lstAccount);

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
        WHJ_FeedbackBatchClass feedBatch = new WHJ_FeedbackBatchClass();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }

}