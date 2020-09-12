/*White Hat Junior Delete Package Trigger
 *Created By: HGHUGHANE
 *Created Date: 16/09/2019
 *Release No: 1  
 *Purpose: After delete trigger to update opportunity fields when package is deleted.
 */

trigger WHJ_PackageDelete on OpportunityLineItem (after delete) {

    List<OpportunityLineItem> lstOli = [ SELECT Id, Available_Discount__c,Discount,Product2Id,Offer_Price__c,ListPrice FROM OpportunityLineItem];
    List<Opportunity> lstOpp = [SELECT Actual_Discount__c,Amount,Available_Discount__c,Credits__c,Id,Name,
                                Package__c,Proposed_List_Price__c, Proposed_offer_Price__c FROM Opportunity ];
    System.debug(lstOpp);
    if(Trigger.isDelete)
    {
        Set<Id> setdeleteId = new Set<Id>();
        for(OpportunityLineItem delc : trigger.old)
        {
            setdeleteId.add(delc.OpportunityId);
            System.debug(setdeleteId);
            List<Opportunity> lstOpp = [SELECT Actual_Discount__c,Amount,Available_Discount__c,Credits__c,Id,Name,
                                Package__c,Proposed_List_Price__c, Proposed_offer_Price__c FROM Opportunity where Id =: delc.OpportunityId];
            System.debug(lstOpp);
         
            Opportunity oppo = new Opportunity();
                    oppo.Id = lstOpp[0].Id;
                    oppo.Package__c = null;
                    oppo.Amount = null;
                    oppo.Actual_Discount__c = null;
                    oppo.Available_Discount__c = null;
                    oppo.Credits__c = null;
                    oppo.Proposed_Discount_Amount__c = null;
                    oppo.Proposed_offer_Price__c  = null;
                    oppo.Proposed_List_Price__c = null;
            update oppo;

        }
    }
   
}