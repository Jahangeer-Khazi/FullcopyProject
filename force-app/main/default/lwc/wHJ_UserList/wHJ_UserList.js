import { LightningElement,api,wire,track } from 'lwc';
import findUsers from '@salesforce/apex/UserListController.findUsers';
import updateUsers from '@salesforce/apex/UserListController.updateUsers';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import ID_FIELD from '@salesforce/schema/User.Id';
import PHONE_FIELD from '@salesforce/schema/User.Phone';
import STATUS__C_FIELD from '@salesforce/schema/User.Status__c';
import SHIFTS__C_FIELD from '@salesforce/schema/User.Shifts__c';
import CALL_AVAIABILITY_STATUS__C_FIELD from '@salesforce/schema/User.Call_Availability_Status__c';
import SALES_REGION__C_FIELD from '@salesforce/schema/User.Sales_Region__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
//import MANAGERID_FIELD from '@salesforce/schema/User.ManagerId';


const COLS = [
    {
        label: 'View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            iconName: 'action:preview',
            title: 'Preview',
            variant: 'border-filled',
            alternativeText: 'View'
        }
    },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email', type: 'email'},
    { label: 'Phone', fieldName: 'Phone'},
    { label: 'Rostering Status', fieldName: 'Status__c', type: 'Picklist' },
    { label: 'Shifts', fieldName: 'Shifts__c', type: 'Picklist' },
    { label: 'Manager Availability', fieldName: 'Call_Availability_Status__c'},
    { label: 'Region', fieldName: 'Sales_Region__c'},
    { label: 'Role', fieldName: 'UserRole__c' }
];
export default class WHJ_UserList extends LightningElement {
    @track error;
    @track columns = COLS;
    @track draftValues = [];
    @track users;
    @api Status ;
    @track status;
    
    @track bShowModal = false;
    @track rowOffset = 0;
    @track record = {}; 
    @track data = {};
    @track
    defaultOptions = [];

    @wire(findUsers) users;
    
    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA',fieldApiName: STATUS__C_FIELD })
    statusValues;
    statusValue="";
    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA',fieldApiName: SHIFTS__C_FIELD })
    shiftsValues;
    shiftsValue="";
    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA',fieldApiName: CALL_AVAIABILITY_STATUS__C_FIELD })
    callAvailabilities;
    callAvailability="";
    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA',fieldApiName: SALES_REGION__C_FIELD })
    salesRegions;
    salesRegion="";

    handleChange(event) {
        if(event.target.name === 'status'){
            this.statusValue = event.target.value;
            }
        if(event.target.name === 'shifts'){
                this.shiftsValue = event.target.value;
            }
        if(event.target.name === 'mgr'){
            this.callAvailability = event.target.value;
        }
        if(event.target.name === 'sales'){
            //this.salesRegion = event.target.value;
            this._selected = event.detail.value;
            if(this._selected[0] != null){
                this._multiVal = this._selected[0];
            }
            if(this._selected[0] != null && this._selected[1] != null){
                this._multiVal = this._selected[0]+';' +this._selected[1];
            }
            if(this._selected[0] != null && this._selected[1] != null && this._selected[2] != null){
                this._multiVal = this._selected[0]+ ';'+this._selected[1]+ ';'+this._selected[2];
            }
        }

    }
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        this.statusValue = this.record.Status__c;
        this.shiftsValue = this.record.Shifts__c;
        this.callAvailability = this.record.Call_Availability_Status__c;
        //this.salesRegion = this.record.Sales_Region__c;
        var foundRoles = this.record.Sales_Region__c.split(';');
        this.defaultOptions = foundRoles;

        this.bShowModal = true; // display modal window
    }
 
    // to close modal window set 'bShowModal' tarck value as false
    closeModal() {
        this.bShowModal = false;
    }

    handleSave() {
        let recordInput = {
            fields: {
                Id: this.record.Id,
                Status__c: this.statusValue,
                Shifts__c: this.shiftsValue,
                Call_Availability_Status__c:this.callAvailability ,
                Sales_Region__c:this._multiVal ,
            },
        };

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'User updated',
                    variant: 'success'
                })
            );
            // Clear all draft values
            this.draftValues = [];
            this.bShowModal = false;

            // Display fresh data in the datatable
            return refreshApex(this.users);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
    /* callupdateUsers(){
        alert('save'+JSON.stringify(this.record));
        updateUsers({
            userObj : this.record

        })
        .then(result => {
            console.log(result);
            //console.log(result.data);
            this.users.data = result;
            this.bShowModal=false;
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'User Updated',
                variant: 'success'
            });
            this.dispatchEvent(event);

        })
        .catch((error) => {
            const event = new ShowToastEvent({
                title: 'Error updating record',
                message: error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);

            // this.message = 'Error received: code' + error.errorCode + ', ' +
            //    'message ' + error.body.message;
        });
    }*/
   

}