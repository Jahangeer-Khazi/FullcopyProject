/*White Hat Junior Opportunity Trigger
*Created By: HGHUGHANE

/*Created Date: 01/06/2020
*Release No: 1  
*Purpose: After insert, After update trigger to create Opportunity Contact Role for Renewal Opportunity and make Webhook callout.
*/
trigger WHJ_OpportunityTrigger on Opportunity (after insert,after update) {
    
    //
    if(trigger.isUpdate) {
        //
        WHJ_SLABreachMailSendToAuditTeam.onAfterUpdate(trigger.new, trigger.oldMap);
        WHJ_OpportunityHandlerController.UpdateReferralWonCount(trigger.new, trigger.oldMap);
        if(System.IsBatch() == false && System.isFuture() == false){ 
            WHJ_OpportunityHandlerController.onAfterUpdateForSalesken(Trigger.new, trigger.oldMap);
        }
    }
    
    if (trigger.isInsert) {
        if (trigger.isAfter) {
            //Future method for Salesken
            if(System.IsBatch() == false && System.isFuture() == false){ 
                WHJ_OpportunityHandlerController.onAfterInsertForSalesken(Trigger.new);    
            }
        }
    }
    
    //Iterate over Opportunity trigger
    for(Opportunity oppo : trigger.new){
        //Check Trigger Context Variables
        //
        if ( trigger.isAfter ) {
            //Check Trigger Context Variables and type
            if ( trigger.isInsert && oppo.Type == 'Renewal') {
                WHJ_OpportunityHandlerController.onAfterInsert(trigger.new);
            } 
            
            if ( trigger.isInsert && oppo.Referral_Customer__c != null) {
               WHJ_OpportunityHandlerController.populateAccountIdLookup(trigger.new); //if opportunity is referred one then populate referred account id
            }
            
            /*if ( trigger.isInsert && oppo.Referral_Manager__c != null) {
            system.debug('###4564646');
            WHJ_OpportunityHandlerController.AssignRefmanagerAsOwner(trigger.new); //if opportunity is referred one then populate referred account id
            system.debug('###1');
            }*/
            
        }
        //Check Trigger Context Variables
        if ( trigger.isAfter ) {
            //Check Trigger Context Variables and check if below fields get update 
            if ( trigger.isUpdate && 
                ((Trigger.oldMap.get(oppo.id).StageName <> Trigger.newMap.get(oppo.id).StageName) || 
                 (Trigger.oldMap.get(oppo.id).Closure_Comments__c <> Trigger.newMap.get(oppo.id).Closure_Comments__c) ||
                 (Trigger.oldMap.get(oppo.id).OwnerId <> Trigger.newMap.get(oppo.id).OwnerId))){
                     //Call onAfterUpdateCallout method 
                     if(System.IsBatch() == false && System.isFuture() == false){ 
                         WHJ_OpportunityHandlerController.onAfterUpdateCallout(trigger.new);
                     }
                 } 
            
            if ( trigger.isUpdate && (Trigger.oldMap.get(oppo.id).SendMailto_TL_Director_VP__c <> Trigger.newMap.get(oppo.id).SendMailto_TL_Director_VP__c) && (Trigger.newMap.get(oppo.id).SendMailto_TL_Director_VP__c == true)) {
                WHJ_SLABreachMailSend.onAfterUpdate(trigger.new);
                
            }
        }        
    }
}