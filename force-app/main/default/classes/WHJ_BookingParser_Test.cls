/*White Hat Junior Booking Parser TEST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 16/09/2019
*Purpose: This Test class is to test Data for WHJ_BookingParser class.
*/ 

@IsTest
public class WHJ_BookingParser_Test {
    
    static testMethod void testParse() {
        String json = '{'+
            '        \"email\": \"harsh@gmail.com\",'+
            '   \"bookingId\": \"B-11\",'+
            '        \"classNumber\": 12,'+
            '        \"isTrial\": true,'+
            '        \"teacherName\": \"test\",'+
            '        \"teacherComment\":\"test\",'+
            '        \"rating\": \"5\",'+
            '        \"classdate\": \"2018-07-25\",'+
            '        \"scheduledClassStartTime\": \"10:00\", '+
            '        \"actualClassStartTime\": \"10:30\",        '+
            '		 \"timezone\": \"IST\",'+
            ' \"CourseVersion\": \"test\" ,' +
            ' \"StudentFeedbackCategory\": \"Audio\", '+
            ' \"StudentFeedbackComments\": \"test\" ,'+
            ' \"StudentFeedbackRating\": \"1\" '+
            
            '}';
        WHJ_BookingParser r = WHJ_BookingParser.parse(json);
        System.assert(r != null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WHJ_BookingParser objWHJ_BookingParser = new WHJ_BookingParser(System.JSON.createParser(json));
        System.assert(objWHJ_BookingParser != null);
        System.assert(objWHJ_BookingParser.email == null);
        System.assert(objWHJ_BookingParser.bookingId == null);
        System.assert(objWHJ_BookingParser.classNumber == null);
        System.assert(objWHJ_BookingParser.isTrial == null);
        System.assert(objWHJ_BookingParser.teacherName == null);
        System.assert(objWHJ_BookingParser.teacherComment == null);
        System.assert(objWHJ_BookingParser.rating == null);
        System.assert(objWHJ_BookingParser.classdate == null);
        System.assert(objWHJ_BookingParser.scheduledClassStartTime == null);
        System.assert(objWHJ_BookingParser.actualClassStartTime == null);
        System.assert(objWHJ_BookingParser.timezone == null);
        System.assert(objWHJ_BookingParser.CourseVersion == null);
        System.assert(objWHJ_BookingParser.StudentFeedbackCategory == null);
        System.assert(objWHJ_BookingParser.StudentFeedbackComments == null);
        System.assert(objWHJ_BookingParser.StudentFeedbackRating == null);
    }
}