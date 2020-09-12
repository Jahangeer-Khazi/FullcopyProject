/*White Hat Junior Update Opportunity MobileField trigger
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 25/09/2019
 *Purpose: after insert, after update Trigger is to update Opportunity MobileField when student mobile get update or insert. 
 */

trigger WHJ_UpdateOpportunityMobileField on Account (after insert, after update) {
    
    System.debug('Is IsBatch-- ' + System.IsBatch());
    System.debug('Is System.isFuture--- ' + System.isFuture());
    if(System.IsBatch() == false && System.isFuture() == false){ 
        if ( trigger.isAfter ) {
            if(trigger.isUpdate) {
                System.debug('Is Update Trigger');
                System.debug('Record Size for old records:'+Trigger.old.size());
                System.debug('Record Size for new records:'+Trigger.new.size());
                System.debug('Batch value:'+ System.IsBatch());
                System.debug('Future Value:'+ System.isFuture());
                //System.enqueuejob(new WHJ_AccountTriggerHandler(trigger.new, trigger.oldMap));
                WHJ_AccountTriggerHandlerChaining.handleBulkUpdate(trigger.new,trigger.oldMap);
            } 
            if(trigger.isInsert) {
                System.debug('Is Insert Trigger');
                System.enqueuejob(new WHJ_AccountTriggerHandler(trigger.new));
            }     
        }
    }
    
    if ( trigger.isAfter ) {
        if(trigger.isUpdate) {
            WHJ_SLABreachMailSend.SLAbreachForStudentRM(trigger.new, trigger.oldMap);  
            WHJ_SLABreachMailSendToAuditTeam.SLAbreachForStudentRM(trigger.new, trigger.oldMap); 
            WHJ_AccountController.onStudentActive(trigger.new, trigger.oldMap);
            WHJ_AccountController.onBatchUpdate(trigger.new, trigger.oldMap);
        }
    }
    
    // Loop through all account updates in this trigger (there will generally be one)
    String OldMobile;
    String OldEmail;
    for(Account acct: Trigger.new) {
      if(Trigger.IsUpdate){
           Account OldAccount = Trigger.oldMap.get(acct.Id);
           OldMobile = OldAccount.PersonMobilePhone;
           OldEmail = OldAccount.PersonEmail;
      } else{
          OldMobile = null;
          OldEmail = null;
      } 
   
      if(acct.PersonMobilePhone != OldMobile || acct.PersonEmail != OldEmail){
      List<Opportunity> oppList = [SELECT id, MobileNumber__c,Email__c FROM Opportunity WHERE Accountid = :acct.id AND (MobileNumber__c != :acct.PersonMobilePhone OR Email__c != :acct.PersonEmail) AND IsClosed=false AND IsWon =false]; // Find all the opportunities for this account.
    for(integer i = 0 ; i < oppList.size(); i++){
      oppList[i].MobileNumber__c = acct.PersonMobilePhone   ; // Update all opportunities with the new phone number.
      oppList[i].Email__c = acct.PersonEmail    ;
        }
    update oppList;
      }
  
  } 
}