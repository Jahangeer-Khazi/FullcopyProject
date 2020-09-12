@isTest
public class UserListController_Test {
	@isTest
    static void testData() {
        UserRole r = [Select id from UserRole where Name = 'Student Ops Manager'];
    //    insert r;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'test', Email='abc@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingg', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='whjhr@testorg.com',
                          Status__c = 'Available',Call_Availability_Status__c = 'Available'     );
        insert u;
        u.Status__c = 'Available';
        u.Call_Availability_Status__c = 'Unavailable';
       	update u;
        
        UserListController.findUsers();
        UserListController.updateUsers(u);
        UserListController.retriveUsers('ra');
    }
}