/**
 * @File Name          : WHJ_GetOpportunityMobile.cls
 * @Description        : 
 * @Author             : Rohit Suri (Aethereus)
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10/24/2019, 4:25:06 PM

**/


public with sharing class WHJ_GetOpportunityMobile {

    @AuraEnabled
    public static String WHJ_GetMobile(String OppId) {

        List<Opportunity> Oppo = [SELECT Name, Id, MobileNumber__c FROM Opportunity where Id =: OppId LIMIT 1];
		
        System.debug('OppId: ' + Oppo[0].Id);
        System.debug('Mobile ' + Oppo[0].MobileNumber__c);
        System.debug('Mobile ' + Oppo[0].Name);
        
        if(!Oppo.IsEmpty() && String.isNotBlank(Oppo[0].MobileNumber__c))
        {
            return Oppo[0].MobileNumber__c;
        }
        else 
            {
                return null;
            }

    }
}