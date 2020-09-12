({
 doInit : function(cmp, event, helper) {

    var action = cmp.get("c.WHJ_GetMobile");
    action.setParams({ OppId : cmp.get("v.recordId") });

    // Create a callback that is executed after 
    // the server-side action returns
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            // Alert the user with the value returned 
            // from the server

            if(response.getReturnValue() != null)
            {
                var Mobile = response.getReturnValue().replace("+", "");
                var url = 'https://wa.me/' + Mobile;
                window.open(url);      
            }
            else{
                var url = 'https://web.whatsapp.com/'
                window.open(url);  
            }
            

            // You would typically fire a event here to trigger 
            // client-side notification that the server-side 
            // action is complete
        }
         else {
                console.log("Unknown error");
            }
        
    });

    // optionally set storable, abortable, background flag here

    // A client-side action could cause multiple events, 
    // which could trigger other events and 
    // other server-side action calls.
    // $A.enqueueAction adds the server-side action to the queue.
    $A.enqueueAction(action);
    
    
    },
    doneRendering: function(cmp, event, helper) {

        
        $A.get("e.force:closeQuickAction").fire();
    }
})