trigger WHJ_UserTrigger on User (after update) {
    Set<Id> SetOfOldMgr = new Set<Id>();
    Set<Id> SetOfNewMgr = new Set<Id>();
    for(User user : trigger.new){
        SetOfOldMgr.add(Trigger.oldMap.get(user.id).ManagerId);
        SetOfNewMgr.add(Trigger.newMap.get(user.id).ManagerId);  
    }
    
    List<User> OldMgr = [Select Id,Department__c from User Where Id =: SetOfOldMgr];
    List<User> NewMgr = [Select Id,Department__c from User Where Id =: SetOfNewMgr];
    for(User u : trigger.new){
        if ( trigger.isAfter ) {
            if ( trigger.isUpdate && (Trigger.oldMap.get(u.id).ManagerId <> Trigger.newMap.get(u.id).ManagerId )){
                if(!OldMgr.isEmpty() && !NewMgr.isEmpty() && OldMgr[0].Department__c <> NewMgr[0].Department__c
                   && OldMgr[0].Department__c <> null && NewMgr[0].Department__c <> null){
                       WHJ_UserTriggerHandler.onAfterUpdate(u.id,Trigger.oldMap.get(u.id).ManagerId);
                   }
            }
        }
    }
}