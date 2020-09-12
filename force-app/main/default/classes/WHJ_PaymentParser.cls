/*White Hat Junior Payment API Parser Class 
 *Created By: HGUGHANGE
 *Release No: 1
 *Created Date: 16/09/2019
 *Purpose: This Apex class is to Parse Data for WHJ_Payment_API class.
 */ 


public class WHJ_PaymentParser {
    
    public String email {get;set;} 
    public String paymentId {get;set;} 
    public String type {get;set;} 
    public Double amount {get;set;} 
    public String currrency {get;set;} 
    public Double credits {get;set;} 
    public Double discount {get;set;} 
    public String paymentgatewayname {get;set;} 
    public Date paymentdate {get;set;} 
    public String packagename {get;set;} 
    public Boolean emi {get;set;} 
	public String leadby {get;set;}
    public String itemtype {get;set;}
    public WHJ_PaymentParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'email') {
                        email = parser.getText();
                    } else if (text == 'paymentId') {
                        paymentId = parser.getText();
                    } else if (text == 'type') {
                        type = parser.getText();
                    } else if (text == 'amount') {
                        amount = parser.getDoubleValue();
                    } else if (text == 'currrency') {
                        currrency = parser.getText();
                    } else if (text == 'credits') {
                        credits = parser.getDoubleValue();
                    } else if (text == 'discount') {
                        discount = parser.getDoubleValue();
                    } else if (text == 'paymentgatewayname') {
                        paymentgatewayname = parser.getText();
                    } else if (text == 'paymentdate') {
                        paymentdate = parser.getDateValue();
                    } else if (text == 'packagename') {
                        packagename = parser.getText();
                    } else if (text == 'emi') {
                        emi = parser.getBooleanValue(); 
                     } else if (text == 'leadby') {
                        leadby = parser.getText();    
                    } else if (text == 'itemtype') {
                        itemtype = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'WHJ_PaymentParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
       }
    
    
    
    public static WHJ_PaymentParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new WHJ_PaymentParser(parser);
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