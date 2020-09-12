/*White Hat Junior FirstResTime API Parser Class 
 *Created By: HGUGHANGE
 *Release No: 3
 *Created Date: 27/02/2020
 *Purpose: This Apex class is to Parse Data for WHJ_FirstResTime_API class.
 */ 

public class WHJ_FirstResTime_API_Parser {

	public String sessionkey {get;set;} 
	public Datetime firstresponsetime {get;set;} 
	public Double frtduration {get;set;} 

	public WHJ_FirstResTime_API_Parser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'sessionkey') {
						sessionkey = parser.getText();
					} else if (text == 'firstresponsetime') {
						firstresponsetime = parser.getDateTimeValue();
					} else if (text == 'frtduration') {
						frtduration = parser.getDoubleValue();
					} else {
						System.debug(LoggingLevel.WARN, 'WHJ_FirstResTime_API_Parser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static WHJ_FirstResTime_API_Parser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WHJ_FirstResTime_API_Parser(parser);
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
	



}




/*public class WHJ_FirstResTime_API_Parser {

	public String sessionkey {get;set;} 
	public Datetime firstresponsetime {get;set;} 

	public WHJ_FirstResTime_API_Parser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'sessionkey') {
						sessionkey = parser.getText();
					} else if (text == 'firstresponsetime') {
						firstresponsetime = parser.getDateTimeValue();
					} else {
						System.debug(LoggingLevel.WARN, 'WHJ_FirstResTime_API_Parser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static WHJ_FirstResTime_API_Parser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WHJ_FirstResTime_API_Parser(parser);
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
	


}*/