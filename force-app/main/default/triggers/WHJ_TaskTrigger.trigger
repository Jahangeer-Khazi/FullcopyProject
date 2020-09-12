/*White Hat Junior Task Trigger
*Created By: HGHUGHANE
*Created Date: 01/06/2020
*Release No: 1  
*Purpose: After insert trigger to check if call type is Call and proceed Webhook callout.
*/

trigger WHJ_TaskTrigger on Task (after insert) {    
    //Iterate over Task trigger
    for(Task t : trigger.new ){
        //Check Trigger Context Variables
        if ( trigger.isAfter ) {
            //Check Trigger Context Variables and type of task
            if ( trigger.isInsert && t.type == 'Call' ) {
                //Call onAfterInsert method 
                WHJ_TaskTriggerHandler.onAfterInsert(trigger.new);
            }
        }    
    }
}