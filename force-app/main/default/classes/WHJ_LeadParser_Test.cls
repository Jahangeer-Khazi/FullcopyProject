/*White Hat Junior Lead API TEST Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 25/09/2019
 *Purpose: This Test class is to test Data for WHJ_LeadParser class.
 */ 


@IsTest
public class WHJ_LeadParser_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '        \"primaryemail\": \"harsh@gmail.com\",'+
        '   \"alternateemail\": \"harsh@gmail.com\",'+
        '        \"firstname\": \"Harsh\",'+
        '        \"lastname\": \"Gughane\",'+
        '        \"street\": \"test\",'+
        '        \"city\":\"Pune\",'+
        '        \"state\": \"Maharashtra\",'+
        '        \"country\": \"India\",'+
        '        \"status\": \"2\", '+
        '        \"mobile\": \"9898989898\",'+
        '        \"credit\": \"123\",'+
        '        \"gender\": \"Male\",'+
        '        \"parentname\": \"abc\",'+
        '        \"registereddate\":\"2018-07-25\",'+
        '        \"grade\": \"1st\",'+
        '        \"timezone\": \"10:00\",'+
        '   \"id\" : \"12\",'+
        '   \"studentid\" : \"test\",'+
        '   \"campaignsource\" : \"test\",'+
        '   \"campaignmedium\" : \"test\",'+
        '   \"campaignname\" : \"test\",'+
        '   \"campaigncontent\" : \"test\",'+
        '   \"campaignterm\" : \"test\",'+
        '   \"campaigncreative\" : \"test\",'+
        '   \"language\" : \"Eng\",'+
        '   \"page\" : \"2\",'+
        '   \"campaignid\" : \"11\",'+
        '   \"adsetid\" : \"10\",'+
        '   \"adid\" : \"02\",'+
        '   \"affiliatename\" : \"test\",'+
        '   \"listname\" : \"test\",'+
        '   \"location\" : \"pune\",'+
        '   \"matchtype\" : \"test\",'+
        '   \"device\" : \"test\",'+
        '   \"reftype\" : \"test\"'+
        '        '+
        '}';
        WHJ_LeadParser obj = WHJ_LeadParser.parse(json);
        System.assert(obj != null);
    }
}