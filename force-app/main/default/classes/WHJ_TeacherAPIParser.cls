public class WHJ_TeacherAPIParser {
    
    public String FirstName;
    public String LastName;
    public String Email;
    public String Mobile;
    public String RMname;
    public String RMemailId;
    public Boolean Status;
    public String Region;
    public String CurriculumLevel;
    public String Language;
    public Date DateOfOnboarding;
    public String InductionOwner;
    
        
        public static WHJ_TeacherAPIParser parse(String json) {
            return (WHJ_TeacherAPIParser) System.JSON.deserialize(json, WHJ_TeacherAPIParser.class);
        }
}