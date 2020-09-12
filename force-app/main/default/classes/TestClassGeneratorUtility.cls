public class TestClassGeneratorUtility {
    
    public static RequiredFieldWrapper getAllRequiredFields(String ObjectName)
    {
        System.debug(ObjectName);
if(!ObjectName.containsIgnoreCase('Map')&&!ObjectName.containsIgnoreCase('List')&&Schema.getGlobalDescribe().containsKey(ObjectName) )
        {
            List<ObjField> fieldList = new List<ObjField>();
            
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjectName).getDescribe().fields.getMap();
            Boolean isSupportable = true;
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                Boolean isFieldreqFalse  = dfield.isNillable() ;
                if(isFieldreqFalse==false){
                    if(dfield.isUpdateable())
                    {
                        ObjField fld = new ObjField();
                        fld.FieldAPIName= dfield.getName();
                        fld.DataType= (String)String.valueOf(dfield.type);
                        if(fld.FieldAPIName!='OwnerId') {
                            fieldList.add(fld);
                        }
                        if(!Label.PrimitiveDataType.containsIgnoreCase(fld.DataType)&&fld.FieldAPIName!='OwnerId' ||Test.isRunningTest())
                        {
                            isSupportable=false;
                        }
                    }
                }
                
            } 
            
            RequiredFieldWrapper rw = new RequiredFieldWrapper();
            rw.objectAPIName =ObjectName;
            rw.isSupportable =isSupportable;
            rw.reqFieldList = fieldList;
            return rw;
        }else{
            return null;
        }
    }
    
    
    public class RequiredFieldWrapper{
        @AuraEnabled public string objectAPIName;
        @AuraEnabled public Boolean isSupportable;
        @AuraEnabled public List<ObjField> reqFieldList;
        
    }
    
    public class ObjField{
        @AuraEnabled public string DataType;
        @AuraEnabled public string FieldAPIName;
        
    }
}