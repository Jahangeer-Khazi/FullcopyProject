/**
 * @File Name          : WHJ_BatchClassForRevenue.cls
 * @Description        : 
 * @Author             : Harsh Gughane
 * @Group              : 
 * @Last Modified By   : Harsh Gughane
 * @Last Modified On   : 4/30/2020, 7:38:37 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/30/2020   Harsh Gughane     Initial Version
**/
global class WHJ_BatchClassForRevenue implements Database.Batchable<sObject>,Schedulable, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
       // string uid='0051s000000HuhlAAC';
       Set<String> roleSet = new Set<String>();
	for(Configuration__mdt conlst: [SELECT Value__c FROM Configuration__mdt where (Name__c ='SalesRepRole' OR 
                                       						       			   Name__c ='SalesTeamLeader' OR
  		                                                                       Name__c ='RoleForRenewal'OR
  		                                                                       Name__c ='RoleForUSRenewalLead'OR
  		                                                                       Name__c ='RoleForUSRenewal'OR
  		                                                                       Name__c ='ConversionTeamLead'OR
  		                                                                       Name__c ='ConversionTeamMemb'OR
  		                                                                       Name__c ='TrainingTeamLeader'OR
  		                                                                       Name__c ='TrainingTeamMember')]){
               roleSet.add(conlst.Value__c);
        System.debug('conlst.Value__c::'+conlst.Value__c);
             }
        String query;
        if(Test.isRunningTest()){
            query = 'SELECT Id , Name ,Department__c,Userrole.Name from User where isActive = true and UserRoleId IN: roleSet limit 1' ;
        }else{
            query = 'SELECT Id , Name ,Department__c,Userrole.Name from User where isActive = true and UserRoleId IN: roleSet' ;
        }
        
		return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<User> records){
        // process each batch of records
        Set<Id> setofUser = new set<Id>();
        Date d = System.today().addDays(-1);
        List<Sales_Revenue_Report__c> lstrevenue = new List<Sales_Revenue_Report__c>();
        for(User userobj : records){
            setofUser.add(userobj.Id);
        }
        List<Payment__c> pay = [SELECT Id, Name, Amount__c, Opportunity__r.OwnerId,CreatedDate FROM Payment__c 
                                where Opportunity__r.OwnerId in : setofUser AND DAY_ONLY(convertTimezone(CreatedDate)) =: d];
        Double  grandTotal=0;
        for(Payment__c a : pay){
            if(a.Amount__c!=null){
                grandtotal = grandtotal + double.valueof(a.Amount__c);    
            }
        }
        List<Opportunity> lstOppoCreated = [SELECT Id, Name,OwnerId,CreatedDate FROM opportunity where DAY_ONLY(convertTimezone(CreatedDate)) =: d  And OwnerId in :setofUser];
        List<Opportunity> lstOppoConverted = [SELECT Id, Name,OwnerId,Actual_Close_Date__c FROM opportunity where Actual_Close_Date__c =: d And OwnerId in :setofUser];    
        
        Sales_Revenue_Report__c revenue = new Sales_Revenue_Report__c();
        revenue.User__c = records[0].Id;
		revenue.Role__c = records[0].Userrole.Name;
        revenue.Department__c = records[0].Department__c;
        revenue.Date__c = d;
        revenue.Revenue__c = grandtotal;
        revenue.Opportunity_Created__c = lstOppoCreated.size();
        revenue.Opportunity_Converted__c = lstOppoConverted.size();
        lstrevenue.add(revenue);
        insert lstrevenue;
        System.debug('lstrevenue::'+lstrevenue);
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
        WHJ_BatchClassForRevenue feedBatch = new WHJ_BatchClassForRevenue();
        ID batchprocessid = Database.executeBatch(feedBatch,1);
    }
    
}