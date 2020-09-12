global class WHJ_OpportunityAssignBatch implements Database.Batchable<sObject>, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime Hour1 = Datetime.now().addHours(-1);  // pick last 1 hour
        String query = 'SELECT Id,Name,Owner_Assigned__c,Student_Country__c FROM Opportunity Where Type =\'New Student\' AND Owner_Assigned__c = false AND CreatedDate >=: Hour1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        Set<String> regionset = new Set<String>();
        String salesRegionString = '';
        for(Opportunity opp : oppList) {
            regionset.add(WHJ_Utils.getSalesRegion(opp.Student_Country__c));  //add student country to region set
        }
        Map<Id, User> userMapToBeUpdated = new Map<Id, User>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        salesRegionString = '\''+String.join(new List<String>(regionset),'\',\'')+'\'';
        
        String soql = 'SELECT Id, Name ,Sales_Region__c FROM User where Status__c = \'Available\' AND Sales_Region__c includes ('+salesRegionString+') AND UserRole.Name =\''+system.label.Role_Sales_Manager+'\' AND isactive = true ORDER BY Last_Assignment_Date_Time__c ASC';
        List<User> usrList = Database.query(soql);
        
        if(!oppList.isEmpty()) {
            for(Opportunity oppo : oppList) {
                Integer index = 0;
                String regionCode = WHJ_Utils.getSalesRegion(oppo.Student_Country__c);
                User usrDetails;
                for(User usr: usrList) { 
                    if(usr.Sales_Region__c.contains(regionCode)) {
                        usrDetails = usr;
                        break;
                    }
                    index++;
                }
                if(usrDetails != null) {
                    usrList.remove(index);
                    usrList.add(usrDetails);
                }
                String defaultManagerId = WHJ_Utils.getDefaultManagerId(oppo.Student_Country__c, 'New'); //get default Sales Manager by region
                oppo.OwnerId = usrDetails !=null ? usrDetails.Id : defaultManagerId ;  //Assign Sales Manager
                oppo.Owner_Assigned__c = true;
                User usrWithLastAssignmentDate = new User();  
                usrWithLastAssignmentDate.id = usrDetails !=null ? usrDetails.Id : defaultManagerId ; // Assign Sales Manager if found else assign default manager by region
                usrWithLastAssignmentDate.Last_Assignment_Date_Time__c = system.now();   			//update last assignment date on Sales Manager
                userMapToBeUpdated.put(usrWithLastAssignmentDate.id, usrWithLastAssignmentDate);
                lstOpp.add(oppo);  		//add opportunity to update list
                
            }
            update lstOpp;  		//Update opportunities with new owner
            if(userMapToBeUpdated.size()>0) {
                update userMapToBeUpdated.values();  		//Update users
            }
        }   
    }    
    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext sc) {       
        WHJ_OpportunityAssignBatch feedBatch = new WHJ_OpportunityAssignBatch();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
}