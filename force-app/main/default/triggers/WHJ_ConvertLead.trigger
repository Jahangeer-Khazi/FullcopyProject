/*White Hat Junior Lead Convert Trigger
*Created By: HGHUGHANE
*Created Date: 15/09/2019
*Release No: 1  
*Purpose: After update , After insert trigger to convert lead.
*/

trigger WHJ_ConvertLead on Lead (before insert,before update, after insert, after update) {
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            system.debug('##1');
            AssignLeadsToReferralTeam.assignLeadsToReferralConversionTeam(Trigger.New);
        } 
    }
  
   
    
    for(Lead lead:Trigger.new) {
        if(Trigger.isBefore) {
            if(lead.SalesRef__c <> null){
                Id SalesRefId = WHJ_Utils.getSalesRefEmail(lead.SalesRef__c);
                lead.SalesReflookup__c =  SalesRefId;
            }
        } 
        
        
        system.debug('Trigger lead:: ' + lead);
        //system.debug('Trigger lead Status:: ' + lead.Status + '>>>>>>>>' + Trigger.oldMap.get(lead.id).status);
        if ((Trigger.IsInsert && lead.Status == 'Complete') || 
            (Trigger.IsUpdate  && (Trigger.oldMap.get(lead.id).status =='Unregistered' || Trigger.oldMap.get(lead.id).status =='Registered'  ||
             Trigger.oldMap.get(lead.id).status =='Tech Setup' || Trigger.oldMap.get(lead.id).status =='Trial Class Booked') && lead.Status == 'Complete')
           ){ //If Status is complete              
               WHJ_LeadConvToOppotunity.LeadAssign(lead.Id); //call method from WHJ_LeadConvToOppotunity handler 
           }
    }
}