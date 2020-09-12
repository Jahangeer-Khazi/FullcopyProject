/*White Hat Junior CASE API REST Class 
*Created By: Mohit
*Release No: 1
*Created Date: 04/09/2020
*Purpose: This Apex REST API class is to creates a Task record in case teacher apply for emergency record.
*/ 

@RestResource(urlMapping='/TeacherEmergencyLeave/*')
global class WHJ_TeacherEmergencyLeave {
	@httppost
    global static void createTeacherTask(){
        String email='';
        String reqBody = '';
        ParentRecord parent = new ParentRecord();
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            System.debug('@@@ reqBody '+reqBody);
            WHJ_TeacherEmergencyLeave.WHJ_Teachers readValueAsResults = (WHJ_TeacherEmergencyLeave.WHJ_Teachers)JSON.deserialize(reqBody,WHJ_TeacherEmergencyLeave.WHJ_Teachers.class);
            System.debug('@@@ reqBody '+readValueAsResults);
            map<String,Contact> teacheremailvsDetail_map = new map<String,Contact>();
            map<String,user> rmemailvsDetail_map = new map<String,user>();
            map<String,String> emailvserrormsg_map = new map<String,String>();
            map<string,Contact> conIdvsContact_map = new map<string,Contact>();
            for(Teacher_details t : readValueAsResults.teacher_lst){
                if(String.isNotBlank(t.email) && String.isNotBlank(t.rm_email)){
                    teacheremailvsDetail_map.put(t.email,new contact());
                    rmemailvsDetail_map.put(t.rm_email,new user());
                }else{
                    if(String.isNotBlank(t.email)){
                        emailvserrormsg_map.put(t.email,'\''+t.email +'\' for this teacher email there is not RM teacher email in input.');    
                    }
                    if(String.isNotBlank(t.rm_email)){
                        emailvserrormsg_map.put(t.rm_email,'\''+t.rm_email +'\' for this RM email there is not teacher email in input.');    
                    }
                }
            }
            for(Contact c : [select id,name,Owner.ID,Owner.email,Email from contact where Email IN: teacheremailvsDetail_map.keyset() and type__c = 'Teacher']){
                if(teacheremailvsDetail_map.containsKey(c.Email)){
                    teacheremailvsDetail_map.put(c.Email,c);
                    conIdvsContact_map.put(c.Id,c);
                }
            }
            for(User u : [select id,Email,name,IsActive from user where Email IN: rmemailvsDetail_map.keyset() ]){
                if(rmemailvsDetail_map.containsKey(u.Email)){
                    rmemailvsDetail_map.put(u.Email,u);
                }
			}
            System.debug('@@@ rmemailvsDetail_map '+rmemailvsDetail_map);
            System.debug('@@@ teacheremailvsDetail_map '+teacheremailvsDetail_map);
            map<String,task> emailvsTask_map = new map<String,task>();
            for(Teacher_details t : readValueAsResults.teacher_lst){
                if(rmemailvsDetail_map.containsKey(t.rm_email) && teacheremailvsDetail_map.containsKey(t.email) ){
                    if(rmemailvsDetail_map.get(t.rm_email).get('Id') != null && teacheremailvsDetail_map.get(t.email).get('Id') != null && rmemailvsDetail_map.get(t.rm_email).isActive == True){
                        Task tk = new task();
                        tk.OwnerId = rmemailvsDetail_map.get(t.rm_email).Id;
                        //tk.Email = t.email;
                        tk.WhoId = teacheremailvsDetail_map.get(t.email).Id;
                        tk.Status = 'Open';
                        tk.Description = 'Teacher won\'t be available for these dates '+t.leave_dates+'. \n The reason '+t.reason_leave;
                        tk.Type = 'Other';
                        tk.Subject = 'Teacher Emergency Leave';
                        emailvsTask_map.put(t.email,tk);
                    }else{
                        if(teacheremailvsDetail_map.get(t.email).get('Id') == null){
                            emailvserrormsg_map.put(t.email,'\''+t.email +'\' for this teacher email there is no details in Salesforce.'); 
                        }
                        else if(rmemailvsDetail_map.get(t.rm_email).get('Id') == null){
                            emailvserrormsg_map.put(t.rm_email,'\''+t.rm_email +'\' for this RM there is no details in Salesforce.'); 
                        }else if(rmemailvsDetail_map.get(t.rm_email).isActive != True){
                            emailvserrormsg_map.put(t.rm_email,'\''+t.rm_email +'\' for this RM there in Salesforce user is not active.'); 
                        }
                    }
                }
            }
            System.debug('@@@ emailvserrormsg_map  '+emailvserrormsg_map);
            System.debug('@@@ emailvsTask_map  '+emailvsTask_map);
            //parent.success = true;
            if(!emailvsTask_map.isEmpty()){
                List<Database.SaveResult> srList = new List<Database.SaveResult>(Database.insert(emailvsTask_map.values(), false));
                set<Id> setOfsuccesstaskId =  new set<Id>();
                integer flag=0;
                for(Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        setOfsuccesstaskId.add(sr.getId());
                    }else{
                        //parent.error = true;
                        //studEmailvserrormsg_map.put(emailvsTask_map.()[flag].Email,sr.getErrors()[0].getMessage());
                        parent.error.add(new ChildRecord_error(true ,'400','Task record is not created for email \''+readValueAsResults.teacher_lst[flag].email+'\' and error message is \"'+sr.getErrors()[0].getMessage()+'\"',readValueAsResults.teacher_lst[flag].email));       
                    }
                    flag++;
                }
                if(!setOfsuccesstaskId.isEmpty()){
                    //parent.success = true;
                    for(task tk : [select id,WhoId from task where ID IN: setOfsuccesstaskId]){
                        parent.success.add(new ChildRecord_success(true ,'200','New task record Id is \''+tk.Id+'\'',conIdvsContact_map.get(tk.WhoId).Email,tk.Id));       
                    }    
            	}
            }
            for(String e : emailvserrormsg_map.keySet()){
                //parent.error = true;
            	parent.error.add(new ChildRecord_error(true,'400', 'No task has been created for email \''+e+'\'. The Error message is '+emailvserrormsg_map.get(e),e));   
        	}
        }catch(exception e){
            RestContext.response.statusCode = 400;
            //parent.error = true;
            parent.error.add(new ChildRecord_error( true,'400', 'BAD_REQUEST :'+e.getMessage(),''));    
            String compName = 'WHJ_TeacherEmergencyLeave';
            String compType = 'REST API Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));
    }
    public class WHJ_Teachers{
        public List<Teacher_details> teacher_lst{get;set;}
    }
    public class Teacher_details{
        public String email{get;set;}
        public String leave_dates{get;set;}
        //public String leave_to{get;set;}
        public String reason_leave{get;set;}
        public String rm_email{get;set;}
    }
    public class ParentRecord {        
        public ChildRecord_error[] error;
        public ChildRecord_success[] success;
        public ParentRecord() {
            error = new ChildRecord_error[0];
            success = new ChildRecord_success[0];
        }
    }
    public class ChildRecord_error {
        public Boolean error;
        public String error_Code, error_message,email;
        public ChildRecord_error(Boolean error, String errorCode, string message,String email) {
            this.error_Code = errorCode;
            this.error_message = message;
            this.error = error;
            this.email = email;
        }
    }
    public class ChildRecord_success {
        public Boolean success;
        public String success_Code, success_message,email,TaskId;
        public ChildRecord_success( Boolean success, String success_Code, string success_message,String email,String TaskId) {
            this.success_Code = success_Code;
            this.success_message = success_message;
            this.success = success;
            this.email = email;
            this.TaskId = TaskId;
        }
    }
}