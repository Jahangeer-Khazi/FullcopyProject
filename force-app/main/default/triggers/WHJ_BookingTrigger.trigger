trigger WHJ_BookingTrigger on Booking__c (after insert,after update) {
    for(Booking__c book : trigger.new){
        if ( trigger.isAfter ) {
            if ( trigger.isInsert && book.Teacher_Email__c <> null) {
                WHJ_BookingTriggerHandler.onAfterInsert(trigger.new);
            }
        }
        if ( trigger.isAfter ) {
            if ( trigger.isInsert && book.Is_Trial__c == true) {
                WHJ_BookingTriggerHandler.onAfterInsertCallout(trigger.new);
            }
        }
		if ( trigger.isAfter ) {
            if ( trigger.isUpdate && book.Is_Trial__c == true && 
                (Trigger.oldMap.get(book.id).Teacher_Comments__c <> Trigger.newMap.get(book.id).Teacher_Comments__c )) {
                WHJ_BookingTriggerHandler.onAfterInsertCallout(trigger.new);
            }
        }        
    }
}