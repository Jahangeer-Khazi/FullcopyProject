/*White Hat Junior CASE API REST Class 
*Created By: Mohit,Bhushan
*Release No: 1
*Created Date: 24/08/2020
*Purpose: This Apex REST API class is to creates a Case Records for Teacher Leaving & Teacher Alert module
*/ 

@RestResource(urlMapping='/CreateCase/*')
global class WHJ_Case_API {
    
    @HttpPost
    global static Void createCase() 
    {
        String email = '';
        String reqBody = '';
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent)); 	
            Type resultType = Type.forName('WHJ_CaseParser');
            WHJ_CaseParser readValueAsResults = (WHJ_CaseParser)JSON.createParser(reqBody).readValueAs(resultType);
            if(readValueAsResults.ticket_category == System.Label.TEACHER_LEAVING){
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(WHJ_Case_API.createdTeacherLeavingCase(readValueAsResults)));
            }
            if(readValueAsResults.ticket_category == System.Label.TEACHER_ALERT) {
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(WHJ_Case_API.createdTeacherAlertCase(readValueAsResults)));
            }
        }catch(Exception e){//Exception
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
            String compName = 'WHJ_Case_API';
            String compType = 'REST API Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
        }
    } 
    
    public Static ParentRecord createdTeacherLeavingCase(WHJ_CaseParser readValueAsResults){
        ParentRecord parent = new ParentRecord();
        System.debug('@@@ readValueAsResults'+readValueAsResults);
        map<String,WHJ_CaseParser.Case_Details> map_sEmailvsdetails = new map<String,WHJ_CaseParser.Case_Details>();
        map<String,Opportunity> map_rmEmailvsOpp = new map<String,Opportunity>();
        //List<Case> lst_case = new List<case>();
        map<String,Case> stEmailVsCase_map = new map<String,Case>();
        set<String> set_TeacherEmail = new set<string>();
        map<String,String> studEmailvserrormsg_map = new map<String,String>();
        for(WHJ_CaseParser.Case_Details cs: readValueAsResults.lst_caseDetails){
            if(String.isNotBlank(cs.student_email)){
            	map_sEmailvsdetails.put(cs.student_email.toLowerCase(),cs);    
            }else{
                if(String.isNotBlank(cs.teacher_email)){
                    studEmailvserrormsg_map.put(cs.teacher_email, '\''+cs.teacher_email +'\' for this teacher email there is not student email in input.');    
                }
            }
            if(String.isNotBlank(cs.teacher_email)){
            	set_TeacherEmail.add(cs.teacher_email);
            }else{
                if(String.isNotBlank(cs.student_email)){
                    studEmailvserrormsg_map.put(cs.student_email, '\''+cs.student_email +'\' for this Student email there is not teacher email in input.');    
                }
            }
        }
        System.debug('@@@ map_sEmailvsdetails'+map_sEmailvsdetails);
        System.debug('@@@ set_TeacherEmail'+set_TeacherEmail);
        for(Opportunity o : [select id,name,AccountId,Account.Name, Account.PersonEmail,Account.OwnerId,Teacher_Email__c,Teacher_Name__c from Opportunity Where Type = 'New Student' and Account.Status__c = 'Active' and Account.PersonEmail IN: map_sEmailvsdetails.keySet()]){
            o.Account.PersonEmail = o.Account.PersonEmail.toLowerCase();
            map_rmEmailvsOpp.put(o.Account.PersonEmail,o);
        }
        System.debug('@@@ map_rmEmailvsOpp'+map_rmEmailvsOpp);
        map<String,Contact> map_emailVsCon = new map<String,Contact>();
        for(Contact con : [select id,name,Email from contact where Email IN: set_TeacherEmail and type__c = 'Teacher']){
            map_emailVsCon.put(con.Email,con);
        }
        System.debug('@@@ map_emailVsCon'+map_emailVsCon);
        for(String r : map_rmEmailvsOpp.keySet()){
            Case cs = new Case();
            WHJ_CaseParser.Case_Details csDetail = map_sEmailvsdetails.get(r);
            System.debug('@@@ csDetail'+csDetail);
            if(map_emailVsCon.containsKey(csDetail.teacher_email)){
                cs.Teacher_Email__c = csDetail.teacher_email;
                if(map_emailVsCon.containsKey(map_rmEmailvsOpp.get(r).Teacher_Email__c)){
                    cs.Teacher__c = map_emailVsCon.get(map_rmEmailvsOpp.get(r).Teacher_Email__c).id;    
                }
                if(String.isNotBlank(csDetail.origin)){
                    cs.Origin = csDetail.origin;    
                }else{
                    cs.Origin = 'V2 System';    
                }
                if(String.isNotBlank(csDetail.status)){
                    cs.status = csDetail.status;    
                }else{
                    cs.status = 'NEW';    
                }
                cs.AccountId = map_rmEmailvsOpp.get(r).AccountId;
                if(String.isNotBlank(csDetail.subject)){
                    cs.Subject = csDetail.subject;    
                }else{
                    cs.Subject = 'Teacher Leaving';
                }
                if(String.isNotBlank(csDetail.description)){
                    cs.Description = csDetail.description;    
                }else{
                    Cs.Description = 'Teacher is leaving for the student '+map_rmEmailvsOpp.get(r).Account.Name;
                }
                cs.Student_Email__c = map_rmEmailvsOpp.get(r).Account.PersonEmail;
                cs.ownerId = map_rmEmailvsOpp.get(r).Account.OwnerId;
                //lst_case.add(cs);
                stEmailVsCase_map.put(cs.Student_Email__c,cs);
            }else{
            	studEmailvserrormsg_map.put(r, '\''+csDetail.teacher_email +'\' teacher doesn\'t exist in salesforce.');    
            }
        }
        System.debug('@@@ stEmailVsCase_map'+stEmailVsCase_map);
        if( !stEmailVsCase_map.isEmpty()){
            //insert lst_case;
            List<Database.SaveResult> srList = new List<Database.SaveResult>(Database.insert(stEmailVsCase_map.values(), false));
            set<Id> setOfsuccessCaseId =  new set<Id>();
            integer flag=0;
            for(Database.SaveResult sr : srList) {
            	if (sr.isSuccess()) {
                	setOfsuccessCaseId.add(sr.getId());
                }else{
                 	studEmailvserrormsg_map.put(stEmailVsCase_map.values()[flag].Student_Email__c,sr.getErrors()[0].getMessage());
                }
                flag++;
            }
            if(!setOfsuccessCaseId.isEmpty()){
            	parent.success = true;
                for(case c : [select id,casenumber,Student_Email__c from case where ID IN: setOfsuccessCaseId]){
                    parent.error.add(new ChildRecord( '200','New Case record Id is \''+c.Id+'\' from student email \''+c.Student_Email__c+'\''));       
                }    
            }
            for(String s: map_sEmailvsdetails.keySet()){
                if(!map_rmEmailvsOpp.containsKey(s)){
                    studEmailvserrormsg_map.put(s, '\''+s +'\' student doesn\'t exist in salesforce.');    
                }
            }
        }else{
            parent.success = false;
            for(String s: map_sEmailvsdetails.keySet()){
                if(!map_rmEmailvsOpp.containsKey(s)){
                    studEmailvserrormsg_map.put(s, '\''+s +'\' student doesn\'t exist in salesforce.');    
                }
            }
            //parent.error.add(new ChildRecord( '400', 'BAD_REQUEST : NO case has been created.'));   
        }
        for(String e : studEmailvserrormsg_map.keySet()){
            parent.error.add(new ChildRecord( '200', 'No case has been created for email \''+e+'\'. The Error message is '+studEmailvserrormsg_map.get(e)));   
        }
        return parent;
    }
    
    
    public Static ParentRecord createdTeacherAlertCase(WHJ_CaseParser readValueAsResults){
        ParentRecord parent = new ParentRecord();
        system.debug('###1');
        Set<String> set_teacheremail = new Set<String>();
        Set<String> set_casetype = new Set<String>();
        List<Case> lst_caseinsert = new List<case>();
        List<Case> lst_caseupdate = new List<case>();
        
        for(WHJ_CaseParser.Case_Details cs: readValueAsResults.lst_caseDetails){
            set_teacheremail.add(cs.teacher_email);system.debug('###2');
            set_casetype.add(cs.issue_type);
        }
        
        if(!set_teacheremail.isEmpty()) {
            list<Contact> lstTeachers = new list<Contact>();system.debug('###3');
            lstTeachers = [SELECT Id,Email,OwnerId FROM Contact WHERE Email IN: set_teacheremail and Type__c = 'Teacher']; 
            map<String,Contact>MapTeacher = new map<String,Contact>();
            for ( Contact con : lstTeachers ){
                MapTeacher.put(con.Email,con);system.debug('###4');
            } 
            Map<String,List<Case>> mp_ListCase = new Map<String,List<Case>>();
            for(Case tsk : [SELECT Id,Teacher_Email__c,Category__c,Comments,Origin FROM Case WHERE Teacher_Email__c IN: set_teacheremail])
            {
                if(!mp_ListCase.isEmpty() && mp_ListCase.containsKey(tsk.Teacher_Email__c))
                {
                    List<Case> caseList = mp_ListCase.get(tsk.Teacher_Email__c);
                    caseList.add(tsk);
                    mp_ListCase.put(tsk.Teacher_Email__c, caseList);
                }
                else
                    mp_ListCase.put(tsk.Teacher_Email__c, new List<Case>{tsk});
            }
            for(WHJ_CaseParser.Case_Details cs: readValueAsResults.lst_caseDetails){system.debug('###5');
                if(MapTeacher.containsKey(cs.teacher_email)) {system.debug('###6');
                                 Boolean CaseUpdated = false;                                
                    if(!mp_ListCase.isEmpty() && mp_ListCase.containsKey(cs.teacher_email)) {
                        List<Case> tempCaseList = mp_ListCase.get(cs.teacher_email);system.debug('####08099070+'+tempCaseList);system.debug('####9999+'+tempCaseList.size());
                        for(Case csvar : tempCaseList) {
                            if(csvar.Category__c == cs.issue_type) {
                                Case caserecord = new Case();
                                caserecord.Id = csvar.Id; //mapCase get id
                                caserecord.Origin = 'V2 System';
                                if(cs.description != null) {
                                    caserecord.Comments = cs.description; 
                                }system.debug('###7');
                                caserecord.OwnerId = MapTeacher.get(cs.teacher_email).OwnerId;
                                caserecord.Teacher__c = MapTeacher.get(cs.teacher_email).Id;
                                lst_caseupdate.add(caserecord);
                                CaseUpdated = true;
                                break;
                            }
                        }
                    }
                    if(CaseUpdated == false)
                    {system.debug('###8');
                        Case caserecord = new Case();
                        caserecord.Category__c = cs.issue_type;
                        caserecord.Teacher_Email__c = cs.teacher_email;
                        caserecord.Comments = cs.description;
                        caserecord.OwnerId = MapTeacher.get(cs.teacher_email).OwnerId;
                        caserecord.Teacher__c = MapTeacher.get(cs.teacher_email).Id;
                        lst_caseinsert.add(caserecord);  
                    }
                }
                else {
                    CalloutException e = new CalloutException();
                    e.setMessage('No teacher with email id : '+cs.teacher_email);
                    throw e;
                }
            }
        } else {system.debug('###9');
            CalloutException e = new CalloutException();
            e.setMessage('Teacher Email : Required Field');
            throw e;
        }        
        if(!lst_caseupdate.isEmpty() || !lst_caseinsert.isEmpty()) {
            if( !lst_caseinsert.isEmpty()){
                system.debug('#####999+'+lst_caseinsert.size());
                insert lst_caseinsert;
                parent.success = true;
                for(case c : lst_caseinsert){
                    parent.error.add(new ChildRecord( '200','Case inserted with Id : '+c.Id ));       
                }
            }
            if( !lst_caseupdate.isEmpty()){
                update lst_caseupdate;
                parent.success = true;
                for(case c : lst_caseupdate){
                    parent.error.add(new ChildRecord( '200','Case updated with Id : '+c.Id ));       
                }
            }
        }else{
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST : No teacher exists with given email Id.'));   
        }
        return parent;
    }
    public class ParentRecord {
        public Boolean success;
        public ChildRecord[] error;
        public ParentRecord() {
            this.success = success;
            error = new ChildRecord[0];
        }
    }
    public class ChildRecord {
        public String error_Code, error_message;
        public ChildRecord( String errorCode, string message) {
            this.error_Code = errorCode;
            this.error_message = message;
        }
    }    
}