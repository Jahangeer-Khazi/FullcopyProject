/*White Hat Junior Open_CTI API REST Class 
*Created By: HGUGHANGE
*Release No: 1
*Created Date: 25/09/2019
*Purpose: This Apex REST API class is to provide student's owner mobile number.
*/ 

@RestResource(urlMapping='/Open_CTI/*')
global class WHJ_Open_CTI_API {
    @HttpGet
    global static Void getMobNo() {
        try{
            RestRequest request = RestContext.request;
            String StudentMob = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
            ParentRecord parent = new ParentRecord();
            
            //Select the student record for the mobile number in the request
            List<Account> lstAccount = [SELECT Id ,Name ,PersonMobilePhone, OwnerId From Account where PersonMobilePhone =: StudentMob limit 1];
            //Select the Available User record for call
            if(!lstAccount.isEmpty()){
                
                List<User> user = [Select id, name, UserRoleId, Mobile__c,Call_Availability_Status__c from User where Id =: lstAccount[0].OwnerId ];
              
                if(user[0].Call_Availability_Status__c == 'Available')
                    {
                       parent.PrimaryNo = user[0].Mobile__c;                        
                    }
                    else
                    {
                     	parent.PrimaryNo = null;   
                    }
                    
                    String mob = user[0].Mobile__c;
                    //           List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='SalesRepRole'];
                    List<User> listUser = [SELECT Id, Mobile__c,Name FROM User WHERE Call_Availability_Status__c = 'Available' AND MobilePhone != null AND Id != :user[0].Id AND UserRoleId =: user[0].UserRoleId AND isactive = true];
                    System.debug('listUser::'+listUser);
                    Integer Size = listUser.size();  
                    System.debug('Size::'+Size);   
                    List<String> MobileNumber = new List<String>();   
                    for(Integer i=0;i<5;i++){
                        Integer rand = Math.mod(Math.round(Math.random()*10),Size);
                        System.debug('rand::'+Math.round(Math.random()*10));   
                        String usrMobile = listUser[rand].Mobile__c;
                        MobileNumber.add(usrMobile);
                        listUser.remove(rand);
                        Size--;
                    }
                    //            System.debug('MobileNumber::' + MobileNumber);    
                    //            System.debug('listUser::' + listUser);    
                    parent.OtherNo = MobileNumber; 
                    System.debug('OtherNo::'+parent.OtherNo);
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));    
                              System.debug('parent::' + parent);    
                 
            }else{
                
                List<Configuration__mdt> conlst= [SELECT Id,Name__c,Value__c FROM Configuration__mdt where Name__c ='UnavailableCallRole'];
                List<User> listUserCatch = [SELECT Id, Mobile__c,Name FROM User WHERE Call_Availability_Status__c = 'Available' AND MobilePhone != null AND  UserRoleId =: conlst[0].Value__c  AND isactive = true];
                Integer Size = listUserCatch.size();
                Integer j = null;
                System.debug('Size::'+Size); 
                if(Size > 5)
                {
                    j = 5;
                }
                else
                {
                    j = Size;
                }
                List<String> MobileNumber = new List<String>();   
                for(Integer i=0;i<j;i++){
                    Integer rand = Math.mod(Math.round(Math.random()*10),Size);
                    System.debug('rand::'+Math.round(Math.random()*10));   
                    String usrMobile = listUserCatch[rand].Mobile__c;
                    MobileNumber.add(usrMobile);
                    listUserCatch.remove(rand);
                    Size--;
                }
               // RestContext.response.statusCode = 400;
                //            ParentRecord parent = new ParentRecord();
                parent.OtherNo = MobileNumber;
                //          parent.error = e.getMessage();
                
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));   
                
                
            }
            
            
        }catch(Exception e){
            RestContext.response.statusCode = 400;
                            ParentRecord parent = new ParentRecord();
              //  parent.OtherNo = MobileNumber;
                          parent.error = e.getMessage();
                
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(parent));   
                 }
    }
    
    public class ParentRecord {
        //    public Boolean success;
        public String PrimaryNo;
        public List<String> otherno;
        public String error;
        //    public String Mobile;
        //    public ChildRecord[] OtherNo;
        public ParentRecord() {
            //        this.success = success;
            //       OtherNo = new ChildRecord[0];
        }
    }
    
    public class ChildRecord {
        // public String error;
        // public Boolean success;
        //    public String error_Code, error_message;
        //   public String otherno;
        public ChildRecord( String otherno) {
            // this.error = error;
            //        this.error_Code = errorCode;
            //        this.error_message = message;
            //  		  this.otherno = otherno;	
        }
    }
    
}