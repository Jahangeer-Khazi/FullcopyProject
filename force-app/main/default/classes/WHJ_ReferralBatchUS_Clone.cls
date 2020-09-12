/*
 * Created by 		: Jahangeer Khazi.
 * Created Date 	: 16/08/2020
 * Class Name		: WHJ_ReferralBatchUS_Clone
 * Test Class   	: 
 * Test Coverage	: 
 * Change History	: 
 * 					
*/
global class WHJ_ReferralBatchUS_Clone implements Database.batchable<sObject>,Database.stateful {
    
	 global Database.QueryLocator start(Database.BatchableContext BC)
     {
         List<String> indiaRegionList = new List<String>();
         String indiaRegionNames = System.Label.India_Region;
         
         if(indiaRegionNames!=null && indiaRegionNames.contains(',')){
              indiaRegionList =  indiaRegionNames.split(',');    
    	 }

         Integer Referral_Count = Integer.valueof(system.Label.Referral_Opportunity_Count.trim());
         List<User> ListReffUser = [Select Id From User Where Status__c = 'Available' AND isactive = true AND UserRole.Name =:system.label.Role_Referral_Manager_USA]; 
         //Integer Lmt = Referral_Count * ListReffUser.size(); 
         
         List<AggregateResult> LstAcc = [SELECT Account__r.Id FROM Booking__c WHERE Is_Trial__c = false AND CreatedDate = LAST_N_DAYS:60 AND Account__r.BillingCountry NOT IN : indiaRegionList
										AND Account__r.Referral_Call__c = false AND Account__r.Activation_Date__c != LAST_N_DAYS:15 GROUP BY Account__r.Id Order by count(Name) desc LIMIT :1];//Customers picked up in descending order of count of classes taken in last 30 days
         
         Set<String> AccIds = new Set<String>();
         for (AggregateResult tmp : LstAcc) 
         {
            AccIds.add(tmp.Id);
         }
         System.debug('Account Ids:'+AccIds);
        
        String query = 'SELECT Id,Class_Number__c,FirstName,LastName,PersonMobilePhone,Parent_Name__c,PersonEmail,Last_Class_Date__c,Level__c,Referral_Call__c FROM Account Where Id IN:AccIds AND Referral_Call__c = false';
        return Database.getQueryLocator(query);
        
	}
    
     global void execute(Database.BatchableContext BC, List<Account> accList)
     {
        System.debug('Getting the Account records from Start method:'+accList.size());
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<Account> lstAcc = new List<Account>();
        
        List<User> lstUsers = [SELECT Id, Name FROM User where Status__c = 'Available' AND UserRole.Name =:system.label.Role_Referral_Manager_USA  
                               AND isactive = true ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST] ;  //List of User in Referral Manager Role
        List<User> lstUser2 = [Select Id From User Where UserRole.Name =:System.Label.Role_Referral_Team_Leader_USA AND isactive = true]; // User in Sales Team Leader Role
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(system.Label.RecordTypeReferral).getRecordTypeId();
       
        Integer i = 0;
        if(!accList.isEmpty()){
            for(Account acc : accList)
            {        
             Opportunity oppo = new Opportunity(); // Creating new Opportunity of Type Referral and populating values
             oppo.Name = 'Referral - '+ acc.FirstName +' ' + acc.LastName;
             oppo.AccountId = acc.Id;
             oppo.Email__c = acc.PersonEmail;
             oppo.Type = 'Referral';
             oppo.StageName = 'WIP';
             oppo.CloseDate = System.today() + 13;
             oppo.Last_Class_Date__c = acc.Last_Class_Date__c;
             oppo.MobileNumber__c = acc.PersonMobilePhone;
             oppo.Last_Class_Number__c = acc.Class_Number__c;
             oppo.RecordTypeId = oppRecordTypeId;
             oppo.SendMailSLAbreach__c = false;
             oppo.Do_Not_Assign__c = true;
             //User assignment in Round Robin
             if(!lstUsers.isEmpty()){
                 if(i<lstUsers.size()-1){  
                     oppo.OwnerId = lstUsers[i].Id;
                     lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                     update lstUsers[i];
                     i=i+1;
                   
                     
                 }else{
                     oppo.OwnerId = lstUsers[i].Id;
                     lstUsers[i].Last_Assignment_Date_Time__c = System.now();
                     update lstUsers[i];
                     i=0;
                     
                     
                 }
             }else{
                 oppo.OwnerId =lstUser2[0].Id;   //If no users found , assigning to Team Leader
             }
             lstOpp.add(oppo);
             acc.Referral_Call__c = true;
             lstAcc.add(acc);
             
            }
            if(lstOpp.size()>0)
            {
                Database.saveResult[] saveResultList = Database.insert(lstOpp, false);
                for(Database.SaveResult sr : saveResultList)
                {
                    if(sr.isSuccess())
                    	System.debug('Successfully insert Opportunity Record:'+sr.getId());
                    else{
                        for(Database.Error err : sr.getErrors()){
                            System.debug('Following errors are occured');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        }
                       }
                }
            }
            if(lstAcc.size()>0)
            {
                Database.saveResult[] saveResultList = Database.update(lstAcc);
                for(Database.SaveResult sr : saveResultList)
                {
                    if(sr.isSuccess())
                    	System.debug('Successfully Updated Student Record:'+sr.getId());
                    else{
                        for(Database.Error err : sr.getErrors()){
                            System.debug('Following errors are occured');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        }
                       }
                }
            }
            
            //insert lstOpp;
            //update lstAcc;
            
        }   
     }
    
     global void finish(Database.BatchableContext BC)
     {
		 
   		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
   		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   		String[] toAddresses = new String[] {a.CreatedBy.Email};
   		mail.setToAddresses(toAddresses);
   		mail.setSubject('Apex Sharing Recalculation ' + a.Status);
   		mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	 }

}