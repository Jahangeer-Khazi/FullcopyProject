@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://api.msg91.com/api/sendhttp.php?mobiles=&authkey=&route=4&sender=&message=&country=91', req.getEndpoint());
      //  System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"tskId":"00T6D0000024LYcUAM","mobNo":"+919898989898","message":"test","authKey":"281845APXW8qHjuRp95d0a737d","sender":"WHJRCO"}');
        res.setStatusCode(200);
        return res;
    }
}