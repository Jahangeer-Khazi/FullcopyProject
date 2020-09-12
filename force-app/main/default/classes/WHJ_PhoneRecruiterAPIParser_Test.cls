/*White Hat Junior PhoneRecruiter  API parser TEST Class 
 *Created By: GAUTAM
 *Release No: 1
 *Created Date: 25/06/2020
 *Purpose: This Test class is to test Data for WHJ_PhoneRecruiterAPIParser_Test class.
 */ 

@IsTest
public class WHJ_PhoneRecruiterAPIParser_Test {
    
    
    static testMethod void testParse()
    {
        String json = '{'+
           '		\"FirstName\": \"gautam\",'+
           '		 \"LastName\":\"bohra\",'+
           '		\"Email\":\"bohragautam@gmail.com\",'+
           ' 		\"statusActive\":true,'+
           '		\"RecruiterID\":\"34\",'+
           ' 		\"Mobile\":\"43\"' +
           '        '+
          '}';
        WHJ_PhoneRecruiterAPIParser obj = WHJ_PhoneRecruiterAPIParser.parse(json);
        System.assert(obj != null);
    
    

}
}