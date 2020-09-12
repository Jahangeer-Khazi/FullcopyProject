@RestResource(urlMapping='/OpportunityAPI')
global class WHJ_OpportunityAPI {

    @HttpPut
    global static Void UpdateOpportunity() 
    {
        try{
            // RestRequest Method to get JSON Request
            RestRequest request = RestContext.request;
            // Convert JSON data blob to String
            String reqBody = request.requestBody.toString(); 
            system.debug('reqBody  :: '+ reqBody);
            
            
            
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));                
            
            
            WHJ_OpportunityAPIParser parsedData = WHJ_OpportunityAPIParser.parse(reqBody);
            system.debug('parsedData  :: ' + parsedData);
         
          		
            
            system.debug('#1');
            List<Opportunity> Opp = [SELECT Id,Teacher_Comments__c FROM Opportunity WHERE Id =: parsedData.OppId];
            system.debug('#2');
            //check whether Opp exists or not
            if(!Opp.isEmpty()  ){ // if then update
               system.debug('#3');
              
               for(Opportunity oppo : Opp)
               {
                   //oppo.Id = Opp[0].Id;
                //oppo.Id = parsedData.OppId;
                String s =  oppo.Teacher_Comments__c;
                String f= parsedData.TeacherComments;
                oppo.Teacher_Comments__c  = s + ' ' + f;
                
               update oppo;
                  
               }
          
                
            }else  { // throw error
              
					CalloutException e = new CalloutException();
                    e.setMessage(System.Label.OpportunityAPI_Error_Msg);
                    throw e;
                  // throw new IllegalArgumentException('Oppotunity Id does not exist');

            }
            
            
        }catch(Exception e){
            
            System.debug('Exception::'+e);
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
            
            
            
        }
    }
    public class ParentRecord {
        public Boolean success;
        public ChildRecord[] error;
        public ParentRecord() {
            this.success = success;
            error = new ChildRecord[0];
        }
    }
    
    public class ChildRecord {
        public String error_Code, error_message;
        public ChildRecord( String errorCode, string message) {
            this.error_Code = errorCode;
            this.error_message = message;
        }
    }

    
    
}