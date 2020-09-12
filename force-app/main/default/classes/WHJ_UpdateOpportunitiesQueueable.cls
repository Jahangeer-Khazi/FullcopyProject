public class WHJ_UpdateOpportunitiesQueueable implements Queueable{
     List<Opportunity> opps = new List<Opportunity>();
    List<User> users = new List<User>();
    List<Account> accounts = new List<Account>();
    public WHJ_UpdateOpportunitiesQueueable(List<Opportunity> passedOpps, List<User> passedUsers, List<Account> passedAcccounts)
    {
       	opps = passedOpps;
		users = passedUsers;
        accounts = passedAcccounts;
        
        system.debug('opps >> '  + opps);
        system.debug('users >> ' + users);
        system.debug('accounts >> ' + accounts);
    }
    
    public void execute(QueueableContext context) {
        if(!opps.isEmpty()) {
            system.debug('updating opps');
            update opps;
        }
        if(!users.isEmpty()) {
            system.debug('updating users');
            update users;
        }
        if(!accounts.isEmpty()) {
            system.debug('updating accounts');
            update accounts;
        }
    }

}