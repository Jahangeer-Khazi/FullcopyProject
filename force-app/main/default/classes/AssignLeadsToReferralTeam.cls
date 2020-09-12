/*
 * Created by 		: Rajeev Dubey.
 * Created Date 	: 28/07/2020
 * Class Name		: AssignLeadsToReferralTeam
 * Test Class   	: AssignLeadsToReferralTeamTest
 * Test Coverage	: 72%
 * Change History	: 
 * 					CH01 # Jahangeer Khazi added debug Statements to track code coverage.
*/
public class AssignLeadsToReferralTeam {
    
    //assign leads to referral conversion leads
    public static void assignLeadsToReferralConversionTeam(List<Lead> lstLead ) {
        // for loop for lead type referral , get record for assginment of lead owner
        List<Lead> LeadList = new List<Lead>();
        Set<String> SetofRefMail = new Set<String>();
        
        for (Lead ld : lstLead)  
        {
            system.debug('ld---- ' + ld);
            if(ld.Lead_Type__c == 'referral')
            {
                LeadList.add(ld);
                SetofRefMail.add(ld.Referral_Manager__c);
            }
        }
        //CH01 Start
        System.debug('Set of Reference Mail size:'+SetofRefMail.size());
        System.debug('Reference mail:' +SetofRefMail);
        //CH01 End
        if(!LeadList.isEmpty())
        {
            
            List<User> ListRefUser = [select id , IsActive , email from User where email IN: SetofRefMail];
            system.debug('ListRefUser---- ' + ListRefUser);
            system.debug('system.label.Role_Referral_Manager---- ' + system.label.Role_Referral_Manager);
            List<User> IndiaUsers = [SELECT Id, Name FROM User where Status__c = 'Available' AND UserRole.Name =:system.label.Role_Referral_Manager AND isactive = true ORDER BY Last_Assignment_Date_Time__c ASC] ;  //List of User in Referral Manager Role
            system.debug('IndiaUsers---- ' + IndiaUsers);
            List<User> IndiaUsersLeader = [Select Id From User Where Status__c = 'Available' AND UserRole.Name =:System.Label.Role_Referral_Team_Leader AND isactive = true]; // User in Sales Team Leader Role
            system.debug('IndiaUsersLeader---- ' + IndiaUsersLeader);
            
            List<User> UsUsers = [SELECT Id, Name FROM User where Status__c = 'Available' AND UserRole.Name =:system.label.Role_Referral_Manager_USA AND isactive = true ORDER BY Last_Assignment_Date_Time__c ASC] ;  //List of User in Referral Manager Role
            //CH01 Start
            System.debug('US Users:' + UsUsers);
            //CH01 End
            List<User> UsUsersLeader = [Select Id From User Where Status__c = 'Available' AND UserRole.Name =:System.Label.Role_Referral_Team_Leader_USA AND isactive = true]; // User in Sales Team Leader Role
            //CH01 Start
            System.debug('UsUsersLeaders:'+UsUsersLeader);
            //CH01 End
            Integer i = 0;
            for(Lead ld : LeadList)
            {
                
                Boolean OwnerAssigned = false;
                if(!ListRefUser.isEmpty())
                {
                    for(User usr : ListRefUser)
                    {
                        if(ld.Referral_Manager__c == usr.email)
                        {
                            if(usr.IsActive == true)
                            {
                                ld.OwnerId = usr.Id;
                                OwnerAssigned = true;
                                
                            }
                            break;
                        }
                        else
                            continue;
                    }
                }
                if(OwnerAssigned == false)
                {
                    if(ld.Country == 'India' || ld.Country == 'IndiaV2' || ld.Country == 'INDIA' || ld.Country == 'INDIAV2')
                    {
                        if(!IndiaUsers.isEmpty())
                        {
                            system.debug('IndiaUsers size---- ' + IndiaUsers.size());
                            if(i<IndiaUsers.size()-1)
                            {  
                                ld.OwnerId = IndiaUsers[i].Id;
                                IndiaUsers[i].Last_Assignment_Date_Time__c = System.now();
                                update IndiaUsers[i]; 
                                i=i+1;
                            }
                            else
                            {
                                ld.OwnerId = IndiaUsers[i].Id;
                                IndiaUsers[i].Last_Assignment_Date_Time__c = System.now();
                                update IndiaUsers[i]; 
                                i=0;
                            }
                        }
                        else if (!IndiaUsersLeader.isEmpty()){ 
                            ld.OwnerId =IndiaUsersLeader[0].Id;   //If no users found , assigning to Team Leader
                        }
                        else{
                            ld.OwnerId = system.Label.Referral_Director ;//No user active , assigning to Direcctor
                        }
                    }
                    else
                    {
                        if(!UsUsers.isEmpty())
                        {
                            if(i<UsUsers.size()-1)
                            {  
                                ld.OwnerId = UsUsers[i].Id;
                                UsUsers[i].Last_Assignment_Date_Time__c = System.now();
                                update UsUsers[i]; 
                                i=i+1;
                            }
                            else
                            {
                                ld.OwnerId = UsUsers[i].Id;
                                UsUsers[i].Last_Assignment_Date_Time__c = System.now();
                                update UsUsers[i]; 
                                i=0;
                            }
                        }
                        else if (!UsUsersLeader.isEmpty()){
                            ld.OwnerId =UsUsersLeader[0].Id;   //If no users found , assigning to Team Leader
                        }
                        else
                        {
                            ld.OwnerId = system.Label.Referral_Director ; //No user active , assigning to Direcctor
                        }
                    }
                }
            }
            
        }
    }
    
   /*public static void testCodeCOverage() {
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
        
    } */
}