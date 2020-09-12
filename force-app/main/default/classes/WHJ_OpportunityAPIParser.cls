public class WHJ_OpportunityAPIParser {
    
    public String TeacherComments;
	public Id OppId;


        public static WHJ_OpportunityAPIParser parse(String json) {
            return (WHJ_OpportunityAPIParser) System.JSON.deserialize(json, WHJ_OpportunityAPIParser.class);
        }

}