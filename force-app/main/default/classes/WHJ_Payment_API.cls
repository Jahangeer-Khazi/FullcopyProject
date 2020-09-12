/*White Hat Junior Payment API REST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 16/09/2019
*Purpose: This Apex REST API class is to creates a payment
*for a given Student and Opportunity.
*/ 

@RestResource(urlMapping='/Payment')
global class WHJ_Payment_API {
    
    @HttpPost
    global static Void createPayment() 
    {
        String email = '';
        String reqBody = '';
        try{
            RestRequest request = RestContext.request;
            reqBody = request.requestBody.toString(); 
            system.debug('createPayment  :: '+ reqBody);
            ParentRecord parent = new ParentRecord();
            parent.success = true;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
            
            
            
            Type resultType = Type.forName('WHJ_PaymentParser');
            WHJ_PaymentParser readValueAsResults = (WHJ_PaymentParser)JSON.createParser(reqBody).readValueAs(resultType);
            System.debug('==========> createParser().readValueAs() results = ' + readValueAsResults);
            email = readValueAsResults.email;
            //Select the student record for the email address in the request
            List<Account> lstAccount = [SELECT Id,Name,PersonEmail FROM Account WHERE PersonEmail =: readValueAsResults.email];
            
            if(!lstAccount.isEmpty()){//If Account found, create payment
                //Select the opportunity record for the email address in the request
                List<Opportunity> lstOpportunity = [SELECT Id,Name,StageName,Owner.IsActive,OwnerId FROM Opportunity where Type != 'Referral' AND AccountId =: lstAccount[0].Id  ORDER BY CreatedDate DESC NULLS FIRST limit 1 ];
                
                If(lstOpportunity.size() > 0 &&  lstOpportunity[0].Owner.isActive != true) {
                    if(readValueAsResults.leadby != null) {      
                        List<User> LstUser = [SELECT Id,Email,isactive FROM User where isactive = true AND Email =: readValueAsResults.leadby];
                        if(!LstUser.isEmpty()) {
                            lstOpportunity[0].OwnerId = LstUser[0].id;
                            update lstOpportunity[0];
                        }
                    }
                }
                
                if(!lstOpportunity.isEmpty()){
                    Payment__c payment = new Payment__c();
                    payment.Account__c =   lstAccount[0].Id;
                    payment.Name = readValueAsResults.paymentId;
                    payment.Payment_Type__c = readValueAsResults.type;
                    System.debug(readValueAsResults.type);
                    payment.Amount__c = readValueAsResults.amount;
                    payment.Credits__c = readValueAsResults.credits;
                    payment.Discount__c = readValueAsResults.discount;
                    payment.Payment_Gateway_Name__c = readValueAsResults.paymentgatewayname;
                    payment.Date__c = readValueAsResults.paymentdate;
                    payment.Package_Name__c = readValueAsResults.packagename;
                    payment.EMI__c = readValueAsResults.emi;
                    payment.Opportunity__c = lstOpportunity[0].Id;
                    payment.Link_By__c = readValueAsResults.leadby;
                    payment.ItemType__c = readValueAsResults.itemtype;   
                    insert payment; 
                    
                    System.debug(payment);
                }else{
                    /*
                    List<Configuration__mdt> config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'SalesHeadRoleId'];
                    
                    List<User> usr = new List<User>();
                    if(!config.isEmpty()){   
                        
                        //Query available users who have Role as SalesHeadRole and ascending order of last assignment
                        usr = [SELECT Id, Name, Sales_Region__c FROM User where 
                               UserRoleId =: config[0].Value__c 
                               AND isactive = true] ; 
                        
                    }     
                    
                    Opportunity oppo = new Opportunity();
                    if(!usr.isEmpty())
                    {
                        oppo.OwnerId = usr[0].Id;
                    }*/               
                    Opportunity oppo = new Opportunity();
                    oppo.OwnerId = System.Label.DefaultOwnerIdForDirectPayment;
                    oppo.Name = lstAccount[0].Name;
                    oppo.AccountId = lstAccount[0].Id;
                    oppo.StageName = 'WON - PAYMENT RECEIVED';
                    oppo.CloseDate = System.today() + 7;
                    oppo.Do_Not_Assign__c = true ;
                    insert oppo;
                    
                    Payment__c payment = new Payment__c();
                    payment.Account__c =  lstAccount[0].Id;
                    payment.Name = readValueAsResults.paymentId;
                    payment.Payment_Type__c = readValueAsResults.type;
                    System.debug(readValueAsResults.type);
                    payment.Amount__c = readValueAsResults.amount;
                    payment.Credits__c = readValueAsResults.credits;
                    payment.Discount__c = readValueAsResults.discount;
                    payment.Payment_Gateway_Name__c = readValueAsResults.paymentgatewayname;
                    payment.Date__c = readValueAsResults.paymentdate;
                    payment.Package_Name__c = readValueAsResults.packagename;
                    payment.EMI__c = readValueAsResults.emi;
                    payment.Opportunity__c = oppo.Id;
                    payment.Link_By__c = readValueAsResults.leadby;
                    payment.ItemType__c = readValueAsResults.itemtype; 
                    insert payment; 
                }           
                
            }else{
                Account account = new Account();
                account.LastName = 'NA';
                account.PersonEmail = readValueAsResults.email;
                insert account;
                /*
                List<Configuration__mdt> config = [SELECT Id, Name__c,Value__c FROM Configuration__mdt WHERE Name__c = 'SalesHeadRoleId'];
                
                List<User> usr = new List<User>();
                if(!config.isEmpty()){   
                    
                    //Query available users who have Role as SalesHeadRole and ascending order of last assignment
                    usr = [SELECT Id, Name, Sales_Region__c FROM User where 
                           UserRoleId =: config[0].Value__c 
                           AND isactive = true] ; 
                    
                }     
                
                Opportunity oppo = new Opportunity();
                if(!usr.isEmpty())
                {
                    oppo.OwnerId = usr[0].Id;
                }*/
                Opportunity oppo = new Opportunity();
                oppo.OwnerId = System.Label.DefaultOwnerIdForDirectPayment;         
                oppo.Name = readValueAsResults.email;
                oppo.AccountId = account.Id;
                oppo.StageName = 'WON - PAYMENT RECEIVED';
                oppo.CloseDate = System.today() + 7;
                oppo.Do_Not_Assign__c = true ;
                
                insert oppo;
                System.debug('oppoId'+oppo.Id);
                
                Payment__c payment = new Payment__c();
                payment.Account__c =  account.Id;
                payment.Name = readValueAsResults.paymentId;
                
                payment.Payment_Type__c = readValueAsResults.type;
                System.debug(readValueAsResults.type);
                payment.Amount__c = readValueAsResults.amount;
                payment.Credits__c = readValueAsResults.credits;
                payment.Discount__c = readValueAsResults.discount;
                payment.Payment_Gateway_Name__c = readValueAsResults.paymentgatewayname;
                payment.Date__c = readValueAsResults.paymentdate;
                payment.Package_Name__c = readValueAsResults.packagename;
                payment.EMI__c = readValueAsResults.emi;
                payment.Opportunity__c = oppo.Id;
                payment.Link_By__c = readValueAsResults.leadby;
                payment.ItemType__c = readValueAsResults.itemtype; 
                insert payment; 
                
            }
            
            
        }catch(Exception e){//Exception
            system.debug('##########Error'+e);
            RestContext.response.statusCode = 400;
            ParentRecord parent = new ParentRecord();
            parent.success = false;
            parent.error.add(new ChildRecord( '400', 'BAD_REQUEST :'+e.getMessage()));    
            String compName = 'WHJ_Payment_API';
            String compType = 'REST API Class';
            String recRef = email;
            String err = e.getMessage()  + e.getStackTraceString();    
            String req = reqBody;    
            
            WHJ_ErrorLogHandler.log(compName, compType, err, 400,recRef,req);        
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
            
        }
        //return  'Success';  
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
        // public String error;
        // public Boolean success;
        public String error_Code, error_message;
        public ChildRecord( String errorCode, string message) {
            // this.error = error;
            this.error_Code = errorCode;
            this.error_message = message;
        }
    }
    
    
}