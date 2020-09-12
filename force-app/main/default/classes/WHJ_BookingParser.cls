/*White Hat Junior Booking API Parser Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 16/09/2019
 *Purpose: This Apex class is to Parse Data for WHJ_Booking_API class.
 */ 


public class WHJ_BookingParser {

    public String email {get;set;} 
    public String bookingId {get;set;} 
    //public String classNumberText {get;set;} 
    public String classNumber {get;set;} 
    public Boolean isTrial {get;set;} 
    public String teacherName {get;set;} 
    public String teacherEmail {get;set;} 
    public String teacherPhone {get;set;} 
    public String teacherComment {get;set;} 
    public String rating {get;set;} 
    public Date classdate {get;set;} 
    public Time scheduledClassStartTime {get;set;} 
    public Time actualClassStartTime {get;set;} 
    public String timezone {get;set;}
    public String CourseVersion {get;set;}
	public String StudentFeedbackCategory {get;set;}
    public String StudentFeedbackComments {get;set;}   
    public String StudentFeedbackRating {get;set;}   
        
    public WHJ_BookingParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'email') {
                        email = parser.getText();
                    } else if (text == 'bookingId') {
                        bookingId = parser.getText();
                    }  else if (text == 'classNumber') {
                        classNumber = parser.getText();
                    } else if (text == 'isTrial') {
                        isTrial = parser.getBooleanValue();
                    } else if (text == 'teacherName') {
                        teacherName = parser.getText();
                    } else if (text == 'teacherComment') {
                        teacherComment = parser.getText();
                    } else if (text == 'teacherEmail') {
                        teacherEmail = parser.getText();
                    } else if (text == 'teacherPhone') {
                        teacherPhone = parser.getText();
                    } else if (text == 'rating') {
                        rating = parser.getText();
                    } else if (text == 'classdate') {
                        classdate = parser.getDateValue();
                    } else if (text == 'scheduledClassStartTime') {
                        scheduledClassStartTime = parser.getTimeValue();
                    } else if (text == 'actualClassStartTime') {
                        actualClassStartTime = parser.getTimeValue();
                    } else if (text == 'timezone') {
						timezone = parser.getText();
                    } else if (text == 'CourseVersion') {
						CourseVersion = parser.getText();
                    } else if (text == 'StudentFeedbackCategory') {
						StudentFeedbackCategory = parser.getText();
                    } else if (text == 'StudentFeedbackComments') {
						StudentFeedbackComments = parser.getText();
                    } else if (text == 'StudentFeedbackRating') {
						StudentFeedbackRating = parser.getText();    
                    }else {
                        System.debug(LoggingLevel.WARN, 'WHJ_BookingParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    public static WHJ_BookingParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new WHJ_BookingParser(parser);
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