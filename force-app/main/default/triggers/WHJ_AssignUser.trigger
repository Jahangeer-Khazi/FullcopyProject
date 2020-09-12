/*	White Hat Junior Assign User Trigger
* 	Created By		: 	HGHUGHANE
* 	Created Date	: 	18/09/2019
* 	Release No		: 	1  
*	Purpose			: 	Before insert trigger to assign the Opportunity
*						to the Operations team member based on availability
*						and round robin logic
*	Change Histroy	: 
					CH01 # Added Jahangeer Khazi # 21-08-2020 Harcoding the SOQL LIMIT value and calls a generateRandomFunction.

*/

trigger WHJ_AssignUser on Opportunity (before insert) {
    
    String region = null;
    List<String> salerefPrfileIdsList = new List<String>();
    String salerefPrfileIds = System.Label.SalesRefProfile;
    if(salerefPrfileIds!=null && salerefPrfileIds.contains(',')){
        salerefPrfileIdsList =  salerefPrfileIds.split(',');    
    }
    else if(salerefPrfileIds!=null){
        salerefPrfileIdsList.add(salerefPrfileIds);
    }
    
    try{
        Set<String> SetofRefMail = new Set<String>();
        for(Opportunity opp : Trigger.New)
        {
            SetofRefMail.add(opp.Referral_Manager__c);
        }
        List<User> ListRefUser = [select id , IsActive , email from User where UserRole.Name !=:system.label.Role_Referral_Manager AND UserRole.Name !=:system.label.Role_Referral_Manager_USA AND UserRole.Name !=:system.label.Role_Dead_Leads_Referrals_Manager AND UserRole.Name !=:system.label.Role_Dead_Leads_Referrals_Manager_USA AND Status__c = 'Available' AND IsActive = true AND email IN: SetofRefMail];
        for(Opportunity opp : Trigger.new){
            String region = WHJ_Utils.getSalesRegion(opp.Student_Country__c);
            Boolean OwnerAssigned = false;
            if(opp.Referral_Customer__c != null) {
                if(opp.Referral_Manager__c != null) {
                    if(!ListRefUser.isEmpty()) {
                        for(User usr : ListRefUser) {
                            if(opp.Referral_Manager__c == usr.email) {
                                opp.OwnerId = usr.Id;
                                OwnerAssigned = true;
                                opp.Owner_Assigned__c = true;
                                break;
                            }
                            else
                                continue;
                        }
                    }               
                }
            }
            if(OwnerAssigned == false)
            {
                if(opp.Do_Not_Assign__c == false){
                    if(opp.SalesRef__c!=null && opp.Referral_Manager__c == null){
                        User[] userList = [select id from User where email = :opp.SalesRef__c AND isActive = true AND Profile.Id IN :salerefPrfileIdsList limit 1];
                        if(userList.size()>0){
                            opp.OwnerId = userList[0].id;
                            OwnerAssigned = true;
                            opp.Owner_Assigned__c = true;
                        }
                    } if(OwnerAssigned == false) {
                        /*if(opp.Type == 'New Student') {
                            
                            Set<String> roleSet = new Set<String>();
                            for(Configuration__mdt conlst: [SELECT Value__c FROM Configuration__mdt where (Name__c ='SalesRepRole' OR Name__c ='SalesTeamLeader' )]) {
                                roleSet.add(conlst.Value__c);
                            }
                            //Query available users who have Role as Sales rep and ascending order of last assignment
                            //excluding apt user in usr list
                            //
                            //adding delay patch between 1-5 sec for erratic leads if leads comes at the exact time
                            //if(!Test.isRunningTest()){
                            //	WHJ_Utils.addDelay();
                           // }
                            // CH01 Start. Hardcoding the SOQL LIMIT Value for patch
                            List<User> usr = [SELECT Id, Name, Sales_Region__c FROM User where Status__c = 'Available' AND 
                                              Sales_Region__c includes(:region) AND UserRoleId IN: roleSet  
                                              AND Call_Availability_Status__c = 'Available' AND isactive = true
                                              ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST LIMIT 7] ; 
                            //Query available users who have Role as Sales rep and ascending order of last assignment
                            Integer i = WHJ_Utils.generateRandomNumber(usr.size()-1);
                                //If User found  
                                if(!usr.isEmpty()) {
                                    opp.OwnerId = usr[i].Id;  //Set owner of Opportunity
                                    usr[i].Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                                    //usr.add(user);
                                    update usr[i]; 
                                    //break;
                                    //}
                                    //CH01 End.
                                } else {
                                    String defaultManagerId = WHJ_Utils.getDefaultManagerId(opp.Student_Country__c, 'New');
                                    opp.OwnerId = defaultManagerId;
                                }  
                            
                        }*/
                        if(opp.Type == 'Renewal')
                        { 
                            // RenewalPart
                            List<Configuration__mdt> conlstRenewal= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='RoleForRenewal'];
                            System.debug('conlstRenewal::'+conlstRenewal);
                            if(!conlstRenewal.isEmpty()){   
                                
                                //Query available users who have Role as Renewal team and ascending order of last assignment
                                List<User> usr = [SELECT Id, Name, Sales_Region__c FROM User where Status__c = 'Available' AND 
                                                  Sales_Region__c includes(:region) AND UserRoleId =: conlstRenewal[0].Value__c AND 
                                                  Call_Availability_Status__c = 'Available' AND isactive = true
                                                  ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                                if(!usr.isEmpty())   //If User found  
                                {
                                    for(User user : usr){
                                        opp.OwnerId = user.Id;  //Set owner of Opportunity
                                        user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                                        //usr.add(user);
                                        update user;  
                                        break;
                                    }
                                }  
                                else{
                                    String defaultManagerId = WHJ_Utils.getDefaultManagerId(opp.Student_Country__c, 'Renewal');
                                    opp.OwnerId = defaultManagerId;
                                }
                            } 
                        }
                    }
                }
            }
        } 
    } catch(Exception e) {
        System.debug('Exception ::'+e.getMessage());
    }
    
}