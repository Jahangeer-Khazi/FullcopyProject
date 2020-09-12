public class WHJ_UserDeactivateCtrl{
    public Static String IJMRECOMMENDEDBUTTON= 'IJMRecommended';
    
    @AuraEnabled
    public static returnDetails getUserData(Id userId) {
        returnDetails details = new returnDetails();
        details.objUser = getUseDetails(userId);
        details.strTheme = UserInfo.getUiThemeDisplayed();
        return details;
    }
    
    private static User getUseDetails(Id userId) {
        return [SELECT Id, isActive, ManagerId FROM User WHERE Id =: userId] ;
    }
 
    @AuraEnabled
    public static WHJ_UtilFunctions.ParentRecord deactivateUser(String userId, String IJMRecommendedButton) {
        WHJ_UtilFunctions.ParentRecord parent = new WHJ_UtilFunctions.ParentRecord();
        if(userId != null) {
            try {
                User usr = getUseDetails(userId);
                //deactivate user and assign users opportunities to its manager
                if(IJMRecommendedButton==IJMRECOMMENDEDBUTTON && usr.ManagerId!=null){
                   List<Opportunity> oppListToUpdate = new List<Opportunity>();
                   for(Opportunity opp: [SELECT Id,ownerId FROM Opportunity WHERE ownerId=:userId]){
                       opp.ownerId = usr.ManagerId;
                       oppListToUpdate.add(opp);
                   }
                   system.debug('### oppListToUpdate'+oppListToUpdate);
                   if(!oppListToUpdate.isEmpty()){
                       update oppListToUpdate;
                   }
                }
                //deactivate user
                usr.IsActive = false;
                update usr; 
                parent.success = true;
            } catch (Exception e) {
                String recRef = 'User Deactivate';
                parent.success = false;
                parent.error.add(new WHJ_UtilFunctions.ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));
                String err = e.getMessage()  + e.getStackTraceString();  
                system.debug('error-- ' + err);
                //WHJ_ErrorLogHandler.log(compNameUserDeactivate, compType, err, 400,recRef,null);    
            }
        } else {
            parent.error.add(new WHJ_UtilFunctions.ChildRecord( '400', 'User Not found'));
        }      
        return parent;
    }
    public class returnDetails{
    	@AuraEnabled public User objUser;
        @AuraEnabled public String strTheme;
    }
}