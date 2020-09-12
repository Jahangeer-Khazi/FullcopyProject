global class WHJ_AssignIndiaLeadsBatch implements Database.Batchable<sObject>,Schedulable , Database.Stateful {
    
    List<Opportunity> indiaOpps = new List<Opportunity>();
    List<String> advOppsIds = new List<String>();
    List<String> begOppsIds = new List<String>();
    Map<Id, Account> oppAccount = new Map<Id, Account>();
    Integer batchsize = Integer.valueOf(System.Label.BatchSizeUpdateOpportunities);
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String day15 = System.Label.Opty_less_than_15_Days; // Opty_less_than_15_Days stores -19 value in Custom Label 	
        Date d15 = System.today().addDays(Integer.valueOf(day15));
        List<Configuration__mdt> conlstRenewal= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='RoleForRenewal'];
        
       String query = 'SELECT '
            + 'Id , Name, AccountId , Account.course_short_name__c'
            + ' FROM Opportunity WHERE '
            + 'IsWon = false AND IsAssign__c = true '
            + 'AND Process_for_Conversion__c = false '
          //  + 'AND DAY_ONLY(CreatedDate) = :d15 AND Type = \''+'New Student'+'\' '
           // + 'AND Owner.UserRoleId <> \'' + conlstRenewal[0].Value__c + '\' '
           // + 'AND '
           // + '(Owner.UserRole.Name = \''+'Sales Manager'+'\' OR '
           // + 'Owner.UserRole.Name = \''+'Sales Team Leader'+'\' OR '
           // + 'Owner.UserRole.Name = \''+'Director'+'\') '
          //  + 'AND Owner.Name <> \''+'Junaid Shaikh'+'\' '
             + 'AND '
            + '(Student_Country__c = \'' + System.Label.Country + '\' OR '
            + 'Student_Country__c = \'' + System.Label.CountryV2 + '\') '
            + 'limit '
            + '20';
        
        System.debug('query >> ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> records) {
        Set<Id> accIds = new Set<Id>();
        Map<Id, Id> oppAccIds = new Map<Id, Id>();
        for (Opportunity opp : records) { 
            if (opp.Account.course_short_name__c != Null) {
                indiaOpps.add(opp);
               
                if(System.Label.Courses_1_2Team.containsIgnoreCase(opp.Account.course_short_name__c)) { 
                    advOppsIds.add(opp.Id);    
                }
                if(System.Label.CoursesTrainingTeam.containsIgnoreCase(opp.Account.course_short_name__c)) {
                    begOppsIds.add(opp.Id);  
                }
                if (opp.AccountId != null) {
                	oppAccIds.put(opp.AccountId, opp.Id);
                	accIds.add(opp.AccountId);
            	}
            } 
        }
         system.debug('indiaOpps'+indiaOpps);
        for (Account acc : [Select Id, Dead_Lead_1_2__c, Assigned_To_Training_Team__c FROM Account WHERE id IN :accIds]) {
            oppAccount.put(oppAccIds.get(acc.id), acc);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
        System.debug('oppAccount>> ' + oppAccount);
        System.debug('India List '+indiaOpps );
        System.debug('India List Size '+indiaOpps.size());
        System.debug('advOpps List '+advOppsIds );
        System.debug('advOpps List Size '+advOppsIds.size() );
        System.debug('beginOpps List '+begOppsIds );
        System.debug('beginOpps List Size '+begOppsIds.size() );
        WHJ_UpdateOpportunitiesBatch childBatch = new WHJ_UpdateOpportunitiesBatch(indiaOpps, advOppsIds, begOppsIds, oppAccount);
        ID childBatchId = Database.executeBatch(childBatch, batchsize); 
        system.debug('childBatchId >> ' + childBatchId);
    }   
    global void execute(SchedulableContext sc) {       
        WHJ_AssignIndiaLeadsBatch feedBatch = new WHJ_AssignIndiaLeadsBatch();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }   
}