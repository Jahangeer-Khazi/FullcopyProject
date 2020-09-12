({
	getUserData : function(component, event) {
		var action = component.get("c.getUserData");
        action.setCallback(this, function(a){
            component.set("v.contactRows", a.getReturnValue());
        });
        $A.enqueueAction(action);
	},
    /*deactivateUser: function(component, event, recordData) {
        // call server side function
        var params = {};
        params.userId = component.get("v.recordId");
        params.serverMethod = 'deactivateUser';
        params.buttonName = component.get("v.buttonValue");
        this.callServerFunction(component, event, params);
    },*/
    deactivateUser: function(component, event, params) {
        var action = component.get('c.deactivateUser');
        var self = this;
  		action.setParams({ 
            userId : component.get("v.recordId"),
            IJMRecommendedButton : component.get("v.buttonValue")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
               var returnDetails = response.getReturnValue();
            	var msgText = '';
                if(component.get("v.buttonValue") == 'IJMRecommended'){
                    msgText = msgText + 'assigned the opportunities to the manager Successfully.';
                }else{
                    msgText = msgText + '!!';
                }
                var msgObject = { isSuccess : true, title : 'Confirmation', severity : 'confirm', message : msgText, isClosable : true };
            	component.set('v.ObjMessage', msgObject);
                self.hideModal(component,event);
            }
            else{
             	var msgObject = { isSuccess : false, title : 'Error', severity : 'error', message : 'User not deactivated, received some exception.', isClosable : false };
            	component.set('v.ObjMessage', msgObject);   
            }
            var uiMessage = component.find('uiMessage');
            $A.util.removeClass(uiMessage, 'slds-hide');
            $A.util.addClass(uiMessage, 'slds-show');
        });
        $A.enqueueAction(action);
    },
    hideModal: function(component,event) {
        component.set("v.blnShowModule", false);
    },
})