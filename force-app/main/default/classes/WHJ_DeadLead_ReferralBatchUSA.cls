global class WHJ_DeadLead_ReferralBatchUSA implements Database.Batchable<sObject>, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Integer Referral_Count = Integer.valueof(system.Label.Dead_Lead_Referral_Opportunity_Count.trim()); //No of referral opportunities to be assigned per Agent ,stored in custom label
        List<User> ListReffUser = [Select Id From User Where Status__c = 'Available' AND isactive = true AND UserRole.Name =:system.label.Role_Dead_Leads_Referrals_Manager_USA]; //List of User in Referral Manager Role
        Integer Lmt = Referral_Count * ListReffUser.size(); // No of Opportunities to be created in a batch
        Integer n = integer.ValueOf(System.label.Dead_Lead_Referral_Opportunity_Days);
        dateTime d = system.today().addDays(-n);
        List<Opportunity> LstAcc = [SELECT Account.Id,AccountId FROM Opportunity WHERE Type != 'Renewal' AND Account.Referral_Call__c = false AND CreatedDate <=:d  AND Stage_Won__c = 0 AND  Student_Country__c != 'IndiaV2' ORDER BY CreatedDate DESC LIMIT :Lmt];
               
        Set<String> AccIds = new Set<String>();
        for (Opportunity tmp : LstAcc) {
            AccIds.add(tmp.AccountId);
        }
        
        String query = 'SELECT Id,Class_Number__c,FirstName,LastName,PersonMobilePhone,Parent_Name__c,PersonEmail,Last_Class_Date__c,Level__c,Referral_Call__c FROM Account Where Id IN:AccIds AND Referral_Call__c = false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList) {
       
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<Account> lstAcc = new List<Account>();
        
        List<User> lstUsers = [SELECT Id, Name FROM User where Status__c = 'Available' AND UserRole.Name =:system.label.Role_Dead_Leads_Referrals_Manager_USA  
                               AND isactive = true ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST] ;  //List of User in Referral Manager Role
        List<User> lstUser2 = [Select Id From User Where UserRole.Name =:System.Label.Role_Dead_Leads_Referrals_Team_Leader_USA AND isactive = true AND Status__c = 'Available']; // User in Sales Team Leader Role
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(system.Label.RecordTypeReferral).getRecordTypeId();
       
        Integer i = 0;
        if(!accList.isEmpty()){
            for(Account acc : accList)
            {        
             Opportunity oppo = new Opportunity(); // Creating new Opportunity of Type Referral and populating values
             oppo.Name = 'Dead Lead Referral - '+ acc.FirstName +' ' + acc.LastName;
             oppo.AccountId = acc.Id;
             oppo.Email__c = acc.PersonEmail;
             oppo.Type = 'Dead Lead Referral';
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
            insert lstOpp;
            update lstAcc;
            
        }   
    }    
    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext sc) {       
        WHJ_DeadLead_ReferralBatchUSA feedBatch = new WHJ_DeadLead_ReferralBatchUSA();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
}