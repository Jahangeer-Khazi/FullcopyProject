({
    doInit : function(component, event, helper){
        helper.getUserData(component, event);
    },
    clickOk: function(component, event, helper) {
      component.set("v.blnShowModule", true);
    },
    onClickConfirmDeactivate: function(component, event, helper) {
        helper.deactivateUser(component, event, helper);
    },
    closeModal: function(component,event,helper) {
      component.set("v.blnShowModule", false); 
    },
    clickCancel: function(component,event,helper) {
        if(component.get("v.strTheme")=='Theme3' || component.get("v.strTheme") == 'Theme2'){
            window.location = '/'+component.get('v.recordId')+'?noredirect=1&isUserEntityOverride=1';
        }else{
            window.location = '/lightning/r/User/'+component.get('v.recordId')+'/view';
        }
    },
})