public class WHJ_SLABreachMailSend {
    public static void onAfterUpdate(List<Opportunity> oppList){
        
          Set<Id> ownerSet = new Set<Id>();
            
            for(Opportunity opp : oppList) {
                ownerSet.add(opp.ownerId);
                                
            } 
        
        Map<Id,User> ownerMap = new Map<Id,User>([select id,Name,email from User where id in: ownerSet]);
        Map<Id,User> ManagerMap = new Map<Id,User>([SELECT  Id,Name,Manager.email,Manager.Manager.email,Manager.Manager.Manager.email FROM User where id in: ownerSet]);
        List<String> lstOfToaddress = new List<String>();

        
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Opportunity opp : oppList) {
                system.debug('opp for single email-- ' + opp);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if(ManagerMap.get(opp.OwnerId).Manager.email <> null){
                    lstOfToaddress.add(ManagerMap.get(opp.OwnerId).Manager.email);
                }
                if(ManagerMap.get(opp.OwnerId).Manager.Manager.email <> null){
                    lstOfToaddress.add(ManagerMap.get(opp.OwnerId).Manager.Manager.email);
                }
                if(ManagerMap.get(opp.OwnerId).Manager.Manager.Manager.email <> null){
                    lstOfToaddress.add(ManagerMap.get(opp.OwnerId).Manager.Manager.Manager.email);
                }
                mail.setToAddresses(lstOfToaddress);
                //mail.setToAddresses(new String[]{ManagerMap.get(opp.OwnerId).Manager.email, ManagerMap.get(opp.OwnerId).Manager.Manager.email , ManagerMap.get(opp.OwnerId).Manager.Manager.Manager.email});
                mail.setSubject('SLA Breach for 2 hour calling window');
                String body = 'SLA Breach for '+ ownerMap.get(opp.OwnerId).Name +' for Opportunity Name : '+opp.Email__c +'<br><br>';
                body +='<br>';
                body +='System Generated Email';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
          
            //Triggering the email
        if(!lstOfToaddress.isEmpty()){
            Messaging.sendEmail(mails);
        }
            
   
    }
	  //SLA Breach for Student RM's    
    public static void SLAbreachForStudentRM(List<Account> lstAccount, Map<Id, Account> lstOldAccount) {
        
        Set<Id> ownerSet = new Set<Id>();
        Set<Id> SetofAccIds = new Set<Id>();
        if(lstAccount != null){
            for(Account acc : lstAccount) {
                if(acc.SendMailSLAbreach__c == true && lstOldAccount.get(acc.id).SendMailSLAbreach__c <> acc.SendMailSLAbreach__c) {
                    ownerSet.add(acc.ownerId);       
                    SetofAccIds.add(acc.Id);
                }
            }    
        }
        
        Map<Id,User> ownerMap;
        Map<Id,User> ManagerMap;
        if(ownerSet != null){
            ownerMap = new Map<Id,User>([select id,Name,email from User where id in: ownerSet]);
            ManagerMap = new Map<Id,User>([SELECT  Id,Name,Manager.email,Manager.Manager.email,Manager.Manager.Manager.email FROM User where id in: ownerSet]);
        }
        
        List<Account> lstAcc = [Select Id,Name,OwnerId From Account where Id IN : SetofAccIds ];
        List<String> lstOfToaddress = new List<String>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(lstAccount != null ){
            if(!ownerMap.isEmpty() && !ManagerMap.isEmpty()){
                for(Account account : lstAccount) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if(ownerMap.get(account.OwnerId).email <> null){
                            lstOfToaddress.add(ownerMap.get(account.OwnerId).email);
                        }
                        if(ManagerMap.get(account.OwnerId).Manager.email <> null){
                            lstOfToaddress.add(ManagerMap.get(account.OwnerId).Manager.email);
                        }
                        if(ManagerMap.get(account.OwnerId).Manager.Manager.email <> null){
                            lstOfToaddress.add(ManagerMap.get(account.OwnerId).Manager.Manager.email);
                        }
                    	mail.setToAddresses(lstOfToaddress);
                        mail.setSubject('SLA Breach for 1 hour calling window');
                        String body = 'SLA Breach for '+ ownerMap.get(account.OwnerId).Name +' for Student Name : '+account.PersonEmail +'<br><br>';
                        body +='<br>';
                        body +='System Generated Email';
                        mail.setHtmlBody(body);
                        mails.add(mail);    
                } 
            }
          
            //Triggering the email
            Messaging.sendEmail(mails);
            
        }
    }
}