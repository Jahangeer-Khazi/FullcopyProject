public class WHJ_AccountController {
    
    
    public static void onStudentActive(List<Account> accList,Map<Id, Account> mapAccOld) {
        
        Set<Id> SetOfAccId = new Set<Id>();
        
        
        for(Account acc : accList){
            if(acc.Status__c == 'Active' && (acc.Status__c <> mapAccOld.get(acc.id).Status__c))
            {
                SetOfAccId.add(acc.Id);
            }
        }
        
        List<Account> accountList = [select id,PersonEmail from Account where id in: SetOfAccId]; // account list
        
        
        Map<Id,List<Payment__c>> mp_ListPayment = new Map<Id,List<Payment__c>>();
        if(!accountList.isEmpty())
        {
            for(Payment__c pmt : [Select Id,Account__c,Payment_Type__c,ItemType__c from Payment__c where Account__c IN : accountList ORDER BY CreatedDate DESC])
            {
                if(mp_ListPayment!=null && mp_ListPayment.containsKey(pmt.Account__c))
                {
                    List<Payment__c> pmtList = mp_ListPayment.get(pmt.Account__c);
                    pmtList.add(pmt);
                    mp_ListPayment.put(pmt.Account__c, pmtList);
                }
                else{
                    mp_ListPayment.put(pmt.Account__c, new List<Payment__c>{pmt});
                }
            } 
        }   
        
        
        List<Account> ListUpdateAcc = new List<Account>();
        if(!accList.isEmpty()){
            for(Account acc : accountList)
            {
                if(!mp_ListPayment.isEmpty()){
                    if(mp_ListPayment.get(acc.Id)[0].Payment_Type__c != null)
                    {
                        acc.Activation_Payment__c = mp_ListPayment.get(acc.Id)[0].Payment_Type__c;
                        ListUpdateAcc.add(acc);
                    }        
                }
            }
            update  ListUpdateAcc;
        }
    }
    
    public static void onBatchUpdate(List<Account> lstAccount,Map<Id, Account> lstOldAccount) {
        
        
        
        Set<String> SetofBatchIdsNotNull = new Set<String>(); //set of BatchIds
        Set<Id> setofaccIds = new Set<Id>();			//set of triggering accounts
        Set<String> SetofOldBatchIds = new Set<String>(); //set of triggering account's old batchid
        
        for (Account act1 : lstAccount) {
            if(lstOldAccount.get(act1.id).Batch_Id__c <> act1.Batch_Id__c ) {
                if(act1.Batch_Id__c != null) {
                    SetofBatchIdsNotNull.add(act1.Batch_Id__c);
                }
                setofaccIds.add(act1.id);
                if(lstOldAccount.get(act1.Id).Batch_Id__c != null) {
                    SetofOldBatchIds.add(lstOldAccount.get(act1.Id).Batch_Id__c);
                }
            }
        }
        List<Account> accUpdateList = new List<Account>();
        
        List<Account> listAccTemp =  [SELECT Id,Batch_Id__c,Pair_Found__c FROM Account Where (Batch_Id__c in: SetofOldBatchIds OR Id in: setofaccIds OR Batch_Id__c in: SetofBatchIdsNotNull) ]; //List of accounts having Batch Id same as triggering account's old batch id
        
        List<Account> listAcc1 = new List<Account>();
        List<Account> listAcc2 = new List<Account>();
        List<Account> listAcc3 = new List<Account>();
        
        if(!listAccTemp.isEmpty()) {
            for(Account tempAcc : listAccTemp) {
                if(setofaccIds.contains(tempAcc.id)) {
                    listAcc1.add(tempAcc);
                }
                if(SetofBatchIdsNotNull.contains(tempAcc.Batch_Id__c)) {
                    listAcc2.add(tempAcc); 
                }
                if(SetofOldBatchIds.contains(tempAcc.Batch_Id__c)) {
                    listAcc3.add(tempAcc);
                }
            }
        }
        
        Account temp = new  Account();
        if(!listAcc1.isEmpty())
        {
            for(Account acc1 : listAcc1) {   // loop all triggering accounts
                acc1.Pair_Found__c = false;
                if(acc1.Batch_Id__c == null) {// if updated batch id is null
                    accUpdateList = pairfound(acc1,listAcc3,lstOldAccount);
                    
                }
                else{
                    for(Account acc2 :listAcc2) { // loop accounts having same batch id
                        if( acc1.Batch_Id__c == acc2.Batch_Id__c && acc1.Id != acc2.Id) { //if batch id is same 
                            if(lstOldAccount.get(acc1.Id).Pair_Found__c == true) { //if already in pair
                                accUpdateList = pairfound(acc1,listAcc3,lstOldAccount);
                            }
                            acc1.Pair_Found__c = true;    //mark as paired
                            acc2.Pair_Found__c = true;
                            
                            accUpdateList.add(acc2);
                            break;
                        }
                        else
                            continue;
                    }
                }
                accUpdateList.add(acc1);
            }
            update accUpdateList;
        }   
    }
    
    public static List<Account> pairfound (Account acc1 ,List<Account> listAcc3, Map<Id, Account> lstOldAccount){
        List<Account> accUpdateList = new List<Account>();
        Account temp = new  Account();
        Integer paircount = 0 ;
        for(Account acc3 : listAcc3) { //make paired accounts uncheck
            if(lstOldAccount.get(acc1.id).Batch_Id__c == acc3.Batch_Id__c) {
                paircount++;
                if(paircount == 1){
                    temp = acc3;
                }
            }
            else
                continue;
        }
        if(paircount == 1 ) {
            temp.Pair_Found__c = false; //unpair if count is only 1
            accUpdateList.add(temp);
        }
        return accUpdateList;
    }
}