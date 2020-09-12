trigger WHJ_TaskOwnerUpdate on Contact (after update)
{
    Set<Id> set_contactId = new Set<Id>();
    List<Task> taskList = new List<Task>();
    if(trigger.isUpdate){
        
    for(Contact cont : Trigger.new)
    {
         
        
        if(cont.OwnerId!=Trigger.oldMap.get(cont.id).OwnerId && cont.Type__c == 'Teacher') {
            set_contactId.add(cont.Id);
           
        
        }
    }
    Map<Id,List<Task>> mp_ListTask = new Map<Id,List<Task>>();
    
    for(Task tsk : [Select Id,WhoId,Status from Task where WhoId IN : set_contactId])
    {
        if(mp_ListTask!=null && mp_ListTask.containsKey(tsk.WhoId))
        {
            List<Task> taskList = mp_ListTask.get(tsk.WhoId);
            taskList.add(tsk);
            mp_ListTask.put(tsk.WhoId, taskList);
        }
        else
            mp_ListTask.put(tsk.WhoId, new List<Task>{tsk});
    }
    
    
    
    for(Contact acc : Trigger.new)
    {
        if(mp_ListTask!=null && mp_ListTask.containsKey(acc.id))
        {
            
            for(Task con : mp_ListTask.get(acc.id))
            {

                if(con.Status != 'Completed')
                {
                    
                    con.OwnerId = acc.OwnerId;
                    taskList.add(con);
                }
                
            }
        }
    }
    
        if(taskList!=null && taskList.size()>0){
        update taskList;

        }
    }
}