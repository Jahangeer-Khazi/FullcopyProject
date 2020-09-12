public class WHJ_UpdateOpportunitiesBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    List<Opportunity> indiaOpps = new List<Opportunity>();
    List<String> advOppsIds = new List<String>();
    List<String> begOppsIds = new List<String>();
    Map<Id, Account> oppidsAccount = new Map<Id, Account>();
    List<User> trainingUsers = new List<User>();
    List<User> users1_2 = new List<User>();
    Integer totalOppsUpdated = 0;
    Integer totalBegUpdated = 0;
    Integer totalAdvUpdated = 0;
    Integer trainingCounter = 0;
	Integer counter1_2 = 0;
    Integer indiaOppsCount ;
    Integer advOppsCount ;
    Integer begOppsCount ;
    
    /*
	* Constructor
	*/
    public WHJ_UpdateOpportunitiesBatch(
        List<Opportunity> passedIndiaOpps,
        List<String> passedAdvOppsIds,
        List<String> passedBegOppsIds,
        Map<Id, Account> passedOppidsAccount
    ) {
        indiaOpps = passedIndiaOpps;
        advOppsIds = passedAdvOppsIds;
        begOppsIds = passedBegOppsIds;
        oppidsAccount = passedOppidsAccount;
        
         indiaOppsCount =  indiaOpps.size();
         advOppsCount =  advOppsIds.size();
         begOppsCount =  begOppsIds.size();
        system.debug('Before - Size of indiaOppsCount > ' + indiaOppsCount + ' Size of advOppsCount > ' + advOppsCount + ' Size of begOppsCount > ' + begOppsCount);
        
        // check begOppsIds, if less then 80%, add it from advOppsIds
        Integer percentage = Math.round(Decimal.valueOf(System.label.TrainingTeamPercentage) * indiaOppsCount);
        if (begOppsCount < percentage) {
            Integer extraLeadsNeeded = percentage - begOppsCount;	
            Integer loopVar = (advOppsCount - extraLeadsNeeded) - 1;
            for (Integer i = advOppsCount-1; i > loopVar; i--) {
                begOppsIds.add(advOppsIds[i]); // must be 80%
                advOppsIds.remove(i); // must be 20%
            }
        }
        
        system.debug('After - Size of indiaOppsCount > ' + indiaOppsCount + ' Size of advOppsCount > ' + advOppsIds.size() + ' Size of begOppsCount > ' + begOppsIds.size());
        
        // get all user's
        trainingUsers = [
            SELECT
            Id,Name
            FROM
            User
            WHERE
            isActive = true AND Status__c = 'Available' 
            AND UserRole.Name = :System.Label.Training_Team_Member
            ORDER BY
            Last_Assignment_Date_Time__c
            ASC NULLS FIRST
        ];
        System.debug('trainingUsers >> ' + trainingUsers);
        users1_2 = [
            SELECT
            Id,Name
            FROM
            User
            WHERE
            isActive = true AND Status__c = 'Available' 
            AND UserRole.Name = :System.Label.SalesManager_1_2
            ORDER BY
            Last_Assignment_Date_Time__c
            ASC NULLS FIRST
        ];
        System.debug('users1_2 >> ' + users1_2);
    }
    
    /* 
	* Start method, using iterable to iterate all the indiaOpps
	*/
    public Iterable<sObject> start(Database.BatchableContext bc) {
        return indiaOpps;
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> records) {
        List<Opportunity> updateOpps = new List<Opportunity>();
        List<Account> updateAccounts = new List<Account>();
        Integer trainingUsersCount = trainingUsers.size();
        Integer User1_2Count = users1_2.size();
        Integer begUpdated = 0;
    	Integer advUpdated = 0;
       
        for (Opportunity opp : records) {
            if (begOppsIds.contains(opp.Id)) {
                opp.IsAssign__c = true;
				opp.Assigned_To_Trainee__c	= System.today();
				opp.Assigned_To_Training_Team__c = true;
                if (trainingUsersCount > 0) {
                    opp.OwnerId = trainingUsers[trainingCounter].Id;
                    trainingUsers[trainingCounter].Last_Assignment_Date_Time__c = System.now();
                    trainingCounter = trainingCounter < (trainingUsersCount - 1)? trainingCounter + 1 : 0; 
                }
                else {
                    opp.OwnerId = System.Label.TL_Id_for_15_Days;
                }
                updateOpps.add(opp);
                begUpdated += 1;
				/* 
                if (oppidsAccount.containsKey(opp.id)) {
                    Account acc = oppidsAccount.get(opp.id);
                    acc.Assigned_To_Training_Team__c = true;
                    updateAccounts.add(acc);
                }*/
            }
            else if (advOppsIds.contains(opp.Id)) {
                opp.IsAssign__c = true;	
               // opp.Assigned_To_Trainee__c	= System.today();
                opp.Dead_Lead_1_2__c = true;
                if (User1_2Count > 0) {
                    opp.OwnerId = users1_2[counter1_2].Id;
                    users1_2[counter1_2].Last_Assignment_Date_Time__c = System.now();
                    counter1_2 = counter1_2 < (User1_2Count - 1)? counter1_2 + 1 : 0;  
                }
                else {
                    opp.OwnerId = System.Label.Default_User_1_2;
                }
                updateOpps.add(opp);
                advUpdated += 1;
                /*
                if (oppidsAccount.containsKey(opp.id)) {
                    Account acc = oppidsAccount.get(opp.id);
                    acc.Dead_Lead_1_2__c = true;
                    updateAccounts.add(acc);
                }
				*/
            }
        }
        
        try {
            if (updateOpps.size() > 0) {
                update updateOpps;
                system.debug('updateOpps >> ' + updateOpps);
                /*
                if (updateAccounts.size() > 0) {
                    update updateAccounts;
                    system.debug('updateAccounts >> ' + updateAccounts);
                }
				*/
                if (trainingUsers.size() > 0) {
                    update trainingUsers;
                    system.debug('trainingUsers >> ' + trainingUsers);
                }
                if (users1_2.size() > 0) {
                    update users1_2;
                    system.debug('users1_2 >> ' + users1_2);
                }
				totalOppsUpdated += updateOpps.size();
				totalBegUpdated += begUpdated;
                totalAdvUpdated += advUpdated;
            }
        }
        catch(exception e) {
            system.debug('Error in WHJ_UpdateOpportunitiesBatch at line number ' + e.getLineNumber() + ' ' + e.getMessage());
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
        String logs = 'Total India Opportunities are ' + indiaOppsCount
            		+ ' and Advanced Opportunities are before('+advOppsCount+') After(' + advOppsIds.size()+')'
            		+ ' and Begin Opportunities are before('+begOppsCount+') After(' + begOppsIds.size()+').\n'
            		+ ' Total Opportunties updated in batch are ' + totalOppsUpdated
            		+ ' and Advanced Opportunities updated are ' + totalAdvUpdated
            		+ ' and Begin Opportunities updated are ' + totalBegUpdated;
       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
      	sendTo.add(Label.AssignIndiaBatchSendTo);
      	mail.setToAddresses(sendTo);  
        mail.setSubject('Assign India Lead Batch');
        mail.setHtmlBody(logs);
        mails.add(mail);
        Messaging.sendEmail(mails);
        
       
    }
    
}