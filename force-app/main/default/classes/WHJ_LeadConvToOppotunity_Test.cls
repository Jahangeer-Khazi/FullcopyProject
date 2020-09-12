/*White Hat Junior Lead Conversion TEST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 17/09/2019
*Purpose: This Test class is to test Data for WHJ_LeadConvToOppotunity class.
*/ 


@isTest
public class WHJ_LeadConvToOppotunity_Test {
    
    @testsetup
    static void insertNewLead() {
        
        Lead newLead = new Lead();
        newLead.LastName = 'Test';
        newLead.FirstName = 'kumar';
        newLead.Status = 'Registered';
        
        
        insert newLead;
        system.debug(newLead.Id);
        
    }
    @istest
    static void leadconvert(){
        lead ld = [select id from lead];
        String leadid = ld.Id;
        system.debug(ld.Id);
        WHJ_LeadConvToOppotunity.LeadAssign(leadid);
    }
}