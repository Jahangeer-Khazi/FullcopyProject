trigger SendEmailOnLiveChat on LiveChatTranscript (before update){//, after update) {        
    //system.debug(trigger.isinsert);        
    //system.debug(trigger.isupdate);
    //Set<Id> transcriptIdsSet = new Set<Id>();
    for(LiveChatTranscript lct : trigger.new){
        lct.Notify_User__c = true;
      //  system.debug('old notify value::: '+ Trigger.oldMap.get(lct.Id).Notify_User__c);
        if(Trigger.oldMap.get(lct.Id).Notify_User__c == false){
        	MyBellNotification.notifyCurrentUser(lct.OwnerId,lct.Name);
        }
    }
    }