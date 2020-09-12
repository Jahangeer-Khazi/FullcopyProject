public class WHJ_PaymentTriggerHandler {
    public static void onAfterInsert(List<Payment__c> lstPayment){
        Set<Id> SetOfOptyId = new Set<Id>();
        Set<String> roleSet = new Set<String>();
        
        for(Payment__c pay : lstPayment){
            SetOfOptyId.add(pay.Opportunity__c);
        }
        for(User user: [SELECT Id FROM User where UserRole.Name =: System.Label.Conversion_Team_Member])
        {
            roleSet.add(user.Id);
        }
        
        List<User> lstUsers = [SELECT Id,Name from User WHERE isActive = true AND Status__c = 'Available' 
                               AND Id IN: roleSet ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
        
        List<Opportunity> lstOpty = [Select Id,OwnerId from Opportunity Where Id =: SetOfOptyId];
        if(!lstOpty.isEmpty()){
            for(Opportunity opty : lstOpty){
                if(!lstUsers.isEmpty()){
                    opty.OwnerId = lstUsers[0].Id; 
                    lstUsers[0].Last_Assignment_Date_Time__c = System.now();
                }else{
                    opty.OwnerId = System.Label.TL_Id_for_20_Days;
                }
            }    
        }Update lstOpty;    
        Update lstUsers;    
    }
    
}