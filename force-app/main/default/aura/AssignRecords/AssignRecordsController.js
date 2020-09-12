({
    doInit : function(component, event, helper){
        //helper.getAllContacts(component);
    },
    clickOk: function(component, event, helper) {
      component.set("v.blnShowModule", true);
    },
    onClickConfirmDeactivate: function(component, event, helper) {
     	//var recordId = component.get('v.recordId');
        //var params = {};
        //params.recordId = recordId;
        helper.deactivateUser(component, event, helper);
    },
    closeModal: function(component,event,helper) {
      component.set("v.blnShowModule", false); 
    },
    clickCancel: function(component,event,helper) {
      window.location = '/'+component.get('v.recordId')+'?noredirect=1&isUserEntityOverride=1';
    },
})