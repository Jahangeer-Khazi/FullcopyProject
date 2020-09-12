/*White Hat Junior Lead Conversion Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 13/09/2019
 *Purpose: This Apex class is to Convert lead into opportunity.
 */ 


public class WHJ_LeadConvToOppotunity {
     public static void LeadAssign(Id LeadIds) 
     {
      try{
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(LeadIds);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];         
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
         
         }catch(Exception e){
             String compName = 'Lead Conversion';
             String compType = 'WHJ_LeadConvToOppotunity';
             String recRef = LeadIds;  // temp adding leads instead of email
             String req = null;
             String err = e.getMessage()  + e.getStackTraceString();  
             WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);
             System.debug('Error-' + e.getMessage());
         }
    }   
         
}