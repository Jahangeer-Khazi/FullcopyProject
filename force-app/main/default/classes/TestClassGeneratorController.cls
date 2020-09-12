public class TestClassGeneratorController {
    
    public static String JSONRresponse = '{"Methods": [{"IsStatic": true, "AccessModifier": "public", "ReturnType": "String", "Name": "getLoggedInUserTimeZone", "Params": null}, {"IsStatic": false, "AccessModifier": "static", "ReturnType": "String", "Name": "testApexMethodIntegerPrm", "Params": [{"Type": "Integer", "Name": "int_input"}, {"Type": "String", "Name": "str_input"}, {"Type": "Date", "Name": "date_input"}, {"Type": "DateTime", "Name": "dateTime_input"}, {"Type": "customObj__c", "Name": "cstm"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "List<Account>", "Name": "getAllAccounts", "Params": [{"Type": "String", "Name": "searchText"}, {"Type": "String", "Name": "selectedType"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "List<Schema>", "Name": "getGrades", "Params": []}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "List<User>", "Name": "getUsersFromDb", "Params": []}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "List<RESurvey__c>", "Name": "getAllSurveys", "Params": []}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "List<Visits__c>", "Name": "getEvents", "Params": [{"Type": "String", "Name": "selectedUser"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "List<Visits__c>", "Name": "getEventsForLoggedInUser", "Params": [{"Type": "String", "Name": "selectedUser"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "Visits__c", "Name": "getNewEvent", "Params": [{"Type": "String", "Name": "selectedUser"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "Visits__c<String>", "Name": "saveNewEventWithSurveys", "Params": [{"Type": "String", "Name": "ownerId"}, {"Type": "String", "Name": "subject"}, {"Type": "String", "Name": "startDateTime"}, {"Type": "String", "Name": "endDateTime"}, {"Type": "String", "Name": "accountId"}, {"Type": "String", "Name": "selectedSurveys"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "Visits__c", "Name": "saveNewEvent", "Params": [{"Type": "String", "Name": "ownerId"}, {"Type": "String", "Name": "accountId"}, {"Type": "String", "Name": "subject"}, {"Type": "String", "Name": "startDateTime"}, {"Type": "String", "Name": "endDateTime"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "Visits__c", "Name": "updateEvent", "Params": [{"Type": "String", "Name": "eventId"}, {"Type": "String", "Name": "startDateTime"}, {"Type": "String", "Name": "endDateTime"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "Visits__c<Visits__c>", "Name": "updateOlderEvent", "Params": [{"Type": "String", "Name": "eventId"}, {"Type": "String", "Name": "subject"}, {"Type": "String", "Name": "startDateTime"}, {"Type": "String", "Name": "endDateTime"}, {"Type": "String", "Name": "selectedSurveys"}, {"Type": "String", "Name": "allEvents"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "void", "Name": "deleteEvent", "Params": [{"Type": "String", "Name": "eventId"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "void", "Name": "unsuppEx", "Params": [{"Type": "Contact", "Name": "con"}, {"Type": "Account", "Name": "acc"}, {"Type": "String", "Name": "name"}]}, {"IsStatic": true, "AccessModifier": "public", "ReturnType": "void<Contact>", "Name": "unsupMethod", "Params": [{"Type": "List<Contact>", "Name": "contactListMap"}]}]}';
    @AuraEnabled
    public static List<ApexClass> getApexClassDetails()
    {
        List<ApexClass> apexClassList = [SELECT Id, Name,  Status, IsValid, Body, LengthWithoutComments FROM ApexClass ];
        List<ApexClass> filteredClassList = new List<ApexClass>();
        if(apexClassList.size() > 0) {
            for (ApexClass apxCls : apexClassList) {
                if(! apxCls.Body.startsWith('@isTest') && apxCls.Body!='(hidden)') {
                    filteredClassList.add(apxCls);
                }
            }
        }
        return filteredClassList;
    }
    
    @AuraEnabled
    public static ReturnWrapper generateTestClass(string classBody, string className) 
    {
        string methodJson;
        methodJson = TestClassGeneratorController.callParser(className,classBody);
        system.debug(methodJson);
        string testClass = '@isTest \n';
        testClass += 'private class '+ className + 'Test {\n'+'\t';
        ReturnWrapper wrapObj = new ReturnWrapper();
        wrapObj = TestClassGeneratorController.createTestMethods(methodJson,testClass,className);
        system.debug(wrapObj);
        system.debug(wrapObj.tstClass);
        system.debug(wrapObj.apexMethodList);
        return wrapObj;
    }
    public static ReturnWrapper createTestMethods(string methodJson,string testClass,string className) {
		System.debug('Copy Content from Here');
        system.debug(methodJson);
        System.debug(testClass);
        System.debug(className);
        List<String> suggestions = new List<String>();
        JSONParser parser = JSON.createParser(methodJson);
        system.debug(parser);
        List<ApexMethod> mthdLst = new List<ApexMethod>();
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        ApexMethod methd = (ApexMethod)parser.readValueAs(ApexMethod.class);
                        mthdLst.add(methd);
                        string s = JSON.serialize(methd);
                        parser.skipChildren();
                    }
                }
            }
        }
        system.debug(mthdLst);
        if(mthdLst.size()>0) {
            for (ApexMethod mthd : mthdLst ) {
                mthd.isMethodSupported = true ;
            }
            for (ApexMethod mthd : mthdLst ) {
                if(mthd.params != null) {
                    for (Param prm : mthd.params) {
                        if(!Label.PrimitiveDataType.containsIgnoreCase(prm.type) && !prm.type.contains('List') && !prm.type.contains('Map')) {
                            System.debug(prm.type);
                            TestClassGeneratorUtility.RequiredFieldWrapper rw = TestClassGeneratorUtility.getAllRequiredFields(prm.type);
                            if(rw!=null){
                                if(rw.isSupportable == false)
                                {
                                    mthd.isMethodSupported = false ; 
                                    break;
                                }
                            }
                        }
                        if(prm.type.contains('List<')) {
                            List<String> tempLst = prm.type.split('<');
                            String lstObj = tempLst[tempLst.size()-1];
                            lstObj = lstObj.left(lstObj.length()-1);
                            system.debug(lstObj);
                            if(!Label.PrimitiveDataType.containsIgnoreCase(lstObj)) {
                                TestClassGeneratorUtility.RequiredFieldWrapper rw = TestClassGeneratorUtility.getAllRequiredFields(lstObj);
                                if(rw!=null){
                                    if(rw.isSupportable == false)
                                    {
                                        mthd.isMethodSupported = false ; 
                                        break;
                                    }
                                }
                            }
                        }
                       
                    }
                }
                system.debug(mthd.isMethodSupported);
                if( mthd.isMethodSupported ) {
                    
                    testClass += '\n@isTest static void ' + mthd.name+ +'Test() {\n';
                    if( mthd.isStatic ) {
                        testClass += '\n\t'+className + '.'+mthd.name + '( ';
                    }
                    else {
                        testClass += '\n\t'+'New '+className + '().'+mthd.name + '( ';
                    }
                    if(mthd.params != null) {
                        if(mthd.params.size()>0) {
                            for(Param prm : mthd.params) {
                                if (prm.type.contains('List<')) {
                                    List<String> tempLst = prm.type.split('<');
                                    String lstObj = tempLst[tempLst.size()-1];
                                    lstObj = lstObj.left(lstObj.length()-1);
                                    system.debug(lstObj);
                                    if(!Label.PrimitiveDataType.containsIgnoreCase(lstObj.toLowerCase())) {
                                        testClass = TestClassGeneratorController.createObjinTestMethod(testClass,lstObj,prm.name,3);
                                    }
                                    else {
                                        testClass = TestClassGeneratorController.createPrimitiveTypeListinTestMethod(testClass,lstObj,prm.name,3);
                                        /*if(lstObj == 'String') {
                                            testClass += '\''+prm.name+'\' ,' ;
                                        }
                                        else if(lstObj == 'Integer') {
                                            testClass += '10 ,' ;
                                        }
                                        else if(lstObj == 'Date') {
                                            testClass += 'Date.today() ,' ;
                                        }
                                        else if(lstObj == 'DateTime') {
                                            testClass += 'Datetime.newInstanceGmt(2020,6,1,12,1,5) ,' ;
                                        }
                                        else if(lstObj == 'Boolean') {
                                            testClass += 'True ,' ;
                                        }
                                        else if(lstObj == 'Double') {
                                            testClass += '10.5 ,' ;
                                        }
                                        else if(lstObj == 'Decimal') {
                                            testClass += '10.5 ,' ;
                                        }
                                        else if(lstObj == 'Time') {
                                            testClass += 'Time.newInstance(1, 2, 3, 4) ,' ;
                                        }*/
                                    }
                                }
                                else if(prm.type == 'String') {
                                    testClass += '\''+prm.name+'\' ,' ;
                                }
                                else if(prm.type == 'Integer') {
                                    testClass += '10 ,' ;
                                }
                                else if(prm.type == 'Date') {
                                    testClass += 'Date.today() ,' ;
                                }
                                else if(prm.type == 'DateTime') {
                                    testClass += 'Datetime.newInstanceGmt(2020,6,1,12,1,5) ,' ;
                                }
                                else if(prm.type == 'Boolean') {
                                    testClass += 'True ,' ;
                                }
                                else if(prm.type == 'Double') {
                                    testClass += '10.5 ,' ;
                                }
                                else if(prm.type == 'Decimal') {
                                    testClass += '10.5 ,' ;
                                }
                                else if(prm.type == 'Time') {
                                    testClass += 'Time.newInstance(1, 2, 3, 4) ,' ;
                                }
                                else if(!prm.type.contains('List<')) { 
                                    testClass = TestClassGeneratorController.createObjinTestMethod(testClass,prm.type,prm.name,null);
                                    system.debug(testClass);
                                }
                                else if (prm.type.contains('List<')) {
                                    List<String> tempLst = prm.type.split('<');
                                    String lstObj = tempLst[tempLst.size()-1];
                                    lstObj = lstObj.left(lstObj.length()-1);
                                    system.debug(lstObj);
                                    testClass = TestClassGeneratorController.createObjinTestMethod(testClass,lstObj,prm.name,3);
                                }
                                /* Suggestions */
                                if(prm.type == 'String'&& prm.Name.endsWithIgnoreCase('Id')) {
                                    String Message = 'Parameter  "'+prm.Name+'" of Method "'+mthd.Name+'" looks to be of type Id. Since the data type is string it can be a case of confilct, Please review it';
                                    suggestions.add(Message);
                                }
                                else if(prm.type == 'String'&& prm.Name.endsWithIgnoreCase('DateTime')) {
                                    String Message = 'Parameter  "'+prm.Name+'" of Method "'+mthd.Name+'" looks to be of type DateTime. Since the data type is string it can be a case of confilct, Please review it';
                                    suggestions.add(Message);
                                }
                                else if(prm.type == 'String'&& prm.Name.endsWithIgnoreCase('Date')) {
                                    String Message = 'Parameter  "'+prm.Name+'" of Method "'+mthd.Name+'" looks to be of type Date. Since the data type is string it can be a case of confilct, Please review it';
                                    suggestions.add(Message);
                                }
                            }
                        }
                        testClass = testClass.left(testClass.length()-1);
                    }
                    testClass += '); \n}\n';
                }
            }
        }
        testClass += '\n}';
        ReturnWrapper wrapObj = new ReturnWrapper();
        wrapObj.tstClass = testClass;
        wrapObj.suggestions = suggestions;
        System.debug(mthdLst);
        wrapObj.apexMethodList = mthdLst;
        System.debug(wrapObj);
        System.debug(wrapObj.tstClass.split('\n').size());
        return wrapObj;
    }
    public static String createPrimitiveTypeListinTestMethod(String testClass, String prmtype,String prmname,integer size) {
        List<String> parts = testclass.split('\\{');
        system.debug(parts);
        system.debug(parts[parts.size()-1]);
        string temp =  parts[parts.size()-1];
        parts[parts.size()-1] = '';
        parts[parts.size()-1] +='\t'+'List<'+prmtype+'> '+prmname+' = new List<'+prmtype+'> ();\n';
        for(integer i =0;i<size;i++) {
            if(prmtype == 'String') {
                parts[parts.size()-1] += '\t'+prmname+'.add(\'stringObj\');\n';
            }
            else if(prmtype == 'Integer') {
                parts[parts.size()-1] += '\t'+prmname+'.add(10);\n';
            }
            else if(prmtype == 'Date') {
                parts[parts.size()-1] += '\t'+prmname+'.add(Date.today() );\n';
            }
            else if(prmtype == 'DateTime') {
                parts[parts.size()-1] += '\t'+prmname+'.add(Datetime.newInstanceGmt(2020,6,1,12,1,5));\n';
            }
            else if(prmtype == 'Boolean') {
                parts[parts.size()-1] += '\t'+prmname+'.add(True);\n';
            }
            else if(prmtype == 'Double') {
                parts[parts.size()-1] += '\t'+prmname+'.add(10.5);\n';
            }
            else if(prmtype == 'Decimal') {
                parts[parts.size()-1] += '\t'+prmname+'.add(10.5);\n';
            }
            else if(prmtype == 'Time') {
                parts[parts.size()-1] += '\t'+prmname+'.add(Time.newInstance(1, 2, 3, 4) );\n';
            }
            
        }
        parts[parts.size()-1] +='\n'+ temp +' '+prmname+',';
        testclass = String.join(parts, '{\n');
        system.debug(testclass);
        return testclass;
    }
    public static String createObjinTestMethod(String testClass, String prmtype,String prmname,integer size) {
        TestClassGeneratorUtility.RequiredFieldWrapper rw = TestClassGeneratorUtility.getAllRequiredFields(prmtype);
        String fieldSet='';
        if(rw!=null)
        {
            List<TestClassGeneratorUtility.ObjField> requiredFieldList = rw.reqFieldList;
            
            for(TestClassGeneratorUtility.ObjField fieldName : requiredFieldList) {
                if(fieldName.DataType == 'String') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ '\''+fieldName.FieldAPIName+'\' ,';
                }
                if(fieldName.DataType == 'Integer') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ '10 ,';
                }
                if(fieldName.DataType == 'Boolean') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ 'True ,';
                }
                if(fieldName.DataType == 'Date') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ 'Date.today()  ,';
                }
                if(fieldName.DataType == 'DateTime') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ 'Datetime.newInstanceGmt(2020,6,1,12,1,5) ,';
                }
                if(fieldName.DataType == 'Double') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ '10.5 ,';
                }
                if(fieldName.DataType == 'Time') {
                    fieldSet += fieldName.FieldAPIName + ' = '+ 'Time.newInstance(1, 2, 3, 4), ';
                }
            }
        } 
        fieldSet = fieldSet.left(fieldSet.length()-1);
        system.debug(fieldSet);
        List<String> parts = testclass.split('\\{');
        system.debug(parts);
        system.debug(parts[parts.size()-1]);
        if(size == null) {
            parts[parts.size()-1] = '\t\n'+prmtype+' '+prmname+' = new '+prmtype+' ( '+fieldSet+' );\n\tInsert '+prmname+';\n'+parts[parts.size()-1] +' '+prmname+',' ;
            system.debug(parts[parts.size()-1]);
            testclass = String.join(parts, '{');
            system.debug(testclass);
        }
        else if (size != null) {
            string temp =  parts[parts.size()-1];
            parts[parts.size()-1] = '';
            for(integer i =0;i<size;i++) {
                parts[parts.size()-1] += '\t'+prmtype+' '+prmname+'obj'+i+' = new '+prmtype+' ( '+fieldSet+' );\n\t Insert '+prmname+'obj'+i+';\n';
            }
            parts[parts.size()-1] +='\t'+'List<'+prmtype+'> '+prmname+' = new List<'+prmtype+'> ();\n';
            for(integer i =0;i<size;i++) {
                parts[parts.size()-1] += '\t'+prmname+'.add('+prmname+'obj'+i+');\n';
            }
            parts[parts.size()-1] +='\n'+ temp +' '+prmname+',';
            testclass = String.join(parts, '{\n');
            system.debug(testclass);
        }
        return testClass;
    }
    public static string callParser(string testClassName , string testClassBody) {
        HttpRequest createReq = new HttpRequest();
        createReq.setEndpoint('https://apexparser.aethereus.ml/parseapex');
        createReq.setBody( testClassBody );
        createReq.setHeader('Content-Type', 'text/plain');
        createReq.setMethod('POST');
        Http h = new Http(); 
        system.debug(createReq);
        HttpResponse createRes = h.send(createReq);
        system.debug(createRes);
        system.debug(createRes.getBody());
        return createRes.getBody();
    }
    public class ApexMethod {
        @AuraEnabled public string name;
        @AuraEnabled public string returnType;
        @AuraEnabled public string accessModifier;
        @AuraEnabled public Boolean isMethodSupported;
        @AuraEnabled public Boolean isStatic;
        @AuraEnabled public List<Param> params;
        
        public ApexMethod(string name, string returnType,string accessModifier, Boolean isStatic, List<Param> params) {
            name = name;
            returnType = returnType;
            accessModifier = accessModifier;
            isMethodSupported = true;
            isStatic = isStatic;
            params = params.clone();
        }
    }  
    public class Param {
        @AuraEnabled  public string type;
        @AuraEnabled  public string name;
    }
    public class ReturnWrapper {
        @AuraEnabled public string tstClass;
        @AuraEnabled public List<String> suggestions; 
        @AuraEnabled public List<ApexMethod> apexMethodList;
    }
}