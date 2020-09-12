public class FutureMethodUtils {
	
    @future
    public static void updateUser(Id DeactiveOpManagerId)
    {   
        try{
            User u = new User(Id=DeactiveOpManagerId);
            u.isActive=false;
            update u;
            
        } catch (DMLException e) {        
            system.debug('Message:'+e.getMessage());
        }
    }
    
}