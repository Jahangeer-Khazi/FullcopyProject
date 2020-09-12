({
    onWorkAssigned : function(component, event, helper) {
		if (!window.Notification) {
            console.log('Browser does not support notifications.');
            //alert('Notification Not supported')
        } else {
            // check if permission is already granted
            if (Notification.permission === 'granted') {
                // show notification here
                var notify = new Notification('New Incoming Chat/Email', {
                    body: 'Please check Salesforce',
                });
                //alert('Notification Success')
              /*  notify.onclick = function() {
                    window.open('https://whitehatjr.lightning.force.com/');
                };*/
            } else {
                // request permission from user
                Notification.requestPermission().then(function (p) {
                    // alert('Notification Requested')
                    if (p === 'granted') {
                        // show notification here
                        var notify = new Notification('New Incoming Chat/Email', {
                            body: 'Please check Salesforce',
                          
                        });
                     /*   notify.onclick = function() {
                            window.open('https://whitehatjr.lightning.force.com');
                        };*/
                    } else {
                        console.log('User blocked notifications.');
                    }
                }).catch(function (err) {
                    console.error(err);
                });
            }
        }
    }, 
})