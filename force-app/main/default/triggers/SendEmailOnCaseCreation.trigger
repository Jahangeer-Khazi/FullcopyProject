trigger SendEmailOnCaseCreation on Case (after update) {
    
    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();

    for(Case c:trigger.new ){
            if(c.ContactId != null && c.Status == 'New'){
            if((Trigger.oldMap.get(c.Id).ContactId != c.ContactId && 
                c.Origin == 'Web' && 
                (c.CategoryOutClass__c != null || c.CategoryInClass__c != null  )
               ) || 
               c.Origin == 'Email' && c.Category__c != null){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                EmailTemplateConfig__mdt config = [Select Name__c, Value__c from EmailTemplateConfig__mdt where Name__c = 'Email on Case Creation to teacher'];
                EmailTemplate et = [SELECT Id,Subject, Body, HtmlValue FROM EmailTemplate WHERE Id =:config.Value__c];
                Contact con = [Select Id,Email,FirstName, Name from Contact where Email =: c.ContactEmail limit 1];
                OrgWideEmailAddress__mdt oweConfig = [select name__c,value__c  from OrgWideEmailAddress__mdt where name__c = 'Whitehat Support'];   
                OrgWideEmailAddress owe = [select id, Address, DisplayName from OrgWideEmailAddress where id =: oweConfig.value__c];
                Case c1 = [select Id ,ContactEmail from Case where Id =: c.Id];
                String[] toAddresses = new String[] {c1.ContactEmail};
                //String[] toAddresses = new String[] {'mittal.payal2012@gmail.com','payal.mittal@aethereus.com'};
                System.debug('toAddresses::'+toAddresses);
                mail.setTargetObjectId(con.Id);
                // process the merge fields
                String subject = et.Subject;
                //system.debug('subject:: '+ subject);
                subject = subject.replace('{!Case.CaseNumber}', c.CaseNumber);
                //system.debug('subject11:: '+ subject);
                mail.setSubject(subject);
                String plainBody = et.Body;
                plainBody = plainBody.replace('{!Contact.Name}', con.Name);
                plainBody = plainBody.replace('{!Case.CaseNumber}', c.CaseNumber);
//                System.debug('c.Category__c::'+c.Category__c);
                plainBody = plainBody.replace('{!Case.Category__c}', c.Category__c);
                
                
                mail.setToAddresses(toAddresses);
                mail.setReplyTo(owe.Address);
                mail.setOrgWideEmailAddressId(owe.Id);
                //mail.setSenderDisplayName(owe.DisplayName);
                mail.setTemplateId(et.Id);
                mail.setPlainTextBody(plainBody);
//                System.debug('mail::'+mail);
                allmsg.add(mail);
                Messaging.sendEmail(allmsg,false);    
            }
        }
    }
}