@isTest
public class WHJ_PartPayment_Test {
	@isTest
    static void testData() {
        String data = '[{"SFRecordID":"","id":1,"pamount":"1","paydate":"2019-11-14","cre":"1"}]';
        String deldata ='[]';
       Account acc = new Account();
       acc.LastName = 'test';
       insert acc; 
        
       Opportunity oppo = new Opportunity();
       oppo.AccountId = acc.Id;
       oppo.Name = 'whj';
       oppo.StageName = 'WON-PART PAYMENT';
       oppo.CloseDate = Date.newInstance(1960, 2, 17);
       oppo.Type = 'New Student';
        insert oppo;
        
        Part_Payment__c pay = new Part_Payment__c();
            pay.Amount__c = 412;
            pay.Opportunity__c = oppo.Id;
            pay.Credit__c = 4;
            pay.Date__c = Date.newInstance(1960, 2, 17);
        insert pay;
       
        
        
        WHJ_PartPayment.insertPayment(oppo.Id, data);
        WHJ_PartPayment.onloaddata(oppo.Id);
        WHJ_PartPayment.delmethod(pay.Id, data);
     

       
    }
}