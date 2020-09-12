global class WHJ_TaskforUnPairedBatch implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date Dat1 = date.today().adddays(3);
        String query = 'Select Id, Batch_Id__c , Pair_Found__c , OwnerId ,Owner.isactive from Account where Batch_Id__c != null AND Pair_Found__c = false AND DAY_ONLY(Batch_Start_Date__c) =: Dat1';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> accList) {
        List<Task> taskList = new List<Task>();
        List<User> lstUser2 = [Select Id From User Where UserRole.Name =:system.Label.Role_Student_Ops_Team_Leader];
        if(!accList.isEmpty())
        {
            for(Account acc : accList)
            {        
                Task tsk = new Task();
                tsk.Subject = 'Unpaired Student';
                tsk.WhatId = acc.Id; //Related To
                if(acc.owner.isactive == true){
                    tsk.OwnerId = acc.OwnerId;    //Assigned to
                }else{
                    tsk.OwnerId = lstUser2[0].Id;
                }
                tsk.Status = 'New';
                tsk.Priority = 'High';  
                tsk.ActivityDate = date.today();
                tsk.Description = 'The respective student is unpaired and have batch start date as tomorrow.';
                taskList.add(tsk);
                
            }
            try {
                insert taskList;
                
            } catch(Exception e) {
                System.debug(e);
            }
        }
    }   
    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext sc) {       
        WHJ_TaskforUnPairedBatch feedBatch = new WHJ_TaskforUnPairedBatch();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
}