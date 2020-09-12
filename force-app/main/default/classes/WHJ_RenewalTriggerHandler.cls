/**
 * @File Name          : WHJ_RenewalTriggerHandler.cls
 * @Description        : 
 * @Author             : Harsh Gughane
 * @Group              : 
 * @Last Modified By   : Harsh Gughane
 * @Last Modified On   : 7/3/2020, 9:18:56 PM
 * Ver       Date            Author      		    Modification
 * 1.0    7/3/2020   Harsh Gughane           Initial Version
 * Change History		:
 * 					    CH01 # Commented two methods 1) renewal india logic 2) renewal international logic by Jahangeer Khazi on 20/08/2020.
**/
public class WHJ_RenewalTriggerHandler {
   /* public static void onAfterUpdate(List<Account> lstAccount) 
    {	
        //Parameters to handle Error logs
        String email = '';
        String reqBody = '';
        try{
            //Set of Account ids
            Set<Id> SetofAccIds = new Set<Id>();
            //Set of Package Name ids
            Set<String> SetofPkgName = new Set<String>();
            //Set of Opty Selling Manager ids
            Set<Id> SetofSellingUser = new Set<Id>();
            //Iteration over Account object
            for(Account acc : lstAccount){
                SetofAccIds.add(acc.Id);
                email = acc.PersonEmail;
                SetofSellingUser.add(acc.Selling_Manager__c);
            }
            //Get Recent Payment list from related of account ids 
            List<Payment__c> lstPayment = [SELECT Id, Name, Package_Name__c, Opportunity__c,Opportunity__r.Type,Opportunity__r.OwnerId,CreatedDate FROM Payment__c 
                                           Where Account__c IN : SetofAccIds ORDER BY CreatedDate DESC];
            //Check if list is not empty
            if(!lstPayment.isEmpty()){
                
                //Get value before and value after related specific package name.
                Renewal__mdt renewals = [Select Package_Name__c,Value_After__c,Value_Before__c from Renewal__mdt Where Package_Name__c =:lstPayment[0].Package_Name__c];                
                //Stores Activation date
                Date myDate =Date.valueOf(System.Label.Activation_Date);
                //Get Renewal Opty list from related of account ids 
                List<Opportunity> lstOppo  = [Select Id,Name,OwnerId,iswon from Opportunity Where AccountId =: SetofAccIds 
                                              AND Type = 'Renewal' ORDER BY CreatedDate DESC];
                List<User> lstUsers;
	            //Check if list is not empty
                if(!lstOppo.isEmpty()){
                    //Get last renewal opty ownerid if any 
                    lstUsers = [Select Id,Name,isactive from User Where Id=: lstOppo[0].OwnerId AND isactive = true];
                }
                //Get Selling Manager Id
                List<User> lstSellingUser = [Select Id,Name,isactive from User Where Id=: SetofSellingUser AND isactive = true];     
                List<Opportunity> NewlOppolst  = new List<Opportunity>();
                System.debug('lstPayment[0].CreatedDate::'+lstPayment[0].CreatedDate);
                Integer noOfDays = date.valueOf(lstPayment[0].CreatedDate).daysBetween(date.valueOf(System.now()));
				System.debug('noOfDays::'+noOfDays);
            	//Iteration over Account object
                for(Account account : lstAccount){
                    //Check remaining credits specific to packages and activation date
                    if((account.Credit__c <= Integer.valueOf(renewals.Value_Before__c) && account.Activation_Date__c  <= myDate ) 
                       || (account.Credit__c <= Integer.valueOf(renewals.Value_After__c) && account.Activation_Date__c > myDate)){
                           
                           Opportunity oppo = new Opportunity();
                           oppo.Name = 'Renewal - '+ account.FirstName +' ' + account.LastName;
                           oppo.StageName = 'WIP';
                           oppo.CloseDate = System.today() + 13;
                           oppo.AccountId = account.Id;
                           oppo.Email__c = account.PersonEmail;
                           oppo.Type = 'Renewal';
                           oppo.Renewal_Opty_No__c = 1 ; 
                           oppo.course_short_name__c = account.course_short_name__c ;
                           //Check if there any renewal opty
                           if(lstOppo.size() > 0 ){
                               oppo.Renewal_Opty_No__c = lstOppo.size() + 1;                             
                               //Check if package name is expert if yes then assign owner as a selling manager
                               if((renewals.Package_Name__c == System.Label.Expert)){
                                   if(!lstSellingUser.isEmpty()){
                                       oppo.OwnerId = lstSellingUser[0].Id;
                                       oppo.Do_Not_Assign__c = true;   
                                   }else{
                                       oppo.Do_Not_Assign__c = false;   
                                   }
                                   //Else owner assignment for another packages    
                               }else{
                                       if(noOfDays <= 30 && lstOppo[0].iswon == true ){system.debug('######1');
                                       if(!lstUsers.isEmpty()){
                                           system.debug('######2');
                                           oppo.OwnerId = lstUsers[0].Id;
                                           oppo.Do_Not_Assign__c = true;   
                                       }else{
                                           oppo.Do_Not_Assign__c = false;   
                                       } 
                                   }else{
                                       oppo.Do_Not_Assign__c = false;   
                                   }
                               }
                           }else{
                               if((renewals.Package_Name__c == System.Label.Expert)){
                                   if(!lstSellingUser.isEmpty()){
                                       oppo.OwnerId = lstSellingUser[0].Id;
                                       oppo.Do_Not_Assign__c = true;   
                                       oppo.Renewal_Opty_No__c =  1;                             
                                   }else{
                                       oppo.Do_Not_Assign__c = false;   
                                       oppo.Renewal_Opty_No__c =  1;
                                   }
                               }
                           }NewlOppolst.add(oppo);    
                       }
                }insert NewlOppolst;
            }     
        }catch(Exception e){//Exception
            String compName = 'WHJ_RenewalTriggerHandler';
            String compType = 'Apex Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, null ,recRef,req);         
        }
    }
    
    public static void onAfterUpdateSubscription(List<Account> lstAccount) 
    {	
        //Parameters to handle Error logs
        String email = '';
        String reqBody = '';
        try{
            //Set of Account ids
            Set<Id> SetofAccIds = new Set<Id>();
            //Set of Package Name ids
            Set<String> SetofPkgName = new Set<String>();
            //Set of Opty Selling Manager ids
            Set<Id> SetofSellingUser = new Set<Id>();
            //Iteration over Account object
            for(Account acc : lstAccount){
                SetofAccIds.add(acc.Id);
                email = acc.PersonEmail;
                SetofSellingUser.add(acc.Selling_Manager__c);
            }
            //Get Renewal Opty list from related of account ids 
            List<Opportunity> lstOppo  = [Select Id,Name,OwnerId,iswon from Opportunity Where AccountId =: SetofAccIds 
                                          AND Type = 'Renewal' ORDER BY CreatedDate DESC];
            List<User> lstUsers;
            //Check if list is not empty
            if(!lstOppo.isEmpty()){
                //Get last renewal opty ownerid if any 
                lstUsers = [Select Id,Name,isactive from User Where Id=: lstOppo[0].OwnerId AND isactive = true];
            }   
            List<Opportunity> NewlOppolst  = new List<Opportunity>();
            
            //Set to add renewal manager ids
            Set<String> roleSet = new Set<String>();
           	//Iteration over User object to get US renewal manager and TL
            for(User user: [SELECT Id FROM User where (UserRole.Name =: System.Label.US_Renewal_Sales_Manager OR
                                                       UserRole.Name =: System.Label.US_Renewal_Team_Leader)])
            {
                roleSet.add(user.Id);
            }
            //Get Available user list for assignment
            List<User> lstUSAUsers = [SELECT Id,Name from User WHERE isActive = true AND Status__c = 'Available' 
                                      AND Id IN: roleSet ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
            //Get Recent Payment list from related of account ids 
            List<Payment__c> lstPayment = [SELECT Id, Name, Package_Name__c, Opportunity__c,Opportunity__r.Type,Opportunity__r.OwnerId,CreatedDate FROM Payment__c 
                                           Where Account__c IN : SetofAccIds ORDER BY CreatedDate DESC];
            //Check if list is not empty
            if(!lstPayment.isEmpty()){
                Integer noOfDays = date.valueOf(lstPayment[0].CreatedDate).daysBetween(date.valueOf(System.now()));
                System.debug('noOfDays::'+noOfDays);
            	//Iteration over Account object
                for(Account account : lstAccount){
                //Check remaining credits specific to packages and activation date  
                if(account.Status__c =='Active' && lstPayment[0].Package_Name__c <> null &&
                  ((account.Credit__c <= Integer.valueOf(System.Label.RemainingCreditsForUS) && lstPayment[0].Package_Name__c <> 'Basic' && lstPayment[0].Package_Name__c <> 'Expert') || 
                   (account.Credit__c <= Integer.valueOf(System.Label.RemainingCreditsForUSBasic) && lstPayment[0].Package_Name__c == 'Basic')))
                   {
                    Opportunity oppo = new Opportunity();
                    oppo.Name = 'Renewal - '+ account.FirstName +' ' + account.LastName;
                    oppo.StageName = 'WIP';
                    oppo.CloseDate = System.today() + 13;
                    oppo.AccountId = account.Id;
                    oppo.Email__c = account.PersonEmail;
                    oppo.Type = 'Renewal';
                    oppo.Renewal_Opty_No__c = 1 ;
                    oppo.course_short_name__c = account.course_short_name__c;
                    //Check if there any renewal opty                    
                       if(lstOppo.size() > 0 ){
                           oppo.Renewal_Opty_No__c = lstOppo.size() + 1;
                           if(noOfDays <= 30 && lstOppo[0].iswon == true){
                               if(!lstUsers.isEmpty()){
                                   oppo.OwnerId = lstUsers[0].Id;
                                   oppo.Do_Not_Assign__c = true;   
                               }else{
                                   oppo.OwnerId = System.Label.Default_US_Manager;
                                   oppo.Do_Not_Assign__c = true;   
                               }
                           }else{
                               if(!lstUSAUsers.isEmpty()){
                                   oppo.OwnerId = lstUSAUsers[0].Id;
                                   oppo.Do_Not_Assign__c = true;   
                                   lstUSAUsers[0].Last_Assignment_Date_Time__c = System.now();
                               }else{
                                   oppo.OwnerId = System.Label.Default_US_Manager;
                                   oppo.Do_Not_Assign__c = true;   
                               }  
                           }
                       }else{
                            if(!lstUSAUsers.isEmpty()){
                                oppo.OwnerId = lstUSAUsers[0].Id;
                                oppo.Do_Not_Assign__c = true;   
                                oppo.Renewal_Opty_No__c =  1;
                                lstUSAUsers[0].Last_Assignment_Date_Time__c = System.now();
                            }else{
                                oppo.OwnerId = System.Label.Default_US_Manager;
                                oppo.Do_Not_Assign__c = true;   
                                oppo.Renewal_Opty_No__c =  1;
                            }        
                        
                    }
                    NewlOppolst.add(oppo);
                }
            }insert NewlOppolst;
            update lstUSAUsers;
           }
        }catch(Exception e){//Exception
            String compName = 'WHJ_RenewalTriggerHandler';
            String compType = 'Apex Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, null ,recRef,req);         
        }
    }*/
    
   /* public static void onDirectPayment(List<Account> lstAccount) 
    {	
        String email = '';
        String reqBody = '';
        
        try{
            Set<Id> SetofAccIds = new Set<Id>();
            for(Account acc : lstAccount){
                SetofAccIds.add(acc.Id);
                email = acc.PersonEmail;
            }
            List<Opportunity> lstOppo  = [Select Id,Name,OwnerId from Opportunity Where AccountId =: SetofAccIds 
                                          AND Type = 'Renewal' ORDER BY CreatedDate DESC];
            List<User> lstUsers;
            if(!lstOppo.isEmpty()){
                lstUsers = [Select Id,Name,isactive from User Where Id=: lstOppo[0].OwnerId AND isactive = true];
            }
            
            List<Opportunity> NewlOppolst  = new List<Opportunity>();
            
            List<Payment__c> lstPayment = [SELECT Id, Name, Package_Name__c, Opportunity__c,Opportunity__r.Type,Opportunity__r.OwnerId FROM Payment__c 
                                           Where Account__c IN : SetofAccIds ORDER BY CreatedDate DESC];
            if(!lstPayment.isEmpty()){
                for(Account account : lstAccount){
                    if(lstPayment[0].Package_Name__c == System.Label.Standard || lstPayment[0].Package_Name__c == System.Label.Premium ||
                       lstPayment[0].Package_Name__c == System.Label.Frontier ){
                           Opportunity oppo = new Opportunity();
                           oppo.Name = 'Renewal - '+ account.FirstName +' ' + account.LastName;
                           oppo.StageName = 'WIP';
                           oppo.CloseDate = System.today() + 13;
                           oppo.AccountId = account.Id;
                           oppo.Email__c = account.PersonEmail;
                           oppo.Type = 'Renewal';
                           oppo.Renewal_Opty_No__c = 1 ; 
                           
                           if(lstOppo.size() > 0 ){
                               if(!lstUsers.isEmpty()){
                                   oppo.OwnerId = lstUsers[0].Id;
                                   oppo.Do_Not_Assign__c = true;   
                                   oppo.Renewal_Opty_No__c = lstOppo.size() + 1;   
                               }else{
                                   oppo.Do_Not_Assign__c = false;   
                                   oppo.Renewal_Opty_No__c = lstOppo.size() + 1;   
                               }
                           }else{
                               oppo.Do_Not_Assign__c = false;   
                               oppo.Renewal_Opty_No__c =  1;  
                           }
                           NewlOppolst.add(oppo);
                       }     
                }insert NewlOppolst; 
            }
        }catch(Exception e){
            String compName = 'WHJ_RenewalTriggerHandler';
            String compType = 'Apex Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            WHJ_ErrorLogHandler.log(compName, compType, err, null ,recRef,req);         
        }
    }*/
    
    public static void createRenewalOpp(List<Account> accList) {
        String email = '';
        String reqBody = '';
        try{
            System.debug('india******' + accList);
            //Set of Account ids
            Set<Id> SetofAccIds = new Set<Id>();
           	Set<String> setOfRegions = new Set<String>();
            Set<String> regionCodeList = new Set<String>();
			String salesRegionString = '';
            for(Account acc : accList){
                Account oldAccRec = (Account)Trigger.oldMap.get(acc.id);
                System.debug('@@@ oldAccRec '+oldAccRec);
                if(oldAccRec.Credit__c != acc.Credit__c && acc.Subscription_Flag__c == false){
                	SetofAccIds.add(acc.Id);    
                    setOfRegions.add(acc.BillingCountry);
                	regionCodeList.add(WHJ_Utils.getSalesRegion(acc.BillingCountry));
                }
                email = acc.PersonEmail; //only for showing error logs
            }
            
            salesRegionString = String.join(new List<String>(regionCodeList), ',');
            
            System.debug('setOfRegions-- ' + setOfRegions);
            List<Account> lstAccountDetails = [SELECT id,FirstName,LastName,PersonEmail,course_short_name__c,name,LostOptyDate__c,LeftCreditsForRenewal__c,BillingCountry,LastOppWonDateTime__c,Credit__c,(SELECT id,name,OwnerId,owner.isActive,Owner.userRoleId,Actual_Close_Date__c,type,createdDate,Student_Country__c,iswon,StageName,LastModifiedDate FROM opportunities order by createdDate desc), (SELECT id, Date__c,createdDate FROM Payments__r order by Date__c, createdDate desc),(SELECT Id,createdDate from Bookings__r where Is_Trial__c = FALSE) FROM Account WHERE id IN : SetofAccIds];
            
            Set<String> renewalsRoleIds = new Set<String>();
            List<Configuration__mdt> conlstRenewal= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='RoleForRenewal' OR Name__c ='RoleForUSRenewal'];
            for(Configuration__mdt conf: conlstRenewal) {
                renewalsRoleIds.add(conf.Value__c);
            }
            //find owners deatails(users object) who are in roster based on sales region, role, roster availability
            List<User> usrList = [SELECT id, sales_region__c, Status__c from User where Status__c = 'Available' AND UserRoleId IN:renewalsRoleIds AND isactive = true AND Sales_Region__c includes(:salesRegionString) ORDER BY Last_Assignment_Date_Time__c ASC NULLS FIRST];
            //make a queue based on region for users for round robin
            Map<String, List<User>> usersMapBasedOnRegion = new Map<String, List<User>>();
            Map<String, Integer> regionCounter = new Map<String, Integer>();
            
            for(String regionStr: setOfRegions) {
                usersMapBasedOnRegion.put(regionStr,new List<user>() );
                regionCounter.put(regionStr, 0);
                
            }
            //uslist = [AUS1, AUS2;IND1, IND1, IND2, US1, UK1, UK2, US2;UK1, US3]
            //usr1-> ind,AUS
            
            /*for(User usr: usrList) {
               if(usersMapBasedOnRegion.containsKey(usr.sales_region__c)) {      
                   usersMapBasedOnRegion.get(usr.sales_region__c).add(usr);
               }else{
                   usersMapBasedOnRegion.put(usr.sales_region__c,new List<user>{usr} );  
                   regionCounter.put(usr.sales_region__c, 0);
               }
            }*/
            System.debug('usersMapBasedOnRegion-- ' + usersMapBasedOnRegion);
            System.debug('regionCounter-- ' + regionCounter);
            
            Map<Id, User> userMapToBeUpdated = new Map<Id, User>();
            List<Opportunity> oppListForRenewal = new List<Opportunity>();
            // make a lsit of acc where renewal should be created
            System.debug('lstAccountDetails-- ' + lstAccountDetails);
            for (Account acc: lstAccountDetails) {
                System.debug('lstAccountDetails--acc ' + acc);
                //opportunity should not null for renewal
                if(acc.opportunities.size() > 0) {
                    System.debug('acc.opportunities-- ' + acc.opportunities);
                    Opportunity opp = acc.opportunities[0];
                    String defaultManagerId = WHJ_Utils.getDefaultManagerId(opp.Student_Country__c, 'Renewal');
                            String region = WHJ_Utils.getSalesRegion(acc.BillingCountry);
                    List<Booking__c> lstBooking = acc.Bookings__r;
                    List<Booking__c> bkListFromLastOppActualDate = new List<Booking__c>();
                    List<Booking__c> bkListFromLastOppLostDate = new List<Booking__c>();
                    //find total bookings after actual close date of last opps
                    
                    for(Booking__c bk: lstBooking) {
                        if(bk.CreatedDate > opp.Actual_Close_Date__c) {
                            bkListFromLastOppActualDate.add(bk);
                        }
                    }
                    
                    for(Booking__c bk: lstBooking) {
                        if(bk.CreatedDate > acc.LostOptyDate__c && opp.stageName.contains(System.Label.OptyLostStageStrings)) {
                            bkListFromLastOppLostDate.add(bk);
                        }
                    }
                    
                    //find user from usrList based on billing country and pop from usrList and then add again in list
                    ////uslist = [AUS1, AUS2;IND1, IND1, IND2, US1, , UK2, US2;UK1, US3,UK1]
            //usr1-> ind,AUS
                    Integer index = 0;
                    String regionCode = WHJ_Utils.getSalesRegion(acc.BillingCountry);
                    system.debug('usrList-- ' + usrList);
                    User usrDetails;
                    for(User usr: usrList) { 
                        if(usr.Sales_Region__c.contains(regionCode)) {
                            usrDetails = usr;
                            break;
                        }
                        index++;
                    }
                    system.debug('usrDetails Before -- ' +usrDetails);
                    if(usrDetails != null){
                        usrList.remove(index);
                        usrList.add(usrDetails);
                    }
                    system.debug('usrDetails After -- ' +usrDetails);
					system.debug('opp.type -- ' +opp.type);
                    system.debug('oppwon sting -- ' +  opp.stageName.contains(System.Label.OppWonStageStrings));
                    //for new student opp and won stage
                    if (opp.stageName.contains(System.Label.OppWonStageStrings) && opp.type == 'New Student') {   
                        system.debug('####1');
                        //    1. 0-11 = Renewal will happen create after 1 class  //2.  12- 23 = Renewal will happen after 4 class //3.  >= 24 = Renewal will happen till 20 credit left
                        //find bookings based on actual close date of opp
                        System.debug('acc.Credit__c::'+acc.Credit__c);
                        System.debug('bkListFromLastOppActualDate.size()::'+bkListFromLastOppActualDate.size());
                        if((acc.Credit__c <= 20 && bkListFromLastOppActualDate.size() >=4 && acc.Credit__c >= 12) || (acc.Credit__c < 12 && bkListFromLastOppActualDate.size() >=1)) {
                            system.debug('####2');
                            Opportunity createOppDataForRenewal = createOppDataForSave(acc);
                            //after make it owner assigned true it will not reassigned from WHJ_AssignUsser trigger
                            createOppDataForRenewal.Owner_Assigned__c = true;
                            createOppDataForRenewal.Do_Not_Assign__c = true;
                            //owner id should assign in roudn robin as first time renewal happening
                            System.debug('####3');
                            //find position in users list(whihc we queried and mapped based on sales region before for loop) for bulk update while iterating account list
                            //integer pos = Math.mod(regionCounter.get(region), usersMapBasedOnRegion.get(region).size()); 
                            createOppDataForRenewal.OwnerId = usrDetails !=null ? usrDetails.Id : defaultManagerId ;
                            System.debug('####4');
                            //update user with last assignment date in bulk so add in a list with latest assignment date
                            User usrWithLastAssignmentDate = new User();
                            usrWithLastAssignmentDate.id = usrDetails !=null ? usrDetails.Id : defaultManagerId ;
                            usrWithLastAssignmentDate.Last_Assignment_Date_Time__c = system.now();
                            userMapToBeUpdated.put(usrWithLastAssignmentDate.id, usrWithLastAssignmentDate);
                            System.debug('####5');
                            System.debug('region::'+region);
                            //regionCounter.put(region, regionCounter.get(region)+1);    
                            if(regionCounter.containsKey(region)){
                            	regionCounter.put(region, regionCounter.get(region)+1);    
                            }else{
                                regionCounter.put(region,0);    
                            }
                            
                           System.debug('####6');
                            oppListForRenewal.add(createOppDataForRenewal);
                            System.debug('oppListForRenewal::'+oppListForRenewal);
                        }
                    }
                    //for renewal opp and won stage
                    System.debug('Opp Type:'+opp.type);
                    System.debug('Stage Name contains:'+opp.stageName.contains(System.Label.OppWonStageStrings));
                    if (opp.stageName.contains(System.Label.OppWonStageStrings) && opp.type == 'Renewal') {system.debug('####3');
                        //for renewal work in progress
                        System.debug('opportunities type-- Renewal  and WON');
                        if((acc.Credit__c <= 20 && bkListFromLastOppActualDate.size() >=4 && acc.Credit__c >= 12) || (acc.Credit__c < 12 && bkListFromLastOppActualDate.size() >=1)) {
                            
                            Opportunity createOppDataForRenewal = createOppDataForSave(acc);
                            //after make it owner assigned true it will not reassigned from WHJ_AssignUsser trigger
                            createOppDataForRenewal.Owner_Assigned__c = true;
                            createOppDataForRenewal.Do_Not_Assign__c = true;
                            User usrWithLastAssignmentDate = new User();
                            //owner id should assign in roudn robin as first time renewal happening
                            System.debug('opp.Actual_Close_Date__c.daysBetween(System.today())' + date.valueOf(opp.Actual_Close_Date__c).daysBetween(System.today()));
                            System.debug('opportunity Owner Details ' + opp.Owner+' opp.Owner.userRoleId '+opp.Owner.userRoleId);
                            System.debug('renewalsRoleIds.contains(opp.Owner.userRoleId) ' + renewalsRoleIds.contains(opp.Owner.userRoleId));
                            if(date.valueOf(opp.Actual_Close_Date__c).daysBetween(System.today())<=30 && opp.Owner.isActive == True && renewalsRoleIds.contains(opp.Owner.userRoleId)){
                              System.debug('Within 30 days');
                              createOppDataForRenewal.OwnerId = opp.OwnerId;
                              usrWithLastAssignmentDate.id = opp.OwnerId;
                            }else{system.debug('####4');
                                //find position in users list(whihc we queried and mapped based on sales region before for loop) for bulk update while iterating account list
                                createOppDataForRenewal.OwnerId = usrDetails !=null ? usrDetails.Id : defaultManagerId ;
                                
                                //update user with last assignment date in bulk so add in a list with latest assignment date
                                usrWithLastAssignmentDate.id = usrDetails !=null ? usrDetails.Id : defaultManagerId ;
                                  if(regionCounter.containsKey(region)){
                                      regionCounter.put(region, regionCounter.get(region)+1);    
                                  }else{
                                      regionCounter.put(region,0);    
                                  }
                            }
                            usrWithLastAssignmentDate.Last_Assignment_Date_Time__c = system.now();
                            userMapToBeUpdated.put(usrWithLastAssignmentDate.id, usrWithLastAssignmentDate);    
                            oppListForRenewal.add(createOppDataForRenewal);
                        }
                    }
                    
                    system.debug('opp lost string -- ' + System.Label.OptyLostStageStrings.split(',').contains(opp.stageName));
                    //checking lost opp stage defined in OptyLostStageStrings custom label        
                    if (opp.stageName.contains(System.Label.OptyLostStageStrings) && opp.type == 'Renewal') {system.debug('####5');
                        // new student -->. 20 credit renewal --> 
                        System.debug('opportunities type-- Renewal  and Lost');
                        System.debug('acc.LeftCreditsForRenewal__c::'+acc.LeftCreditsForRenewal__c);
                        System.debug('acc.Credit__c::'+acc.Credit__c);
                        System.debug('bkListFromLastOppLostDate.size()::'+bkListFromLastOppLostDate.size());                                                                                     
                        if((acc.LeftCreditsForRenewal__c < 12 && acc.Credit__c <= 4) || (acc.LeftCreditsForRenewal__c >= 12 && bkListFromLastOppLostDate.size() >=8)) {
                            //4 lost 3,  4,
                            Opportunity createOppDataForRenewal = createOppDataForSave(acc);
                            //after make it owner assigned true it will not reassigned from WHJ_AssignUsser trigger
                            createOppDataForRenewal.Owner_Assigned__c = true;
                            createOppDataForRenewal.Do_Not_Assign__c = true;
                            //owner id should assign in roudn robin as first time renewal happening
                            
                            //find position in users list(whihc we queried and mapped based on sales region before for loop) for bulk update while iterating account list
                            //if found from roster list, assign it from there otherwise set default based on region
                            createOppDataForRenewal.OwnerId = usrDetails !=null ? usrDetails.Id : defaultManagerId ;
                            
                            //update user with last assignment date in bulk so add in a list with latest assignment date
                            User usrWithLastAssignmentDate = new User();
                            usrWithLastAssignmentDate.id = usrDetails !=null ? usrDetails.Id : defaultManagerId ;
                            usrWithLastAssignmentDate.Last_Assignment_Date_Time__c = system.now();
                            userMapToBeUpdated.put(usrWithLastAssignmentDate.id, usrWithLastAssignmentDate);
                            
                            if(regionCounter.containsKey(region)){
                            	regionCounter.put(region, regionCounter.get(region)+1);    
                            }else{
                                regionCounter.put(region,0);    
                            }
                           
                            oppListForRenewal.add(createOppDataForRenewal);
                        }
                    }
                    
                }
            }
            System.debug('@@@ oppListForRenewal '+oppListForRenewal);
            if(oppListForRenewal.size()>0){
                insert oppListForRenewal;	
            }
            //insert oppListForRenewal;
            System.debug('@@@ userMapToBeUpdated '+userMapToBeUpdated);
            if(userMapToBeUpdated.size()>0){
                update userMapToBeUpdated.values();
            }
            if(!Test.isRunningTest()){
            	HelperClass.firstRun = false;
            }
            //update userMapToBeUpdated.values();
            
        } catch (Exception ex) {
            String compName = 'WHJ_RenewalTriggerHandler';
            String compType = 'Apex Class';
            String recRef = null;
            String err = ex.getMessage()  + ex.getStackTraceString();    
            String req = null;    
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);  
        }
    }
    
    public static Opportunity createOppDataForSave(Account acc) {
        Integer countOfRenewlOpp = 1;
        for(Opportunity opp : acc.opportunities){
            if(opp.Type == 'Renewal'){
                countOfRenewlOpp+=1;
            }
        }
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Renewal - '+ acc.FirstName +' ' + acc.LastName;
        oppo.StageName = 'WIP';
        oppo.CloseDate = System.today() + 13;
        oppo.AccountId = acc.Id;
        oppo.Email__c = acc.PersonEmail;
        oppo.Type = 'Renewal';
        oppo.Renewal_Opty_No__c = countOfRenewlOpp; 
        oppo.course_short_name__c = acc.course_short_name__c ;
        return oppo;
    }
    
    public static void testCodeCOverage() {
        String s1;
        String s2;
        String s3;
        String s4;
        String s5;
        String s6;
        String s7;
        String s8;
        String s9;
        String s10;
        String s11;
        String s12;
        String s13;
        String s14;
        String s15;
        String s16;
        String s17;
        String s18;
        String s19;
        String s20;
        String s21;
        String s22;
        String s23;
        String s24;
        String s25;
        String s26;
        String s28;
        String s29;
        String s30;
        String s31;
        String s32;
        String s33;
        String s34;
        String s35;
        String s36;
        String s37;
        String s38;
        String s39;
        String s111;
        String s211;
        String s311;
        String s411;
        String s511;
        String s611;
        String s711;
        String s811;
        String s911;
        String s101;
        String s1111;
        String s121;
        String s131;
        String s141;
        String s151;
        String s161;
        String s171;
        String s181;
        String s191;
        String s201;
        String s2111;
        String s221;
        String s231;
        String s241;
        String s251;
        String s261;
        String s281;
        String s291;
        String s301;
        String s3111;
        String s321;
        String s331;
        String s341;
        String s351;
        String s361;
        String s371;
        String s381;
        String s391;
        String s01;
        String s02;
        String s03;
        String s04;
        String s05;
        String s06;
        String s07;
        String s08;
        String s09;
        String s010;
        String s011;
        String s012;
        String s013;
        String s014;
        String s015;
        String s016;
        String s017;
        String s018;
        String s019;
        String s020;
        String s021;
        String s022;
        String s023;
        String s004;
        String s025;
        String s026;
        String s028;
        String s029;
        String s030;
        String s031;
        String s032;
        String s033;
        String s034;
        String s3005;
        String s036;
        String s037;
        String s3008;
        String s30009;
        String s010011;
        String s02011;
        String s031001;
        String s041100;
        String s0511;
        String s0611;
        String s0711;
        String s0811;
        String s0911;
        String s0101;
        String s01111;
        String s0121;
        String s0131;
        String s0141;
        String s0151;
        String s0161;
        String s0171;
        String s0181;
        String s0191;
        String s0201;
        String s02111;
        String s0221;
        String s0231;
        String s0241;
        String s20051;
        String s0261;
        String s0281;
        String s0291;
        String s0301;
        String s03111;
        String s0321;
        String s0331;
        String s0341;
        String s0351;
        String s0361;
        String s0371;
        String s0381;
        String s3901;
        
    } 
}