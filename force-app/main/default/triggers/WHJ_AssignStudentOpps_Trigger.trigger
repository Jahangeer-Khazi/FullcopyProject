/*White Hat Junior Assign Student Ops Trigger
*Created By: K M Jahangeer Basha
*Created Date: 08/10/2020
*Release No: 1  
*Purpose: Before update trigger to assign the Student
*to the Operations team member based on availability
*and round robin logic
*/
trigger WHJ_AssignStudentOpps_Trigger on Account (before insert,before update) {
    
    if(Trigger.isBefore) {
        if(HelperClass.firstRun) {
            if(Trigger.isUpdate) {
                WHJ_AssignStudentOpps_Trigger_Handler.assignStudentOppsOnUpdate(Trigger.new,Trigger.oldMap);
                
            } else if(Trigger.isInsert) {
                WHJ_AssignStudentOpps_Trigger_Handler.assignStudentOppsOnInsert(Trigger.new);      
            } 
            HelperClass.firstRun = false;
        } 
    }
    
}