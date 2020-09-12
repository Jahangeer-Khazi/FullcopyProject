/*White Hat Junior Assign Student Ops Trigger
*Created By: K M Jahangeer Basha
*Created Date: 08/10/2020
*Release No: 1  
*Purpose: Handler Class to assign the Student
*to the Operations team member based on availability
*and round robin logic
*/
public class WHJ_AssignStudentOpps_Trigger_Handler {
    public static void assignStudentOppsOnUpdate(List<Account> acct, Map<Id,Account> oldacct)
    {system.debug('###11 ');
        String region = null;
        List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='StudentOpsRepRole'];
        //Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'StudentOpsManage'];
        List<User> updateUserList = new List<User>();
        
        // Map<Id,User> mapUserList = new Map<Id,User>(userList);
        // Map<Id, Account> filteredAccforRMAssignment = new Map<Id, Account>();
        List<Account> accListForRMAssignment = new List<Account>();
        Set<String> regionList = new Set<String>();
        Set<String> batchTypeList = new Set<String>();
        Set<String> packageTypeList = new Set<String>();
        for(Account acc : acct) {
            Account OldAccount = oldacct.get(acc.Id);
            if(acc.Status__c != OldAccount.Status__c && acc.Status__c == 'Active') {
                if(acc.BillingCountry != null) {
                    regionList.add(acc.BillingCountry);
                    system.debug('###112 '+regionList);
                } else {
                    //add hardcode in custom label as default regionInternational
                    regionList.add('International');
                    system.debug('###113 '+regionList);
                }
                //if batch type is null, will consider as ONE_TO_ONE
                if(acc.Batch_Type__c == 'ONE_TO_TWO') {
                    batchTypeList.add(acc.Batch_Type__c);
                    system.debug('###114 '+batchTypeList);
                } else {
                    //add hardcode in custom label
                    batchTypeList.add(null);
                    batchTypeList.add('ONE_TO_ONE');
                    system.debug('###115 '+batchTypeList);
                }
                
                if(acc.Package_Type__c != null) {
                    packageTypeList.add(acc.Package_Type__c);
                    system.debug('###116 '+packageTypeList);
                } 
                
                // filteredAccforRMAssignment.put(acc.Id, acc);
                accListForRMAssignment.add(acc);
                system.debug('###117 '+accListForRMAssignment);
            }
        }
        system.debug('###12 ');
        List<User> userList = [SELECT Id, Name, Status__c,Sales_Region__c,Batch_Type__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND Batch_Type__c IN :batchTypeList AND UserRoleId =: conlst[0].Value__c AND Sales_Region__c IN :regionList AND Package_Type__c IN :packageTypeList AND isactive = true ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
        system.debug('###1 '+userList);
        Map<Id,User> mapUserList = new Map<Id,User>(userList);
         List<Regionwise_default_RM__mdt> RMassignment = [SELECT Id,Name__c,Value__c FROM Regionwise_default_RM__mdt];
       List<Regionwise_default_RM__mdt> RMassignmentINT = [SELECT Id,Name__c,Value__c FROM Regionwise_default_RM__mdt WHERE Name__c = 'International'];
        for(Account acc: accListForRMAssignment) {
            System.debug('Status is changed');
            acc.Activation_Date__c = System.today(); //Set activation date as Today's date
            system.debug('###13 ');
            if(!userList.isEmpty()) {
                for (User usr: userList) {
                    if((usr.Sales_Region__c).containsIgnoreCase(acc.BillingCountry) && (usr.Package_Type__c).containsIgnoreCase(acc.Package_Type__c) &&  usr.Batch_Type__c.contains(acc.Batch_Type__c) && acc.Batch_Type__c == 'ONE_TO_TWO') {
                        acc.OwnerId = usr.Id; 
                        system.debug('user.Last_Assignment_Date_Time__c :'+usr.Last_Assignment_Date_Time__c);
                        usr.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                        updateUserList.add(usr); system.debug('###14 ');
                        break;
                    } else if((usr.Sales_Region__c).containsIgnoreCase(acc.BillingCountry) && (usr.Package_Type__c).containsIgnoreCase(acc.Package_Type__c) && usr.Batch_Type__c != 'ONE_TO_TWO' && acc.Batch_Type__c != 'ONE_TO_TWO'){
                        acc.OwnerId = usr.Id; 
                        system.debug('user.Last_Assignment_Date_Time__c :'+usr.Last_Assignment_Date_Time__c);
                        usr.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                        updateUserList.add(usr); system.debug('###14 ');
                        break;
                    }
                }
            } else {
               system.debug('###15 ');
                if(!RMassignment.isEmpty())
                {
                    for(Regionwise_default_RM__mdt config : RMassignment) {
                        if((config.Name__c).containsIgnoreCase(acc.BillingCountry)) {
                            acc.OwnerId = config.Value__c;system.debug('###16 ');
                            break;
                        }
                        else {
                            acc.OwnerId = RMassignmentINT[0].Value__c;system.debug('###17 ');
                            break;
                        }
                     }
                }
            }
            if(updateUserList.size()>0) {
                update updateUserList;system.debug('###18 ');
            }
            
        }
    }
        public static void assignStudentOppsOnInsert(List<Account> acct)
        {
            String region = null;
            Package__mdt pkgCustom = [SELECT Id, Name__c, Value__c FROM Package__mdt where Name__c ='Standard'];
            Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'StudentOpsManage'];
            List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='StudentOpsRepRole'];
            List<User> userList = new List<User>();
            
            for(Account acc : acct) // for loop start
            {
                Switch on acc.BillingCountry 
                {
                    when 'India' {
                        region = 'India';
                    }
                    when 'IndiaV2' {
                        region = 'IndiaV2';
                    }
                    when else {
                        region =  'International';
                    }
                }
                // Check if Student's status is  Active
                if(acc.Status__c == 'Active')
                {
                    acc.Activation_Date__c = System.today(); //Set activation date as Today's date
                    acc.Lifecycle_Stage__c = 'Onboarding';
                    
                    //Package__mdt pkgCustom = [SELECT Id, Name__c, Value__c FROM Package__mdt where Name__c ='Standard'];
                    if(acc.Package_Type__c == null){
                        acc.Package_Type__c = pkgCustom.Value__c;
                    }
                    
                    
                    // List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='StudentOpsRepRole'];
                    if(acc.Batch_Type__c  == 'ONE_TO_TWO')
                    {  
                        List<User> usr = [SELECT Id, Name, Status__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND 
                                          Sales_Region__c includes(:region) AND Batch_Type__c = 'ONE_TO_TWO' AND UserRoleId =: conlst[0].Value__c AND Package_Type__c includes(:acc.Package_Type__c)
                                          AND isactive = true ORDER BY 
                                          Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                        System.debug('usr::'+usr);
                        if(!usr.isEmpty()) //If User found  
                        {
                            for(User user : usr){
                                acc.OwnerId = user.Id; 
                                system.debug('Name :'+user.Name);
                                //Set owner of student
                                system.debug('user.Last_Assignment_Date_Time__c :'+user.Last_Assignment_Date_Time__c);
                                user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                                
                                //update user; 
                                userList.add(user); 
                                system.debug('user.Last_Assignment_Date_Time__c :'+user.Last_Assignment_Date_Time__c);
                                break;
                            }
                        }else {
                            // Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'StudentOpsManage'];
                            acc.OwnerId = config.Value__c;
                        }
                    }
                    else
                    {  
                        List<User> usr = [SELECT Id, Name, Status__c,Last_Assignment_Date_Time__c FROM User where Status__c = 'Available' AND 
                                          Sales_Region__c includes(:region) AND Batch_Type__c != 'ONE_TO_TWO' AND UserRoleId =: conlst[0].Value__c AND Package_Type__c includes(:acc.Package_Type__c)
                                          AND isactive = true ORDER BY 
                                          Last_Assignment_Date_Time__c ASC NULLS FIRST] ; 
                        system.debug('user list : ' + usr);
                        System.debug('usr::'+usr);
                        if(!usr.isEmpty()) //If User found  
                        {
                            for(User user : usr){
                                acc.OwnerId = user.Id; 
                                system.debug('Name :'+user.Name);
                                //Set owner of student
                                system.debug('user.Last_Assignment_Date_Time__c :'+user.Last_Assignment_Date_Time__c);
                                user.Last_Assignment_Date_Time__c = System.now(); //Update last assignment date of User
                                
                                //update user;
                                userList.add(user);  
                                system.debug('user.Last_Assignment_Date_Time__c :'+user.Last_Assignment_Date_Time__c);
                                break;
                            }
                        }else {
                            //Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'StudentOpsManage'];
                            acc.OwnerId = config.Value__c;
                        }
                    }
                    
                    
                }
                
            }//for loop end
            
            if(userList.size()>0)
                update userList;
        }
        
        
        //get user record based oon filter provided in parameter
        public static List<User> getUserRecord(Map<String, String> filterMapObj) {
            
            Set<String> filterKeysetList = filterMapObj.keySet();
            String queryString = '';
            String filtersString = '';
            integer counter = 1;
            for(String str: filterMapObj.keySet()) {
                String queryStr = filterMapObj.get(str);
                //String 
                //String fieldType = String.valueOf(User.str.getSObjectType());
                if(filterKeysetList.size() == 1) {
                    filtersString = filtersString + str +'= :queryStr';
                } else {
                    if(counter == 1) {
                        filtersString = filtersString + str +'= :queryStr';
                        counter++;  
                    } else {
                        filtersString = filtersString + ' AND ' + str +'= :queryStr';
                    }
                }
            }
            
            String addtionalOrderByString = 'ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST';
            
            String finalQueryString = 'Select id, name From User Where '+ filtersString + ' ' + addtionalOrderByString;
            system.debug('before selecty query-- ' + finalQueryString);
            List<User> getUserList = Database.query(finalQueryString);
            
            return getUserList;
        }
        
        
        
    }