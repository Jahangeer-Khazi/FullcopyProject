/*White Hat Junior AssignUser TEST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 17/09/2019
*Purpose: This Test class is to test Data for WHJ_AssignUser trigger.
*/ 


@isTest
public class WHJ_AssignUser_Test {
    
    @testSetup static void setup() {
        UserRole r = [Select id from UserRole where Name = 'Sales Manager'];
        //insert r;
        UserRole r1 = [Select id from UserRole where Name = 'Renewals Manager'];
        UserRole r2 = [Select id from UserRole where Name = 'Referral Manager'];
        
        UserRole r3 = [Select id from UserRole where Name = 'Referral Manager - USA'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pro.Id, UserRoleId = r1.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhrtest1@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                          ,Sales_Region__c = 'International'    );
        insert u;
        
             User u9 = new User(Alias = 'test123', Email='abc123@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available', Package_Type__c = 'APT' 
                           ,Sales_Region__c = 'IndiaV2'    );
        insert u9;
        User u10 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u10; 
        
        
        User u2 = new User(Alias = 'test12', Email='abc12@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg12', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr12test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'IndiaV2'    );
        insert u2;
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1 = new User(Alias = 'test1', Email='abc1@gmail.com', 
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r1.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u1; 
        
        User u3 = new User(Alias = 't23', Email='abc123@gmail.com',  isActive = false ,
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123test1@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u3;
        
        User u4 = new User(Alias = 'te34', Email='abc1234@gmail.com', isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Testingg1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r2.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1234te@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u4; 
        
        User u5 = new User(Alias = 'tes356', Email='abc123225@gmail.com',  isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Test3ingg51', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r3.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr123te@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u5;
        
        User u6 = new User(Alias = 'te336', Email='abc13332345@gmail.com', isActive = true ,
                           EmailEncodingKey='UTF-8', LastName='Test33ingg31', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r3.id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='whjhr1234test12@testorg.com',
                           Status__c = 'Available',Call_Availability_Status__c = 'Available' 
                           ,Sales_Region__c = 'International'    );
        insert u6; 
    }
    
    static testMethod void testUnitif(){
        Account acc = new Account();
        acc.LastName = 'test';
        acc.BillingCountry = 'India';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.SalesRef__c = 'abc@gmail.com';
        insert oppo;
        
        Configuration__mdt config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'SalesMangerID'];
        oppo.OwnerId = config.Value__c;
        
        WHJ_Utils.getDefaultManagerId('India', 'New');
    }
    
    static testMethod void testassignForV2(){
        Account acc = new Account();
        acc.LastName = 'testAssign';
        acc.BillingCountry = 'IndiaV2';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.course_short_name__c = 'PRO';
        insert oppo;
    }
    
     static testMethod void testassignForRenewalAPT(){
        Account acc = new Account();
        acc.LastName = 'testAssign';
        acc.BillingCountry = 'India';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'Renewal';
        oppo.course_short_name__c = 'APT';
        insert oppo;
    }
    
    
    static testMethod void testassignForInternational(){
        Account acc = new Account();
        acc.LastName = 'testAssign';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        insert oppo;
    }
    
    static testMethod void testUnitelse(){  
        
        Account acc = new Account();
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo 	.course_short_name__c = 'BEG';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'Renewal';
        insert oppo;
    }
    
    static testMethod void testUnitelseV2(){  
        Account acc = new Account();
        acc.BillingCountry = 'IndiaV2';
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.course_short_name__c = 'BEG';
        oppo.Type = 'Renewal';
        insert oppo;
    }
    
    static testMethod void testUnitelseIndia(){  
        
        Account acc = new Account();
        acc.BillingCountry = 'India';
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.course_short_name__c = 'BEG';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'Renewal';
        insert oppo;
    }
    
    static testMethod void testforReferrals(){  
        Account acc = new Account();
        acc.BillingCountry = 'India';
        acc.LastName = 'test acc';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'India';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.course_short_name__c = 'BEG';
        oppo.Referral_Customer__c ='test@gmail.com';
        insert oppo;
    }
    
    static testMethod void testforReferrals2(){  
        Account acc = new Account();
        acc.BillingCountry = 'India';
        acc.LastName = 'test acc';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'India';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'test@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.course_short_name__c = 'BEG';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.Type = 'Referral';
        insert oppo1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        oppo.Referral_Manager__c ='abc123@gmail.com';
        oppo.course_short_name__c = 'BEG';
        insert oppo;
    }
    
    static testMethod void testforReferrals3(){  
        Account acc = new Account();
        acc.BillingCountry = 'India';
        acc.LastName = 'test acc';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'India';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'test@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.course_short_name__c = 'BEG';
        oppo1.Type = 'Referral';
        insert oppo1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        oppo.course_short_name__c = 'BEG';
        oppo.Referral_Manager__c ='abc1234@gmail.com';
        insert oppo;
    }
    
    static testMethod void testforReferrals4(){  
        Account acc = new Account();
        acc.BillingCountry = 'India';
        acc.LastName = 'test acc';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'India';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'test@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.course_short_name__c = 'BEG';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.Type = 'Referral';
        insert oppo1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        oppo.course_short_name__c = 'BEG';
        oppo.Referral_Manager__c ='abc1234@gmail.com';
        insert oppo;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.AccountId = acc.Id;
        oppo2.Name = 'whj test';
        oppo2.Email__c = 'harsh.gughane.51@gmail.com';     
        oppo2.StageName = 'WON-PART PAYMENT';
        oppo2.CloseDate = Date.newInstance(1960, 2, 17);
        oppo2.Type = 'New Student';
        oppo2.Referral_Customer__c ='test1@gmail.com';
        oppo2.course_short_name__c = 'BEG';
        oppo2.Referral_Manager__c ='abc1234@gmail.com';
        insert oppo2;
        
        Opportunity oppo3 = new Opportunity();
        oppo3.AccountId = acc.Id;
        oppo3.Name = 'whj test';
        oppo3.Email__c = 'harsh.gughane.52@gmail.com';     
        oppo3.StageName = 'WON-PART PAYMENT';
        oppo3.CloseDate = Date.newInstance(1960, 2, 17);
        oppo3.Type = 'New Student';
        oppo3.Referral_Customer__c ='test2@gmail.com';
        oppo3.Referral_Manager__c ='abc1234@gmail.com';
        oppo3.course_short_name__c = 'BEG';
        insert oppo3;
        
        Opportunity oppo4 = new Opportunity();
        oppo4.AccountId = acc.Id;
        oppo4.Name = 'whj test';
        oppo4.Email__c = 'harsh.gughane.53@gmail.com';     
        oppo4.StageName = 'WON-PART PAYMENT';
        oppo4.CloseDate = Date.newInstance(1960, 2, 17);
        oppo4.Type = 'New Student';
        oppo4.Referral_Customer__c ='test3@gmail.com';
        oppo4.course_short_name__c = 'BEG';
        oppo4.Referral_Manager__c ='abc1234@gmail.com';
        insert oppo4;
    }
    
    static testMethod void testforReferrals5(){  
        Account acc = new Account();
        acc.BillingCountry = 'USA';
        acc.LastName = 'test acc';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'USA';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.Type = 'Referral';
        oppo1.course_short_name__c = 'BEG';
        insert oppo1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        oppo.Referral_Manager__c ='abc1234@gmail.com';
        oppo.course_short_name__c = 'BEG';
        insert oppo;
    }
    
    static testMethod void testforReferrals6(){  
        
        Account acc = new Account();
        acc.BillingCountry = 'USA';
        acc.LastName = 'test acc';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'USA';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'test@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.course_short_name__c = 'BEG';
        oppo1.Type = 'Referral';
        insert oppo1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        oppo.Referral_Manager__c ='abc1234@gmail.com';
        oppo.course_short_name__c = 'BEG';
        insert oppo;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.AccountId = acc.Id;
        oppo2.Name = 'whj test';
        oppo2.Email__c = 'harsh.gughane.51@gmail.com';     
        oppo2.StageName = 'WON-PART PAYMENT';
        oppo2.CloseDate = Date.newInstance(1960, 2, 17);
        oppo2.Type = 'New Student';
        oppo2.Referral_Customer__c ='test1@gmail.com';
        oppo2.Referral_Manager__c ='abc1234@gmail.com';
        oppo2.course_short_name__c = 'BEG';
        insert oppo2;
        
        Opportunity oppo3 = new Opportunity();
        oppo3.AccountId = acc.Id;
        oppo3.Name = 'whj test';
        oppo3.Email__c = 'harsh.gughane.52@gmail.com';     
        oppo3.StageName = 'WON-PART PAYMENT';
        oppo3.CloseDate = Date.newInstance(1960, 2, 17);
        oppo3.Type = 'New Student';
        oppo3.Referral_Customer__c ='test2@gmail.com';
        oppo3.Referral_Manager__c ='abc1234@gmail.com';
        oppo3.course_short_name__c = 'BEG';
        insert oppo3;
        
        Opportunity oppo4 = new Opportunity();
        oppo4.AccountId = acc.Id;
        oppo4.Name = 'whj test';
        oppo4.Email__c = 'harsh.gughane.53@gmail.com';     
        oppo4.StageName = 'WON-PART PAYMENT';
        oppo4.CloseDate = Date.newInstance(1960, 2, 17);
        oppo4.Type = 'New Student';
        oppo4.Referral_Customer__c ='test3@gmail.com';
        oppo4.Referral_Manager__c ='abc1234@gmail.com';
        oppo4.course_short_name__c = 'BEG';
        insert oppo4;
    }
    
    static testMethod void testforReferrals8(){  
        Account acc1 = new Account();
        acc1.BillingCountry = 'India';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'test@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
oppo1.course_short_name__c = 'BEG';
        oppo1.Type = 'Referral';
        insert oppo1;
        
        Account acc = new Account();
        acc.BillingCountry = 'India';
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.course_short_name__c = 'BEG';
        oppo.Referral_Customer__c ='test@gmail.com';
        insert oppo;
    }
    
    static testMethod void testforReferrals9(){  
        Account acc1 = new Account();
        acc1.BillingCountry = 'USA';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo1 = new Opportunity();
        oppo1.AccountId = acc1.Id;
        oppo1.Name = 'whj test';
        oppo1.Email__c = 'test@gmail.com';     
        oppo1.StageName = 'WON-PART PAYMENT';
        oppo1.CloseDate = Date.newInstance(1960, 2, 17);
        oppo1.Type = 'Referral';
        oppo1.course_short_name__c = 'BEG';
        insert oppo1;
        
        Account acc = new Account();
        acc.BillingCountry = 'USA';
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        oppo.course_short_name__c = 'BEG';
        insert oppo;
    }
    
    
    static testMethod void testforReferrals11(){  
        Account acc = new Account();
        acc.BillingCountry = 'USA';
        acc.LastName = 'test acc1';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'USA';
        acc1.LastName = 'test acc';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.course_short_name__c = 'BEG';
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.Referral_Customer__c ='test@gmail.com';
        insert oppo;
        
        Account acc2 = new Account();
        acc2.BillingCountry = 'USA';
        acc2.LastName = 'test acc11';
        insert acc2;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.AccountId = acc2.Id;
        oppo2.Name = 'whj test';
        oppo2.course_short_name__c = 'BEG';
        oppo2.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo2.StageName = 'WON-PART PAYMENT';
        oppo2.CloseDate = Date.newInstance(1960, 2, 17);
        oppo2.Type = 'New Student';
        oppo2.Referral_Customer__c ='test@gmail.com';
        insert oppo2;
        
    }
    
    static testMethod void testforReferrals12(){  
        list<Opportunity> lstop = new List<Opportunity>();
        Account acc = new Account();
        acc.BillingCountry = 'INDIA';
        acc.LastName = 'test acc2';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'INDIA';
        acc1.LastName = 'test acc22';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
		Account acc2 = new Account();
        acc2.BillingCountry = 'INDIAV2';
        acc2.LastName = 'test acc222';
        insert acc2;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.AccountId = acc2.Id;
        oppo2.Name = 'whj test';
        oppo2.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo2.StageName = 'WON-PART PAYMENT';
        oppo2.CloseDate = Date.newInstance(1960, 2, 17);
        oppo2.Type = 'New Student';
        oppo2.course_short_name__c = 'BEG';
        
        lstop.add(oppo2);
        insert lstop;
        
    }
    static testMethod void testforReferrals13(){  
        list<Opportunity> lstop = new List<Opportunity>();
        Account acc = new Account();
        acc.BillingCountry = 'INDIA';
        acc.LastName = 'test acc2';
        insert acc;
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'INDIA';
        acc1.LastName = 'test acc22';
        acc1.PersonEmail = 'test@gmail.com';
        insert acc1;
        
        Account acc2 = new Account();
        acc2.BillingCountry = 'INDIA';
        acc2.LastName = 'test acc222';
        insert acc2;
        
        Opportunity oppo2 = new Opportunity();
        oppo2.AccountId = acc2.Id;
        oppo2.Name = 'whj test';
        oppo2.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo2.StageName = 'WON-PART PAYMENT';
        oppo2.CloseDate = Date.newInstance(1960, 2, 17);
        oppo2.Type = 'New Student';
        oppo2.course_short_name__c ='APT';
        
        
        lstop.add(oppo2);
        insert lstop;
        
    }
    
    
    static testMethod void validateAPTLeads(){  
        user usr = [select id from user where email = 'abc123@gmail.com' limit 1];
        
        Account acc = new Account();
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.course_short_name__c = 'APT';
        insert oppo;    
        system.assertNotEquals(oppo.Id, null);
    }
    
    static testMethod void validateAPTLeadsWithNoUser(){  
        user usr = [select id from user where email = 'abc123@gmail.com' limit 1];
        usr.Call_Availability_Status__c = 'Unavailable';
        update usr;
        system.debug('usr-- ' + usr);
        
        Account acc = new Account();
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.course_short_name__c = 'APT';
        insert oppo;    
        system.assertNotEquals(oppo.Id, null);
    }
    
    static testMethod void validateAPTLeadsWithSalesRef(){  
        user usr = [select id, email from user where email = 'abc123@gmail.com' limit 1];
        usr.Call_Availability_Status__c = 'Unavailable';
        update usr;
        system.debug('usr-- ' + usr);
        
        Account acc = new Account();
        acc.LastName = 'test acc';
        insert acc;
        
        Opportunity oppo = new Opportunity();
        oppo.AccountId = acc.Id;
        oppo.Name = 'whj test';
        oppo.Email__c = 'harsh.gughane.5@gmail.com';     
        oppo.StageName = 'WON-PART PAYMENT';
        oppo.CloseDate = Date.newInstance(1960, 2, 17);
        oppo.Type = 'New Student';
        oppo.course_short_name__c = 'APT';
        oppo.SalesRef__c = usr.Email;
        insert oppo;    
        system.assertNotEquals(oppo.Id, null);
    }
}