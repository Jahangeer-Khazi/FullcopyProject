trigger WHJ_HotRenewalTrigger on Account (After Update) {
 
                    if ( trigger.isAfter ) {
                                 if ( trigger.isUpdate ) {
                                                WHJ_HotRenewalTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
                                }
                }

    
    
}