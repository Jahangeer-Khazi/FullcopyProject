global class WHJ_HotRenewalBatch implements Database.Batchable<sObject>,Schedulable, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id FROM Opportunity WHERE IsWon = false AND Account.Credit__c > 0 AND Account.Credit__c <= 4 AND Hot_Renewal__c = false AND Hot_Renewal_Date__c = Null AND Type =\''+System.Label.Renewal+'\' ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> records){
        // process each batch of records
        List<Opportunity> lstOpportunity = (List<Opportunity>) records;
        List<Opportunity> lstOpty = new List<Opportunity>();
        
        if(!lstOpportunity.isEmpty()) {
            for(Opportunity oppo : lstOpportunity){
                oppo.Hot_Renewal__c = true;
                oppo.Hot_Renewal_Date__c = System.today();
                lstOpty.add(oppo);
            } update lstOpty;
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
        WHJ_HotRenewalBatch feedBatch = new WHJ_HotRenewalBatch();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }
}