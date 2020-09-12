/*White Hat Junior Assign Student Ops Trigger
*Created By: HGHUGHANE
*Created Date: 18/09/2019
*Release No: 1  
*Purpose: Before update trigger to assign the Student
*to the Operations team member based on availability
*and round robin logic
*/

trigger WHJ_AssignStudentOpps on Account (before update,before insert) {
    
    String region = null;
    
    for(Account acc : Trigger.New){
        if(Trigger.IsUpdate){
            String region = WHJ_Utils.getSalesRegion(acc.BillingCountry);
            system.debug('region---  ' + region);
            Account OldAccount = Trigger.oldMap.get(acc.Id);
            // Check if Student's status is changed to Active
            if(acc.Status__c != OldAccount.Status__c && acc.Status__c == 'Active' && HelperClass.firstRun){
                acc.Activation_Date__c = System.today(); //Set activation date as Today's date
                List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='StudentOpsRepRole'];
                //Query available users who have Role as Student Ops and ascending order of last assignment
                if(acc.Batch_Type__c == 'ONE_TO_TWO')
                { 
                    List<User> usr = [SELECT Id, Name, Status__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND 
                                      Sales_Region__c includes(:region) AND Batch_type__c includes ('ONE_TO_TWO') AND UserRoleId =: conlst[0].Value__c AND Package_Type__c includes(:acc.Package_Type__c) 
                                      AND isactive = true ORDER BY 
                                      Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                    
                    if(!usr.isEmpty()) //If User found  
                    { 
                        for(User user : usr){ 
                            acc.OwnerId = user.Id; 
                            //Set owner of student
                            user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                            update user;  
                            break;
                        }
                    }else { 
                         String defaultManagerId = WHJ_Utils.getDefaultManagerId(acc.BillingCountry, 'Ops');
                        acc.OwnerId = defaultManagerId;
                    } 
                }
                else
                { 
                    List<User> usr = [SELECT Id, Name, Status__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND 
                                      Sales_Region__c includes(:region) AND Batch_type__c !='ONE_TO_TWO' AND UserRoleId =: conlst[0].Value__c AND Package_Type__c includes(:acc.Package_Type__c) 
                                      AND isactive = true ORDER BY 
                                      Last_Assignment_Date_Time__c ASC NULLS FIRST]; 
                    if(!usr.isEmpty()) //If User found  
                    { 
                        for(User user : usr){ 
                            acc.OwnerId = user.Id; 
                            //Set owner of student
                            user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                            update user;  
                            break;
                        }
                    }else { 
                        String defaultManagerId = WHJ_Utils.getDefaultManagerId(acc.BillingCountry, 'Ops');
                        acc.OwnerId = defaultManagerId;
                    } 
                }
                HelperClass.firstRun=false;
            } 
            
        }
        if(Trigger.isInsert){
            String region = WHJ_Utils.getSalesRegion(acc.BillingCountry);
            system.debug('region---  ' + region);
            // Check if Student's status is  Active
            if(acc.Status__c == 'Active'){
                acc.Activation_Date__c = System.today(); //Set activation date as Today's date
                acc.Lifecycle_Stage__c = 'Onboarding';
                
                Package__mdt pkgCustom = [SELECT Id, Name__c, Value__c FROM Package__mdt where Name__c ='Standard'];
                if(acc.Package_Type__c == null){
                    acc.Package_Type__c = pkgCustom.Value__c;
                }
                List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='StudentOpsRepRole'];
                if(acc.Batch_Type__c  == 'ONE_TO_TWO')
                {  
                    List<User> usr = [SELECT Id, Name, Status__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND 
                                      Sales_Region__c includes(:region) AND Batch_type__c includes ('ONE_TO_TWO') AND UserRoleId =: conlst[0].Value__c AND Package_Type__c includes(:acc.Package_Type__c)
                                      AND isactive = true ORDER BY 
                                      Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                    
                    if(!usr.isEmpty()) //If User found  
                    {
                        for(User user : usr){
                            acc.OwnerId = user.Id; 
                            //Set owner of student
                            user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                            update user;  
                            break;
                        }
                    }else {
                        String defaultManagerId = WHJ_Utils.getDefaultManagerId(acc.BillingCountry, 'Ops');
                        System.debug('defaultManagerId::'+defaultManagerId);
                        acc.OwnerId = defaultManagerId;
                        
                    }
                }
                else
                {  
                    List<User> usr = [SELECT Id, Name, Status__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND 
                                      Sales_Region__c includes(:region) AND Batch_type__c !='ONE_TO_TWO' AND UserRoleId =: conlst[0].Value__c AND Package_Type__c includes(:acc.Package_Type__c)
                                      AND isactive = true ORDER BY 
                                      Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                    
                    if(!usr.isEmpty()) //If User found  
                    {
                        for(User user : usr){
                            acc.OwnerId = user.Id; 
                            //Set owner of student
                            user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User0
                            update user;  
                            break;
                        }
                    }else {
                        String defaultManagerId = WHJ_Utils.getDefaultManagerId(acc.BillingCountry, 'Ops');
                        acc.OwnerId = defaultManagerId;
                    }
                }
                //Query available users who have Role as Student Ops and ascending order of last assignment
            }
        }
    }
}