/**
 * @File Name          : WHJ_RenewalTrigger.trigger
 * @Description        : 
 * @Author             : Harsh Gughane
 * @Group              : 
 * @Last Modified By   : Harsh Gughane
 * @Last Modified On   : 7/9/2020, 7:09:28 PM
 * Ver       Date            Author                 Modification
 * 1.0    7/9/2020   Harsh Gughane     Initial Version
**/
trigger WHJ_RenewalTrigger on Account (after update) {
   /* Set<Id> SetofAccId = new Set<Id>();
    
    Datetime BookingDate;
    Datetime PaymentDate;
    Datetime StudentModifiedDate;
    for(Account account : trigger.new){
        if ( trigger.isUpdate && (Trigger.oldMap.get(account.id).Credit__c <> Trigger.newMap.get(account.id).Credit__c)) {
            SetofAccId.add(account.Id);
        }
    }
      
    List<Booking__c> lstBooking = [Select Id,CreatedDate from Booking__c where Account__c =: SetofAccId ORDER BY CreatedDate DESC];
    if(!lstBooking.isEmpty()){
        BookingDate = lstBooking[0].CreatedDate;
    }
    List<Payment__c> lstPayment = [Select Id,CreatedDate from Payment__c where Account__c =: SetofAccId ORDER BY CreatedDate DESC];
    if(!lstPayment.isEmpty()){
        PaymentDate = lstPayment[0].CreatedDate;
    }
    
    for(Account acc : trigger.new){
        if ( trigger.isAfter ) {

            if ( trigger.isUpdate && (Trigger.oldMap.get(acc.id).Credit__c <> Trigger.newMap.get(acc.id).Credit__c )
                && (Trigger.newMap.get(acc.id).Credit__c == 4 )) {
                    WHJ_HotRenewalTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
                }     
            
            if((BookingDate > PaymentDate) && (BookingDate < System.now())){
                //Check Trigger Context Variables and check if credits change with no open renewal opty for India's Lead
                if ( trigger.isUpdate && (Trigger.oldMap.get(acc.id).Credit__c <> Trigger.newMap.get(acc.id).Credit__c )&& 
                    acc.Class_Number__c >= 1 && acc.Rnwl_Opty_Count__c == 0 &&
                    (acc.BillingCountry == System.Label.Country || acc.BillingCountry == System.Label.CountryV2)) {
                        WHJ_RenewalTriggerHandler.onAfterUpdate(trigger.new);
                       // WHJ_RenewalTriggerHandler.renewalIndiaLogic(trigger.new);
                    }
                //Check Trigger Context Variables and check if credits change with no open renewal opty for International's Lead where Subscription Flag = false.
                if ( trigger.isUpdate && acc.Subscription_Flag__c == false && 
                    acc.Class_Number__c >= 1 && acc.Rnwl_Opty_Count__c == 0 &&
                    (Trigger.oldMap.get(acc.id).Credit__c <> Trigger.newMap.get(acc.id).Credit__c ) 
                    && (acc.BillingCountry <> System.Label.Country && acc.BillingCountry <> System.Label.CountryV2)) {
                        WHJ_RenewalTriggerHandler.onAfterUpdateSubscription(trigger.new);
                        //WHJ_RenewalTriggerHandler.renewalInternationalLogic(trigger.new);
                    }
            }
               
        }
    }  */       

    
   // for(Account acc : trigger.new){
        if (trigger.isAfter && trigger.isUpdate && HelperClass.firstRun) {
            WHJ_HotRenewalTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
            WHJ_RenewalTriggerHandler.createRenewalOpp(trigger.new);
                                    //WHJ_RenewalTriggerHandler.renewalInternationalLogic(trigger.new);
            /*if ( trigger.isUpdate && (Trigger.oldMap.get(acc.id).Credit__c <> Trigger.newMap.get(acc.id).Credit__c )
                && (Trigger.newMap.get(acc.id).Credit__c == 4 )) {
                    WHJ_HotRenewalTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
                } */    
            
                //Check Trigger Context Variables and check if credits change with no open renewal opty for India's Lead
                /*if ( trigger.isUpdate && (Trigger.oldMap.get(acc.id).Credit__c <> Trigger.newMap.get(acc.id).Credit__c )&& 
                    acc.Class_Number__c >= 1 && acc.Rnwl_Opty_Count__c == 0 &&
                    (acc.BillingCountry == System.Label.Country || acc.BillingCountry == System.Label.CountryV2)) {
                        //WHJ_RenewalTriggerHandler.onAfterUpdate(trigger.new);
                                    WHJ_RenewalTriggerHandler.renewalIndiaLogic(trigger.new);
                    }*/
                //Check Trigger Context Variables and check if credits change with no open renewal opty for International's Lead where Subscription Flag = false.
                /*if ( trigger.isUpdate && acc.Subscription_Flag__c == false && 
                    acc.Class_Number__c >= 1 && acc.Rnwl_Opty_Count__c == 0 &&
                    (Trigger.oldMap.get(acc.id).Credit__c <> Trigger.newMap.get(acc.id).Credit__c ) 
                    && (acc.BillingCountry <> System.Label.Country && acc.BillingCountry <> System.Label.CountryV2)) {
                        //WHJ_RenewalTriggerHandler.onAfterUpdateSubscription(trigger.new);
                        WHJ_RenewalTriggerHandler.renewalInternationalLogic(trigger.new);
                    }*/
               }         
        //}
}