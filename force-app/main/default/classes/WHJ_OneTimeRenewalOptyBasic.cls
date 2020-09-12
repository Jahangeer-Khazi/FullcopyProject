/**
 * @File Name          : WHJ_OneTimeRenewalOptyBasic.cls
 * @Description        : 
 * @Author             : Harsh Gughane
 * @Group              : 
 * @Last Modified By   : Harsh Gughane
 * @Last Modified On   : 5/25/2020, 7:00:34 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/23/2020   Harsh Gughane     Initial Version
**/
global class WHJ_OneTimeRenewalOptyBasic implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Account__r.Id from Payment__c where  Account__r.Status__c =\''+'Active'+'\' AND Account__r.Activation_Date__c > 2020-01-10  AND Account__r.Credit__c < 8 AND Package_Name__C = \''+'Basic'+'\' AND Account__r.Rnwl_Opty_Count__c = 0 AND ( Account__r.BillingCountry = \''+'India'+'\' OR Account__r.BillingCountry = \''+'IndiaV2'+'\' ) limit 50';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Payment__c> records){
        // process each batch of records
       
        List<Payment__c> lstPayment = (List<Payment__c>) records;
        
        List<Opportunity> lstOpty = new List<Opportunity>();
        Set<Id> SetOfAccIds = new Set<Id>();
        for(Payment__c pay : lstPayment){
            SetOfAccIds.add(pay.Account__c);
        }
        
        
        List<Configuration__mdt> conlstRenewal= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='RoleForRenewal'];
        
        List<User> lstUsers = [SELECT Id,Name,Last_Assignment_Date_Time__c from User WHERE isActive = true AND Status__c = 'Available' 
                               AND UserRoleId =: conlstRenewal[0].Value__c ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
        
        List<Opportunity> lstOppo  = [Select Id,Name,OwnerId from Opportunity Where AccountId =: SetofAccIds 
                                      AND Type = 'Renewal' ORDER BY CreatedDate DESC];
        List<User> lstUsers1;
        if(!lstOppo.isEmpty()){
            lstUsers1 = [Select Id,Name,isactive from User Where Id=: lstOppo[0].OwnerId AND isactive = true];
        }   
		
		
		
		
            List<User> lstUser2 = [Select Id From User Where UserRole.Name =:System.Label.Role_Renewals_Lead AND isactive = true]; 
		
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
            
           
           if(!lstPayment.isEmpty()) {
                if(lstOppo.size() > 0 ){
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
        WHJ_OneTimeRenewalOptyBasic feedBatch = new WHJ_OneTimeRenewalOptyBasic();
        ID batchprocessid = Database.executeBatch(feedBatch);
    }
    
}