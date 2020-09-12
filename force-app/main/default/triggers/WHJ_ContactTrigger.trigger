trigger WHJ_ContactTrigger on Contact(after update )
{
    if ( trigger.isAfter ) {
        if ( trigger.isUpdate ) {
            WHJ_ContactHandlerController.SendTeacherDisposition(trigger.new, trigger.oldMap);
        }
        
    }
}