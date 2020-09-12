({
    doInit : function(component, event, helper) {
        var action = component.get("c.getApexClassDetails");
        //   action.setParams({ firstName : component.get("v.firstName") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.listApexClass",response.getReturnValue());
                component.set("v.loaded",true);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    handleClick :  function(component, event, helper) {
        
        component.set("v.loaded",false);
        
                component.set("v.screenName","Methods in Class");
        var selectedClass = component.get("v.selectedClass");	
        var listApexClass = component.get("v.listApexClass");
        var body;
        for(var i=0;i<listApexClass.length;i++)
        {
            if(listApexClass[i].Name==selectedClass)
            {
                body=listApexClass[i].Body;
            }
        }
        console.log(selectedClass);
        var action = component.get("c.generateTestClass");
        action.setParams({ classBody : body,
                          className : selectedClass});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.loaded",true);
                component.set("v.TestClassCode",response.getReturnValue().tstClass);
                  component.set("v.suggestionList",response.getReturnValue().suggestions);
                
                component.set("v.apexMethodList",response.getReturnValue().apexMethodList);
                component.set("v.rows",response.getReturnValue().tstClass.split('\n').length);
                //                component.set("v.listApexClass",response.getReturnValue());
                //                
                component.set("v.screenName","Methods in Class");
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    refresh : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})