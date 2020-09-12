/*White Hat Junior Task API REST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 19/09/2019
 *Purpose: This Apex REST API class is to creates a EmailMessage when Type in 
service request is Email else it creates Task.
 */ 

@RestResource(urlMapping='/Interactions')
global class WHJ_Task_API {
 @HttpPost
    global static void createTask() 
    {	
        try{
    	RestRequest request = RestContext.request;
        String reqBody = request.requestBody.toString(); 
        system.debug('createLead  :: '+ reqBody);
     	
        ParentRecord parent = new ParentRecord();
        parent.success = true;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
    
        
        Type resultType = Type.forName('WHJ_TaskParser');
		WHJ_TaskParser parsedData = (WHJ_TaskParser)JSON.createParser(reqBody).readValueAs(resultType);
		System.debug('parsedData ' + parsedData);

        //Select the user record for the AssignedTo in the request
        List<User> user = [SELECT Id, Name FROM User WHERE Name =: parsedData.AssignedTo LIMIT 1];
        List<Task> lstTask = new List<Task>();
      
        if(parsedData.Type == 'Email'){ //If Type found, create EmailMessage
            EmailMessage em = new EmailMessage();
            em.ToAddress = parsedData.ToAddress; 
            em.TextBody = parsedData.TextBody;
            em.Subject = parsedData.SubjectForEmailMessage;
            em.HtmlBody = parsedData.HtmlBody;
            em.Status = parsedData.StatusofEmailMeassage;
           insert em;
        }else{ // Else creates , create task
         Task task = new Task();
          task.Subject = parsedData.Subject;
          task.ActivityDate =parsedData.DueDate;
          task.OwnerId =user.isEmpty() ? null: user[0].Id;
          task.Priority =parsedData.Priority;
          task.Status =parsedData.Status;
      //    task.Type = parsedData.Type;
          lstTask.add(task);
        insert lstTask;
        
            
            
        }   
        }catch(Exception e){ //Exception
          RestContext.response.statusCode = 400;
        ParentRecord parent = new ParentRecord();
        parent.success = false;
        parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
        
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
    	
        }
        
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
   // public String error;
   // public Boolean success;
    public String error_Code, error_message;
    public ChildRecord( String errorCode, string message) {
       // this.error = error;
        this.error_Code = errorCode;
        this.error_message = message;
    }
}
    
}