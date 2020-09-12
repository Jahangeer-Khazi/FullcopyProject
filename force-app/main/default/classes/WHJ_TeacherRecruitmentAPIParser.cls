public class WHJ_TeacherRecruitmentAPIParser {

    public String FirstName;
    public String LastName;
    public String Email;
    public String Mobile;
    public Date DateOfRegistration;
    public String RecruiterID;
    public String TeacherId;
        
        public static WHJ_TeacherRecruitmentAPIParser parse(String json) {
            return (WHJ_TeacherRecruitmentAPIParser) System.JSON.deserialize(json, WHJ_TeacherRecruitmentAPIParser.class);
        }
    
    
}