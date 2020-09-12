public class WHJ_AssignUserHandler {
    
    public static void BeforeInsert(List<Opportunity> lstOpportunity) {
        String region = null;
        List<String> salerefPrfileIdsList = new List<String>();
        String salerefPrfileIds = System.Label.SalesRefProfile;
        if(salerefPrfileIds!=null && salerefPrfileIds.contains(',')){
            salerefPrfileIdsList =  salerefPrfileIds.split(',');    
        }
        else if(salerefPrfileIds!=null){
            salerefPrfileIdsList.add(salerefPrfileIds);
        }
        system.debug('**** salerefPrfileIdsList = '+salerefPrfileIdsList);
        try{
            
            
            Set<String> SetofRefMail = new Set<String>();
            
            for(Opportunity opp : lstOpportunity)
            {
                SetofRefMail.add(opp.Referral_Manager__c);
            }
            List<User> ListRefUser = [select id , IsActive , email from User where UserRole.Name !=:system.label.Role_Referral_Manager AND UserRole.Name !=:system.label.Role_Referral_Manager_USA AND Status__c = 'Available' AND IsActive = true AND email IN: SetofRefMail];
            
            
            
            for(Opportunity opp : lstOpportunity){
                
                region = WHJ_SalesRegionClass.getthesalesregion(opp.Student_Country__c);
                
                Boolean OwnerAssigned = false;
                if(opp.Referral_Customer__c != null)
                {
                    if(opp.Referral_Manager__c != null)
                    {
                        
                        if(!ListRefUser.isEmpty())
                        {
                            for(User usr : ListRefUser)
                            {
                                if(opp.Referral_Manager__c == usr.email)
                                {
                                    opp.OwnerId = usr.Id;
                                    OwnerAssigned = true;
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
                            system.debug('**** userList = '+userList);
                            if(userList.size()>0){
                                opp.OwnerId = userList[0].id;                      
                            }
                            else{
                                opp.OwnerId =System.Label.SalesRefDefaultUser;
                            }
                        } else {
                            if(opp.Type == 'New Student') {
                                Set<String> roleSet = new Set<String>();
                                for(Configuration__mdt conlst: [SELECT Value__c FROM Configuration__mdt where (Name__c ='SalesRepRole' OR Name__c ='SalesTeamLeader' )]) {
                                    roleSet.add(conlst.Value__c);
                                }
                                
                                //Query available users who have Role as Sales rep and ascending order of last assignment
                                //excluding apt user in usr list
                                
                                List<User> usr = [SELECT Id, Name, Sales_Region__c FROM User where Status__c = 'Available' AND 
                                                  Sales_Region__c includes(:region) AND UserRoleId IN: roleSet  
                                                  AND Call_Availability_Status__c = 'Available' AND isactive = true
                                                  ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                                
                                //Query available users who have Role as Sales rep and ascending order of last assignment
                                
                                
                                {
                                    //If User found  
                                    if(!usr.isEmpty()) {
                                        for(User user : usr){
                                            opp.OwnerId = user.Id;  //Set owner of Opportunity
                                            user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                                            //usr.add(user);
                                            update user;  
                                            break;
                                        }
                                    } else {
                                        Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'SalesMangerID'];
                                        opp.OwnerId = config.Value__c;
                                    }  
                                }
                            } else 
                            { 
                                // RenewalPart
                                Set<String> roleSet = new Set<String>();
                                for(Configuration__mdt conlst: [SELECT Value__c FROM Configuration__mdt where (Name__c ='SalesRepRole' OR Name__c ='SalesTeamLeader' )]) {
                                    roleSet.add(conlst.Value__c);
                                }
                                {
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
                                            Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'SalesMangerID'];
                                            opp.OwnerId = config.Value__c;
                                            //lstconfig.add(config);
                                        }
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
}