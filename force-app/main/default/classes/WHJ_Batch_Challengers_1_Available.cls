global class WHJ_Batch_Challengers_1_Available implements Database.Batchable<sObject>, Schedulable{
  
    global Database.QueryLocator start(Database.BatchableContext BC) {
      
       String query = 'SELECT Id, Shifts__c FROM User WHERE Shifts__c =\'Challengers 1\'';
       return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<User> accList) {
       
        for(User acc : accList)
        {        
          acc.Status__c = 'Available';
        }
        try {
        	 update accList;
        
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    	 }
     global void execute(SchedulableContext sc) {       
        WHJ_Batch_Challengers_1_Available feedBatch = new WHJ_Batch_Challengers_1_Available();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
}