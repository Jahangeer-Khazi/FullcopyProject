public class WHJ_SLABreachMailSendToAuditTeam {
    public static void onAfterUpdate(List<Opportunity> oppList,Map<Id, Opportunity> mapOpptyOld) {
        Set<Id> ownerSet = new Set<Id>();
        //collect opp id where SLA breach for audit team occurs
        //
        Set<Id> ownerSet2 = new Set<Id>(); //collect opp id where SLA breach for audit team occurs for 72 hours condition
        for(Opportunity opp : oppList) {
            
            if(opp.Send_Mail_To_AuditTeam__c == true && mapOpptyOld.get(opp.id).Send_Mail_To_AuditTeam__c <> opp.Send_Mail_To_AuditTeam__c) {
                ownerSet.add(opp.ownerId);       
            }
            
            if(opp.SendMailToAuditTeamIn72Hours__c == true && mapOpptyOld.get(opp.id).SendMailToAuditTeamIn72Hours__c <> opp.SendMailToAuditTeamIn72Hours__c) {
                ownerSet2.add(opp.ownerId);       
            }
            
        }
        String auditTeamEmailId = System.Label.AuditTeamEmailId;
        String otherEmailId = System.Label.OtherEmailId;
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String slaBreachAt3hoursEmailSubject = System.Label.SLABreachToAuditor3HoursEmailSubject;
        String slaBreachAt72hoursEmailSubject = System.Label.SLABreachToAuditor72HoursEmailSubject;
        if(ownerSet.size() > 0 ){
            Map<Id,User> ownerMap = new Map<Id,User>([select id,Name,Email from User where id in: ownerSet]);
            Map<Id,User> ManagerMap = new Map<Id,User>([SELECT  Id,Name,Manager.email,Manager.Manager.email,Manager.Manager.Manager.email FROM User where id in: ownerSet]);
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Opportunity opp : oppList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                //mail.setToAddresses(new String[]{ManagerMap.get(opp.OwnerId).Manager.email, ManagerMap.get(opp.OwnerId).Manager.Manager.email , ManagerMap.get(opp.OwnerId).Manager.Manager.Manager.email});
                mail.setToAddresses(new String[]{auditTeamEmailId});
                String oppUrl = sfdcBaseURL + '/' + opp.Id;
                String managerEmail = ManagerMap.get(opp.OwnerId).Manager.email;
                String oppUrlWithAnchorTag = '<a href="'+ oppUrl +'">' + opp.Name + '</a>';
                
                String SOPGuidelineWithAnchorTag = '<a href="'+System.Label.SOPGuideline+'">click here</a>';
                String EmailtoHRBPWithAnchorTag = '<a href="mailto:'+System.Label.HRBPEmailId+'">'+System.Label.HRBPEmailId+'</a>';
                String AuditFormWithAnchorTag = '<a href="'+System.Label.AuditForm+'">click here</a>';
                
                Datetime local = opp.CreatedDate;
                
                Integer offset = UserInfo.getTimezone().getOffset(local);
                local = local.addSeconds(offset/1000);
                String subject = slaBreachAt3hoursEmailSubject + ' - ' + opp.Name ;
                mail.setSubject(subject);
                String body = 'SLA Breach for <b>'+ ownerMap.get(opp.OwnerId).Name +'</b> for Opportunity Name '+ oppUrlWithAnchorTag +'<br><br>';
                body +='Owner email: '+ ownerMap.get(opp.OwnerId).Email +'<br><br>';
                body +='Created Date: ' + local + '<br><br>';
                body +='Manager: '+ ManagerMap.get(opp.OwnerId).Manager.email +'<br><br>';
                body +='HRBP Email: '+ EmailtoHRBPWithAnchorTag +'<br><br>';
                body +='Type: First Call <br><br>';
                body +='SOP Guideline: '+ SOPGuidelineWithAnchorTag +'<br><br>';
                body +='Audit Form: '+ AuditFormWithAnchorTag +'<br><br>';
                body +='<br>';
                body += '<br>';
                body +='System Generated Email';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
            //Triggering the email
            Messaging.sendEmail(mails);       
        }
        if(ownerSet2.size() > 0 ){
            Map<Id,User> ownerMap = new Map<Id,User>([select id,Name,Email from User where id in: ownerSet2]);
            Map<Id,User> ManagerMap = new Map<Id,User>([SELECT  Id,Name,Manager.email,Manager.Manager.email,Manager.Manager.Manager.email FROM User where id in: ownerSet2]);
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Opportunity opp : oppList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //mail.setToAddresses(new String[]{ManagerMap.get(opp.OwnerId).Manager.email, ManagerMap.get(opp.OwnerId).Manager.Manager.email , ManagerMap.get(opp.OwnerId).Manager.Manager.Manager.email});
                mail.setToAddresses(new String[]{auditTeamEmailId,otherEmailId});
                String oppUrl = sfdcBaseURL + '/' + opp.Id;
                String managerEmail = ManagerMap.get(opp.OwnerId).Manager.email;
                String oppUrlWithAnchorTag = '<a href="'+ oppUrl +'">' + opp.Name + '</a>';
                String SOPGuidelineWithAnchorTag = '<a href="'+System.Label.SOPGuideline+'">click here</a>';
                String EmailtoHRBPWithAnchorTag = '<a href="mailto:'+System.Label.HRBPEmailId+'">'+System.Label.HRBPEmailId+'</a>';
                String AuditFormWithAnchorTag = '<a href="'+System.Label.AuditForm+'">click here</a>';
                
                Datetime local = opp.CreatedDate;
                
                Integer offset = UserInfo.getTimezone().getOffset(local);
                local = local.addSeconds(offset/1000);
                String subject = slaBreachAt72hoursEmailSubject + ' - ' + opp.Name ;
                
                mail.setSubject(subject);
                String body = 'SLA Follow-Up Breach for <b>'+ ownerMap.get(opp.OwnerId).Name +'</b> for Opportunity Name '+ oppUrlWithAnchorTag +'<br><br>';
                body +='Owner email: '+ ownerMap.get(opp.OwnerId).Email +'<br><br>';
                body +='Created Date: ' + local + '<br><br>';
                body +='Manager: '+ ManagerMap.get(opp.OwnerId).Manager.email +'<br><br>';
                body +='HRBP Email: '+ EmailtoHRBPWithAnchorTag +'<br><br>';
                body +='Type: Follow-Up <br><br>';
                body +='SOP Guideline: '+ SOPGuidelineWithAnchorTag +'<br><br>';
                body +='Audit Form: '+ AuditFormWithAnchorTag +'<br><br>';
                body +='<br>';
                body += '<br>';
                body +='System Generated Email';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
            //Triggering the email
            Messaging.sendEmail(mails);       
        }       
    }
    
    public static void SLAbreachForStudentRM(List<Account> accList,Map<Id, Account> mapAccOld) {
        Set<Id> ownerSet = new Set<Id>();
        
        for(Account acc : accList) {
            
            if(acc.Send_Mail_To_AuditTeam__c == true && mapAccOld.get(acc.id).Send_Mail_To_AuditTeam__c <> acc.Send_Mail_To_AuditTeam__c) {
                ownerSet.add(acc.ownerId);       
            }
        }
        String auditTeamEmailId = System.Label.AuditTeamEmailIdForStudents;
        String otherEmailId = System.Label.OtherEmailId;
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String slaBreachAt2hoursEmailSubject = System.Label.SLABreachToAuditor2HoursEmailSubject;
        //String slaBreachAt72hoursEmailSubject = System.Label.SLABreachToAuditor72HoursEmailSubject;
        if(ownerSet.size() > 0 ){
            Map<Id,User> ownerMap = new Map<Id,User>([select id,Name,Email from User where id in: ownerSet]);
            Map<Id,User> ManagerMap = new Map<Id,User>([SELECT  Id,Name,Manager.email,Manager.Manager.email,Manager.Manager.Manager.email FROM User where id in: ownerSet]);
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Account acc : accList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(new String[]{auditTeamEmailId,otherEmailId});
                System.debug('sfdcBaseURL::'+sfdcBaseURL);
                String accUrl = sfdcBaseURL + '/' + acc.Id;
                System.debug('accUrl::'+accUrl);
                String managerEmail = ManagerMap.get(acc.OwnerId).Manager.email;
                String accUrlWithAnchorTag = '<a href="'+ accUrl +'">' + acc.FirstName +' '+ acc.LastName + '</a>';
                
                String SOPGuidelineWithAnchorTag = '<a href="'+System.Label.SOPGuideline+'">click here</a>';
                String EmailtoHRBPWithAnchorTag = '<a href="mailto:'+System.Label.HRBPEmailId+'">'+System.Label.HRBPEmailId+'</a>';
                String AuditFormWithAnchorTag = '<a href="'+System.Label.AuditForm+'">click here</a>';
                
                Datetime local = acc.CreatedDate;
                
                Integer offset = UserInfo.getTimezone().getOffset(local);
                local = local.addSeconds(offset/1000);
                String subject = slaBreachAt2hoursEmailSubject + ' - ' + acc.FirstName +' '+ acc.LastName ;
                mail.setSubject(subject);
                String body = 'SLA Breach for <b>'+ ownerMap.get(acc.OwnerId).Name +'</b> for Student Name '+ accUrlWithAnchorTag +'<br><br>';
                body +='Owner email: '+ ownerMap.get(acc.OwnerId).Email +'<br><br>';
                body +='Created Date: ' + local + '<br><br>';
                body +='Manager: '+ ManagerMap.get(acc.OwnerId).Manager.email +'<br><br>';
                body +='HRBP Email: '+ EmailtoHRBPWithAnchorTag +'<br><br>';
                body +='Type: First Call <br><br>';
                body +='SOP Guideline: '+ SOPGuidelineWithAnchorTag +'<br><br>';
                body +='Audit Form: '+ AuditFormWithAnchorTag +'<br><br>';
                body +='<br>';
                body += '<br>';
                body +='System Generated Email';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
            //Triggering the email
            Messaging.sendEmail(mails);       
        }
    }
}