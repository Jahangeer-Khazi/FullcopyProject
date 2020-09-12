/**
 * @File Name          : UserListController.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Harsh Gughane
 * @Last Modified On   : 4/1/2020, 12:27:43 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/23/2019   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class UserListController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> findUsers() {
        
        Set<Id> setOfUserIdParent = new Set<Id>();
        Set<Id> setOfUserIdChild = new Set<Id>();
        Set<Id> setOfUserIdChildtoChild = new Set<Id>();
        List<User> lstUser = [Select Id,Name,Email,Phone,Status__c,Shifts__c,Call_Availability_Status__c,
        Sales_Region__c,ManagerId,UserRole__c,Manager__c FROM User where ManagerId=:UserInfo.getUserId()];
        
        for(User u : lstUser){
            setOfUserIdParent.add(u.Id);
            setOfUserIdChild.add(u.Id);
            setOfUserIdChildtoChild.add(u.Id);
        }
        
        List<User> lstUser1 = [Select Id,Name,Email,Phone,Status__c,Shifts__c,Call_Availability_Status__c,
        Sales_Region__c,ManagerId,UserRole__c,Manager__c from User where ManagerId IN: setOfUserIdParent];
        
        for(User u1 : lstUser1){
            setOfUserIdChild.add(u1.Id);
            setOfUserIdChildtoChild.add(u1.Id);
        }
        
        List<User> lstUser3 = [Select Id,Name,Email,Phone,Status__c,Shifts__c,Call_Availability_Status__c,
        Sales_Region__c,ManagerId,UserRole__c,Manager__c FROM User where ManagerId IN: setOfUserIdChild];
        
        for(User u2 : lstUser3){
            setOfUserIdChildtoChild.add(u2.Id);
        }
        
        
        List<User> lstUser2 = [Select Id,Name,Email,Phone,Status__c,Shifts__c,Call_Availability_Status__c,
        Sales_Region__c,UserRole__c,Manager__c FROM User where Id IN: setOfUserIdChildtoChild];
        return lstUser2;
    }
    
    
    
    @AuraEnabled
    public static List<User> updateUsers(User userObj) {
        System.debug('userObj::'+ userObj);
        update userObj;
        return findUsers();
    }

     //below method will be used in mainComponent 
@AuraEnabled(Cacheable = true)
public static List<User> retriveUsers(String strUserName) 
 {
  List<Rostering__mdt> roster = [Select Name__c,UserRole__c From Rostering__mdt];
        
  Set<String> roleSet = new Set<String>();
          for(Rostering__mdt user: roster)
          {
              roleSet.add(user.UserRole__c);
          }
  String query = 'Select Id,Name,Email,Phone,Status__c,Call_Availability_Status__c,Shifts__c,Sales_Region__c,UserRole__c,Manager__c from User where UserRole.Name IN:roleSet';
//null check
  if(strUserName != null && strUserName != '') 
  {      
   String key = '%' + strUserName + '%';
   query += ' AND (Name LIKE :key OR Manager__c LIKE :key)';
  }
  List<User> lstUser = Database.query(query);
  return lstUser;
 }

    }