trigger WHJ_SetTrailDateOnOpportunity on Booking__c (after insert) {
    Map<Id,Booking__c> oppbookingmap = new Map<Id,Booking__c>();
    List<Opportunity> opplist = new List<Opportunity>();
    for(Booking__c b : Trigger.New)
    {
        if(b.Is_Trial__c == true)
        {
            oppbookingmap.put(b.Opportunity__c, b);
        }
    }
    
    for(String key : oppbookingmap.keySet())
    {
        Opportunity opp = new Opportunity();
        opp.id = key;
       
        DateTime dt = DateTime.newInstance(oppbookingmap.get(key).Booking_Date__c, oppbookingmap.get(key).Actual_Class_Start_Time__c);
        
        opp.Trial_Date_Time__c = dt;
        opp.Trial_Time_ZoneTrial__c = oppbookingmap.get(key).Time_Zone__c; 
        opp.Trial_Time__c = oppbookingmap.get(key).Actual_Class_Start_Time__c;
        opplist.add(opp);
        
        
    }
    try
    {
        system.debug(opplist.size());
      update opplist;  
    }
    catch(exception e)
    {
        system.debug(e.getMessage());
    }

}