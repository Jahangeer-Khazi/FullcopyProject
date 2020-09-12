/*White Hat Junior Task API Parser Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 19/09/2019
 *Purpose: This Apex class is to Parse Data for WHJ_Task_API class.
 */ 


public class WHJ_TaskParser {

    	public String Subject {get;set;} 
	public String AssignedTo {get;set;} 
	public String Priority {get;set;} 
	public String Status {get;set;} 
	public Date DueDate {get;set;} 
	public String Type {get;set;} // in json: Type
	public String ToAddress {get;set;} 
	public String TextBody {get;set;} 
	public String SubjectForEmailMessage {get;set;} 
	public String HtmlBody {get;set;} 
	public String StatusofEmailMeassage {get;set;} 

	public WHJ_TaskParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Subject') {
						Subject = parser.getText();
					} else if (text == 'AssignedTo') {
						AssignedTo = parser.getText();
					} else if (text == 'Priority') {
						Priority = parser.getText();
					} else if (text == 'Status') {
						Status = parser.getText();
					} else if (text == 'DueDate') {
						DueDate = parser.getDateValue();
					} else if (text == 'Type') {
						Type = parser.getText();
					} else if (text == 'ToAddress') {
						ToAddress = parser.getText();
					} else if (text == 'TextBody') {
						TextBody = parser.getText();
					} else if (text == 'SubjectForEmailMessage') {
						SubjectForEmailMessage = parser.getText();
					} else if (text == 'HtmlBody') {
						HtmlBody = parser.getText();
					} else if (text == 'StatusofEmailMeassage') {
						StatusofEmailMeassage = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'WHJ_TaskParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static WHJ_TaskParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WHJ_TaskParser(parser);
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
	



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
	public String Subject;
	public String AssignedTo;
	public String Priority;
	public String Status;
	public Date DueDate;
    public String Type;
    public String ToAddress;
	public String TextBody;
	public String SubjectForEmailMessage;
	public String HtmlBody;
	public String StatusofEmailMeassage;

	
	public static WHJ_TaskParser parse(String json) {
		return (WHJ_TaskParser) System.JSON.deserialize(json, WHJ_TaskParser.class);
	}*/
}