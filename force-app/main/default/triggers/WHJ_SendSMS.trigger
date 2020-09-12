trigger WHJ_SendSMS on Task (after insert) {
    
    for(Task task:Trigger.new){
        if(task.Type == 'SMS'){
            List<Task> lstTask = [SELECT Id from Task where Id =: task.Id];
            List<Opportunity> lstOppo =[SELECT Id,Name, MobileNumber__c from Opportunity where Id =: task.WhatId];
            List<Account> lstAcc =[SELECT Id,Name, PersonMobilePhone from Account where Id =: task.WhatId];
            List<SendSMSConfig__mdt> lstAuth = [SELECT Name__c,Value__c from SendSMSConfig__mdt WHERE Name__c = 'authkey'];
            List<SendSMSConfig__mdt> lstSender = [SELECT Name__c,Value__c from SendSMSConfig__mdt WHERE Name__c = 'sender'];
            
            if(!lstOppo.isEmpty()){
                String mob;
                if(lstOppo[0].MobileNumber__c <> null){
                    mob = lstOppo[0].MobileNumber__c;
                    System.debug('mob::'+mob);
                }else{
                    task.addError('Mobile Number does not Exist');
                }  
                
                String msg = task.Description;
                System.debug('msg::'+msg);
                String authkey = lstAuth[0].Value__c;
                System.debug('authkey::'+authkey);    
                String sender = lstSender[0].Value__c;
                System.debug('sender::'+sender);    
                WHj_SMSConnect.sendSMS(task.id, mob, msg,authkey,sender);
                lstTask[0].Status = 'Completed';
                update lstTask;   
            }
            if(!lstAcc.isEmpty()){
                String mob;
                if(lstAcc[0].PersonMobilePhone <> null){
                    mob = lstAcc[0].PersonMobilePhone;
                    System.debug('mob::'+mob);
                }else{
                    task.addError('Mobile Number does not Exist');
                }  
                String msg = task.Description;
                System.debug('msg::'+msg);
                String authkey = lstAuth[0].Value__c;
                String sender = lstSender[0].Value__c;
                WHj_SMSConnect.sendSMS(task.id, mob, msg,authkey,sender);
                lstTask[0].Status = 'Completed';
                update lstTask;
            }
            
        }    
    }
}