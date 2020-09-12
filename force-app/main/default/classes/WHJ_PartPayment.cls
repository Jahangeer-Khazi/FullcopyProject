/**
 * @File Name          : WHJ_PartPayment.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11/13/2019, 12:46:36 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/7/2019   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public  class WHJ_PartPayment {
    
    @AuraEnabled
    public static String insertPayment(String oppID,String jsonstr) {
        system.debug(jsonstr);
        Opportunity opp = [SELECT id ,Part_Payment__c 
                          FROM Opportunity 
                          WHERE id  =:oppID	 ];
        if(opp.Part_Payment__c == false){
             opp.Part_Payment__c = true;     
             update opp;
        }

        List<Part_Payment__c> paylst  = new List<Part_Payment__c>();
        List<paywrapper> Jsondatawrapper = (List<paywrapper>)JSON.deserialize(jsonstr,List<paywrapper>.class);
        system.debug('Jsondatawrapper'+Jsondatawrapper);
        for(paywrapper pwrap: Jsondatawrapper)
        {
            system.debug('false::'+pwrap.SFRecordID);
            if(String.isBlank(pwrap.SFRecordID))
            {
                system.debug('true');
                Part_Payment__c payment = new Part_Payment__c();
                payment.Amount__c =  pwrap.pamount;
                payment.Date__c =  pwrap.paydate;
                payment.Credit__c =  pwrap.cre;
                payment.Opportunity__c = oppID ;

                paylst.add(payment);
                system.debug(paylst);
            }
        }
          insert paylst; 
          return onloaddata(oppID);
  }

@AuraEnabled
public Static String onloaddata (String oppID)
{

    List<paywrapper> pwrap = new List<paywrapper>();

    for(Part_Payment__c paylst : [SELECT id, Amount__c ,Date__c ,Credit__c,Opportunity__c
                                  FROM Part_Payment__c 
                                  WHERE Opportunity__c = :oppID])
    {

        paywrapper wrap = new paywrapper();
        wrap.pamount = paylst.Amount__c;
        wrap.paydate = paylst.Date__c;
        wrap.cre = paylst.Credit__c;
        wrap.SFRecordID = paylst.id;
          
        pwrap.add(wrap);
    }

      return JSON.serialize(pwrap);
}

@AuraEnabled
public static void delmethod(String precId,String jsonstr){
    
    Part_Payment__c payobj = [select id,Opportunity__r.id from Part_Payment__c where id = :precId];
    
  List<paywrapper> Jsondatawrapper = (List<paywrapper>)JSON.deserialize(jsonstr,List<paywrapper>.class);
    if(Jsondatawrapper.size()==1) {
         Opportunity opp = [SELECT id ,Part_Payment__c 
                          	FROM Opportunity 
                          	WHERE id  =:payobj.Opportunity__r.id];
        if(opp.Part_Payment__c == true){
             opp.Part_Payment__c = false;     
             update opp;
        }
    }
      if(!String.isBlank(precId)){
          delete payobj ;
      }
    
    

}


      public class paywrapper {
      
        @AuraEnabled public String SFRecordID {get; set;}
        @AuraEnabled public Decimal pamount {get; set;}
        @AuraEnabled public date paydate {get; set;}
        @AuraEnabled public Decimal cre {get; set;}
      

          public paywrapper() {}

  }


}