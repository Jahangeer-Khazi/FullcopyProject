global class MockZendeskResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ticket":{"url":"https://whitehatjr123.zendesk.com/api/v2/tickets/3741.json","id":3741,"external_id":null}}');
        res.setStatusCode(200);
        return res;
    }
}