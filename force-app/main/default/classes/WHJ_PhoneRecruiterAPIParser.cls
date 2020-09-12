public class WHJ_PhoneRecruiterAPIParser {

    public String FirstName;
	public String LastName;
	public String Email;
    public Boolean statusActive;
    public String RecruiterID; 
    public String Mobile;
	
	
        
        public static WHJ_PhoneRecruiterAPIParser parse(String json) {
            return (WHJ_PhoneRecruiterAPIParser) System.JSON.deserialize(json, WHJ_PhoneRecruiterAPIParser.class);
        }
    
}