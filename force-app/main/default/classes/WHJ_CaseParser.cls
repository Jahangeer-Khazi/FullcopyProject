public class WHJ_CaseParser{
    public List<Case_Details> lst_caseDetails{get;set;}
    public String ticket_category{get;set;}

     public WHJ_CaseParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'ticket_category') {
                        ticket_category = parser.getText();
                    }  else {
                        System.debug(LoggingLevel.WARN, 'WHJ_PaymentParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    
    public static WHJ_CaseParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new WHJ_CaseParser(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    public class Case_Details{
        public String teacher_email{get;set;}
        public String student_email{get;set;}
        public String issue_type{get;set;}
        public String agent_role{get;set;}
        public String subject{get;set;}
        public String description{get;set;}
        public String parent_case{get;set;}
        public String status{get;set;}
        public String origin{get;set;}
    }
}