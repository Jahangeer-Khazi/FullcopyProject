public class AssignRMToStudents {
    
    @AuraEnabled
    public static void ReassignStudentAssingedToRM(List<Id> selectOPManagers, Id deactiveOpManager){
        
        List<Id> listUsers = new List<Id>(); 
        List<Account> lstAcc = new List<Account>();
        List<Case> lstCase = new List<Case>();
        List<Task> lstTask = new List<Task>();
        List<Task> updatelstTask = new List<Task>();        
        Map<Id,List<Case>> mapCases= new Map<Id,List<Case>>();
        Map<Id,List<Task>> mapTasks= new Map<Id,List<Task>>();
        List<id> accID = new List<id>();
        
        //add method parameters to set collection; 
        listUsers.addAll(selectOPManagers);
        
        List<Account> listStudents = [Select ID, OwnerId, Opt_Sales_Rep__c,Credit__c FROM Account WHERE OwnerId =:deactiveOpManager];
        
        //adding cases against Account
        for(Account acc: listStudents){
            mapCases.put(acc.Id, new List<case>());
            mapTasks.put(acc.Id, new List<task>());
        }        
        List<Case> listCases = [Select Id,AccountId,OwnerId FROM Case Where Status!='Closed' AND AccountId In:mapCases.Keyset()];
        for(Case cs: listCases){            
            mapCases.get(cs.AccountId).add(cs);
        }
        
        List<Task> listTasks = [Select Id,AccountId,OwnerId,Status FROM Task Where Status!='Completed' AND AccountId In:mapTasks.Keyset()];
        for(Task ts: listTasks){
            mapTasks.get(ts.AccountId).add(ts);
        }       
        
        //user assignment to account in Round Robin
        if(!listStudents.isEmpty()){
            if(listStudents.size()>0){
                integer i=0;
                integer userCount = listUsers.size();
                for(Account ac: listStudents){
                    //system.debug('BeforeRoundRobn Id='+ac.id +' OwnerId='+ac.OwnerId);
                    //case assign
                    if(!listUsers.isEmpty()){
                        if(i<userCount-1){
                            ac.OwnerId = listUsers.get(i);
                            i=i+1;
                        }else{
                            ac.OwnerId = listUsers.get(i);
                            i=0;
                        }                        
                        lstAcc.add(ac);                        
                    }     
                }
            }  
        }
        
        
        if(!lstAcc.isEmpty()){
            if(lstAcc.size()>0){
                for(Account acc: lstAcc){
                    
                    //owner assignment to Cases if not close
                    if(mapCases.containsKey(acc.id)){
                        List<case> getLstCases = mapCases.get(acc.id);
                        if(getLstCases.size()>0){
                            for(Case cs: getLstCases){
                                cs.OwnerId = acc.OwnerId;
                                lstCase.add(cs);
                            }
                        }
                    }
                    
                    /*
                    //owner assignment to Task if not completed
                    if(mapTasks.containsKey(acc.id)){
                        List<Task> getLstTasks = mapTasks.get(acc.id);                       
                        if(getLstTasks.size()>0){
                            for(Task tsk: getLstTasks){
                                tsk.OwnerId = acc.OwnerId;                                    
                                updatelstTask.add(tsk);
                            }
                        }
                    }*/
                    
                    //creating Task against account if the credit greater than 0;
                    if(acc.Credit__c>0 && acc.Credit__c!=null){
                        Task t= new Task();
                        t.OwnerId = acc.OwnerId;
                        t.Subject = System.Label.task_intro_text;
                        t.Status = 'Open';
                        t.Priority = 'Normal';
                        t.WhatId = acc.id;
                        t.ActivityDate = system.today()+1;
                        lstTask.add(t);
                    }              
                    
                }
            }
        }
        
        
        try{
            //update accounts
            if(lstAcc.size()>0){ 
                system.debug('lstAcc----------'+lstAcc.size());
                update lstAcc;
            }
            
            //update cases
            if(lstCase.size()>0){     
                system.debug('lstCase----------'+lstCase.size());
                update lstCase;
            }
            
            //update task
            if(updatelstTask.size()>0){
                system.debug('updatelstTask----------'+updatelstTask.size());
                update updatelstTask;
            }
            
            //insert cases
            if(lstTask.size()>0){  
                system.debug('lstTask----------'+lstTask.size());
                insert lstTask;
            }
            
        } catch(Exception e) {
            System.debug('Exception ::'+e.getMessage());
        } 
        
        //deactivate user 
        try{
            User UserRec = [Select Id,Name From User Where isactive = true AND Id=:DeactiveOpManager];        
            FutureMethodUtils.updateUser(UserRec.Id);
        } catch(System.QueryException e){
            system.debug('Message'+e.getMessage());
        }       
        
    }
}