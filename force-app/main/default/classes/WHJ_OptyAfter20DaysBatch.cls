global class WHJ_OptyAfter20DaysBatch implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String day20 = System.Label.Opty_before_20_Days;        // Opty_before_20_Days stores -13 value in Custom Label 	
        Date d20 = System.today().addDays(Integer.valueOf(day20));
        List<Configuration__mdt> conlstRenewal= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='RoleForRenewal'];

        String query = 'SELECT Id FROM Opportunity WHERE IsWon = false AND Process_for_Conversion__c = false AND Assigned_To_Trainee__c <> Null AND Assigned_To_Trainee__c <= : d20  AND Owner.UserRoleId <> \''+conlstRenewal[0].Value__c+'\' AND (Student_Country__c = \''+System.Label.Country+'\' OR Student_Country__c = \''+System.Label.CountryV2+'\') limit 10000';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> records){
        // process each batch of records
        List<Opportunity> lstOpportunity = (List<Opportunity>) records;
        List<Opportunity> lstOpty = new List<Opportunity>();
        Set<String> roleSet = new Set<String>();
        for(User user: [SELECT Id FROM User where (UserRole.Name =: System.Label.Conversion_Team_Leader OR 
                                                   UserRole.Name =: System.Label.Conversion_Team_Member)])
        {
            roleSet.add(user.Id);
        }
        List<User> lstUsers = [SELECT Id,Name from User WHERE isActive = true AND Status__c = 'Available' 
                               AND Id IN: roleSet ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
        if(!lstOpportunity.isEmpty()) {
            Integer i = 0;
            for(Opportunity oppo : lstOpportunity){
                if(!lstUsers.isEmpty()){
                    if(i<lstUsers.size()-1){
                        oppo.OwnerId = lstUsers[i].Id;
                        oppo.Process_for_Conversion__c = true;
                        oppo.Assigned_To_Conversion__c = System.today();
                        lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                        i=i+1;
                    }else{
                        oppo.OwnerId = lstUsers[i].Id;
                        oppo.Process_for_Conversion__c = true;
                        oppo.Assigned_To_Conversion__c = System.today();
                        lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                        i=0;
                    }
                }else{
                    oppo.OwnerId = System.Label.TL_Id_for_20_Days;
                    oppo.Process_for_Conversion__c = true;
                    oppo.Assigned_To_Conversion__c = System.today();
                }
                lstOpty.add(oppo);
            } update lstOpty;
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
        WHJ_OptyAfter20DaysBatch feedBatch = new WHJ_OptyAfter20DaysBatch();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }
    
}