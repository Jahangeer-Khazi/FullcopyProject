/*
 * Created by     : Jahangeer Khazi.
 * Created Date   : 23/08/2020
 * Class Name     : WHJ_Bulk_OwnerIdUpdate
 * Test Class     : 
 * Test Coverage  : 
 * Change History : This class is used for testing purpose to change the Student ownerids in Bulk.
 *           
*/
global class WHJ_Bulk_OwnerIdUpdate implements Database.batchable<sObject>,Database.stateful {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id from Account where Id IN('0011y000007YjRjAAK','0011y0000085nAKAAY')]);
    }
    global void execute(Database.BatchableContext BC, List<Account> acc){
        System.debug('Student Size:'+acc.size());
        List<Account> accList = new List<Account>();
        for(Account a:acc){
            a.OwnerId = '0051y0000013i3qAAA';
            accList.add(a);

        }
        if(accList.size()>0)
            update accList;
    }
    global void finish(Database.BatchableContext BC){
        
    }

}