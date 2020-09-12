trigger WHJ_PaymentTrigger on Payment__c (after insert) {
  
    for(Payment__c pay : trigger.new){
        String Country;
        for(Account acc : [Select Id,BillingCountry from Account Where Id =: pay.Account__c]){
            Country = acc.BillingCountry;
        }  
        if ( trigger.isAfter ) {
            if ( trigger.isInsert && pay.Package_Name__c == System.Label.Expert &&
                (Country == System.Label.Country || Country == System.Label.CountryV2 ||
                 Country == null) ) {
                     WHJ_PaymentTriggerHandler.onAfterInsert(trigger.new);  
                 }
        }
    }
}