trigger WHJ_CaseTrigger on Case (before insert,after insert,after update) {
    try{
    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            //System.enqueuejob(new WHJ_CaseHandlerForZendesk(trigger.new));
        }
    }
	// For Processing the case record created need to pass zendesk. 
    if(System.IsBatch() == false && System.isFuture() == false){ 
        if ( trigger.isAfter ) {
            if(trigger.isInsert) {
                System.debug('Is Insert Trigger');
                System.enqueuejob(new WHJ_CaseHandlerForZendesk(trigger.new,'Case_To_Zendesk'));
            }     
        }
    }
    
    //CH01 Start #25-08-2020# Jahangeer Khazi Added a Logic to change ownerid that is coming from zendesk.
  /*  if(Trigger.isInsert && Trigger.isBefore){
        System.debug('Before trigger executed on Case');
        List<Case> caseList = new List<Case>();
        Set<String> emailList = new Set<String>();
        for(Case cList:Trigger.New){
            if(cList.Zendesk_Support_Ticket_Requester_Email__c != null){
            	emailList.add(cList.Zendesk_Support_Ticket_Requester_Email__c);
            }
        }
        System.debug('EmailList:'+emailList);
        if(emailList.size()>0) 
        {
        	Map<Id,Account> mapStudentIds = new Map<Id,Account>([Select id,Name,OwnerId,PersonEmail from Account where PersonEmail IN : (emailList) ]);
        	for(Id i : mapStudentIds.keySet()){
            	for(Case c: Trigger.new){
                	if(c.Zendesk_Support_Ticket_Requester_Email__c == mapStudentIds.get(i).PersonEmail ){
                   	c.OwnerId = mapStudentIds.get(i).OwnerId;
                   	System.debug('***********'+mapStudentIds.get(i).id);
                   	c.AccountId = mapStudentIds.get(i).id;
                   //caseList.add(c);
                	}
            	}
        	}
        }
        //if(caseList.size()>0)
            //update caseList;
    }*/
    }catch(Exception e){
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
    /*if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            
            Id stuaccountId=[select id,accountid from Case where id=:Trigger.New[0].Id ].accountid;

            System.debug('stuaccountId'+stuaccountId);            
            // AND Email =:readValueAsResults.ReferralManager
            String LifecycleStage=[select id,Lifecycle_Stage__c from account where id=:stuaccountId].Lifecycle_Stage__c;
                System.debug('LifecycleStage'+LifecycleStage);  
            if(LifecycleStage=='Paid'){
                User RefUser = [Select id from User where (UserRole.Name =:system.label.Role_Referral_Manager 
                                                       OR UserRole.Name =:system.label.Role_Referral_Manager_USA )];
                System.debug('refusr'+RefUser);
                Case caseToUpdate = [SELECT Id, OwnerId FROM Case where id=:Trigger.New[0].Id];
                caseToUpdate.OwnerId=RefUser.Id;
                
                List<case> caseToUpdateList=new List<case>();
                caseToUpdateList.add(caseToUpdate);
                System.debug('caseToUpdateList'+caseToUpdateList);
                update caseToUpdateList; 
                
            }else if(LifecycleStage=='Trial Student'){
                User RefUser = [Select id from User where (UserRole.Name =: 'Sales Manager' )];
       
                Case caseToUpdate = [SELECT Id, OwnerId FROM Case where id=:Trigger.New[0].Id];
                caseToUpdate.OwnerId=RefUser.Id;
                
                List<case> caseToUpdateList=new List<case>();
                caseToUpdateList.add(caseToUpdate);
                
                update caseToUpdateList; 
                
            }else{
                Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
                
                User usr = new User(LastName = 'KIRAN',
                                    FirstName='RAJ',
                                    Alias = 'KIRA',
                                    Email = 'rajkiran@gmail.com',
                                    Username = 'rajkiran@gmail.com',
                                    ProfileId = profileId.id,
                                    TimeZoneSidKey = 'GMT',
                                    LanguageLocaleKey = 'en_US',
                                    EmailEncodingKey = 'UTF-8',
                                    LocaleSidKey = 'en_US'
                                   );
                //insert usr;
                
                Case caseToUpdate = [SELECT Id, OwnerId FROM Case where id=:Trigger.New[0].Id];
                //caseToUpdate.OwnerId=usr.Id;
                
                List<case> caseToUpdateList=new List<case>();
                caseToUpdateList.add(caseToUpdate);
                
                update caseToUpdateList; 
            }
        }        
    }*/
}