public class WHJ_SMSConnect {
    @future(callout=true)
    public static void sendSMS(String tskId, String mobNo,String message,String authKey,String sender) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://api.msg91.com/api/sendhttp.php?mobiles='+mobNo+'&authkey='+authKey+'&route=4&sender='+sender+'&message='+message+'&country=91');
        req.setMethod('GET');
        System.debug('req::'+req);
        res = http.send(req);
        System.debug('res::'+res);
        
    }
}