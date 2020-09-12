/*White Hat Junior Update Teacher Comments Trigger
 *Created By: HGHUGHANE
 *Created Date: 15/09/2019
 *Release No: 1  
 *Purpose: Before insert trigger to update teacher comments
 */


trigger WHJ_Update_Teacher_Comments on FeedItem (before insert) {
    
    for (Integer i = 0; i<trigger.new.size(); i++) {
        if (trigger.new[i].body!='') {
            String email = '';
            System.debug(trigger.new[i].body);
            String body = trigger.new[i].body;
            String GropuId = trigger.new[i].ParentId;  
            String str='Chatter Free User';
            List<User> lstuser = [select Id, Name from User  where Id =: GropuId AND  Profile.Name LIKE :'%'+str+'%'];
            System.debug('GropuId::'+GropuId);
            
            email = body.substringBetween('!!');
            System.debug('email::'+email);
            body = body.replace('<p>', '');
            body = body.replace('</p>', '');
            body = body.replace('!!', '');
            
            if(!lstuser.isEmpty()){
                if(email!='' && email!=null)
                {
                    Opportunity oppo = [Select id, name,Student_Email__c from Opportunity where Student_Email__c =:email ORDER BY CreatedDate DESC NULLS FIRST limit 1];
                    oppo.Teacher_Feedback__c = body;
                    update oppo;
                }
            }
        }
    }
    
    
}