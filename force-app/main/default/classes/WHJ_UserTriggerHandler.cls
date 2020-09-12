public class WHJ_UserTriggerHandler {
    @future
    public static void onAfterUpdate(Id userId,Id mgrId) 
    {
        List<Opportunity> Opty = [SELECT Id FROM Opportunity WHERE OwnerId <> null AND OwnerId =: userId ];
        if(!Opty.isEmpty()){
            for(Opportunity Oppo : Opty){
                Oppo.OwnerId = mgrId; 
            }
            Update Opty;            
        }
    }
}