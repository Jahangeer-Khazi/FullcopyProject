/*White Hat Junior FirstResTime API TEST Class 
*Created By: HGUGHANGE
*Release No: 3
*Created Date: 27/02/2020
*Purpose: This Test class is to test Data for WHJ_FirstResTime_API_Test class.
*/ 

@isTest
public class WHJ_FirstResTime_API_Test {
    
    static testmethod void testFRT() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        System.debug('lcv::'+lcv);
        
        Case c = new Case();
        c.Type = 'New';
        insert c;
        
        LiveChatTranscript live = new LiveChatTranscript();
        live.LiveChatVisitorId = lcv.Id;
        live.CaseId = c.Id;
        live.ChatKey = '5f1489da-75d8-4df7-a8a0-545209842fe7';
        live.Body = 'Live test';
        live.Status = 'InProgress';
        
        insert live;
        System.debug('live::'+live);
        
        String actual = '{"sessionkey":"'+live.ChatKey+'","firstresponsetime":"2020-02-22T03:30:10Z"}';
        System.debug('actual::'+actual);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_FirstResTime_API.getFRT();
    }
    static testmethod void testFRTCatchBlock() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        System.debug('lcv::'+lcv);
        
        Case c = new Case();
        c.Type = 'New';
        insert c;
        
        LiveChatTranscript live = new LiveChatTranscript();
        live.LiveChatVisitorId = lcv.Id;
        live.CaseId = c.Id;
        live.ChatKey = '5f1489da-75d8-4df7-a8a0-545209842fe7';
        live.Body = 'Live test';
        live.Status = 'InProgress';
        
        insert live;
        System.debug('live::'+live);
        
        String actual = '{"sessionkey":"'+live.ChatKey+'","firstresponsetime":""}';
        System.debug('actual::'+actual);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(actual);
        
        RestContext.request = req;
        RestContext.response= res;
        
        WHJ_FirstResTime_API.getFRT();
    }
    
}