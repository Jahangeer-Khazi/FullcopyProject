global class WHJ_BatchIndia2ShiftUnavailable implements Database.Batchable<sObject>,Schedulable {
  
    global Database.QueryLocator start(Database.BatchableContext BC) {
      
       String query = 'SELECT Id, Shifts__c FROM User WHERE Shifts__c =\'INDIA_2\'';
       return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<User> accList) {
       
        for(User acc : accList)
        {        
          acc.Status__c = 'Unavailable';
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
        WHJ_BatchIndia2ShiftUnavailable feedBatch = new WHJ_BatchIndia2ShiftUnavailable();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
}