public without sharing class  MyBellNotification
{
    @future (callout=true)
    public static void notifyCurrentUser(String lctOwnerId,String name)
    {
        System.debug('inn');
        LiveChatTranscript livechat = [SELECT Id, OwnerId, Name FROM LiveChatTranscript WHERE Name =: name];
        CustomNotificationType cnt = [SELECT Id, DeveloperName, MasterLabel FROM CustomNotificationType WHERE DeveloperName = 'Notification_For_Cases'];
        System.debug('livechat.Name'+livechat.Name);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                        + '/services/data/v46.0/actions/standard/customNotificationAction');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        CustomNotificationActionInput input = new CustomNotificationActionInput();
        input.customNotifTypeId = cnt.Id;
        input.recipientIds = new List<String>{lctOwnerId};
		input.title = 'New Chat || Chat No--'+livechat.Name;
        input.body = 'New chat is waiting for your attention.';
        input.targetId = livechat.Id;
        CustomNotificationAction action = new CustomNotificationAction();
        action.inputs = new List<CustomNotificationActionInput>{input};
            req.setBody(JSON.serialize(action));
        HttpResponse res = h.send(req);
        System.debug('bodyyyy'+res.getBody());
        
      /*  if (Test.isRunningTest()) {  
            return res.getBody();
        }else{
            HttpResponse res1 = h.send(req);
        }*/
        
    }
    
    public class CustomNotificationAction
    {
        public List<CustomNotificationActionInput> inputs { get; set; }
    }
    
    public class CustomNotificationActionInput
    {
        public String customNotifTypeId { get; set; }
        public List<String> recipientIds { get; set; }
        public String title { get; set; }
        public String body { get; set; }
        public String targetId { get; set; }
    }
}