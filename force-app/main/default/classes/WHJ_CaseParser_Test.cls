@isTest
public class WHJ_CaseParser_Test {
    static testmethod void testParse(){
        String input_body = '{"ticket_category":"TEACHER_LEAVING","lst_caseDetails" :[{"teacher_email":"Test@abc.com","student_email":"Test","issue_type":"Test","agent_role":"Test","subject":"Test","description":"Test","parent_case":"Test","status":"Test","origin":"Test"}]}';
        Type resultType = Type.forName('WHJ_CaseParser');
        WHJ_CaseParser readValueAsResults = (WHJ_CaseParser)JSON.createParser(input_body).readValueAs(resultType);
        WHJ_CaseParser r = WHJ_CaseParser.parse(input_body);
        System.assert(r != null);
        WHJ_CaseParser objWHJ_CaseParser = new WHJ_CaseParser(System.JSON.createParser(input_body));
        System.assert(objWHJ_CaseParser != null);
        System.assert(readValueAsResults.lst_caseDetails[0].teacher_email != null);
        System.assert(readValueAsResults.lst_caseDetails[0].student_email != null);
        System.assert(readValueAsResults.lst_caseDetails[0].issue_type != null);
        System.assert(readValueAsResults.lst_caseDetails[0].agent_role != null);
        System.assert(readValueAsResults.lst_caseDetails[0].subject != null);
        System.assert(readValueAsResults.lst_caseDetails[0].description != null);
        System.assert(readValueAsResults.lst_caseDetails[0].parent_case != null);
        System.assert(readValueAsResults.lst_caseDetails[0].status != null);
        System.assert(readValueAsResults.lst_caseDetails[0].origin != null);
    }
}