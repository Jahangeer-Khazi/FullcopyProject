@isTest
public class SendEmailOnLiveChat_Test {

	@isTest static void createtranscript() {
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

  		List<User> lstuser = [Select Id , Name from User];
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        
        LiveChatTranscript live = new LiveChatTranscript();
        live.LiveChatVisitorId = lcv.Id;
        live.OwnerId = lstuser[0].Id;
        live.Body = 'Live test';
        live.Notify_User__c = false;
        insert live;
        
        live.Notify_User__c = true;
        update live;
            
        if(live.Name != null){
		System.debug('live.Name::'+live.Name);
        System.debug('live.OwnerId::'+live.OwnerId);
	    //MyBellNotification.notifyCurrentUser(live.OwnerId,live.Name);
        }
            
	}
    
}