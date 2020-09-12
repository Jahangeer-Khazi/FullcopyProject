import { LightningElement,api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import serachUsers from '@salesforce/apex/UserListController.retriveUsers';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import STATUS__C_FIELD from '@salesforce/schema/User.Status__c';
import SHIFTS__C_FIELD from '@salesforce/schema/User.Shifts__c';
import CALL_AVAIABILITY_STATUS__C_FIELD from '@salesforce/schema/User.Call_Availability_Status__c';
import SALES_REGION__C_FIELD from '@salesforce/schema/User.Sales_Region__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';


export default class CustomSearchInLWC extends LightningElement {
    @track data;
    @track strSearchUserName = '';
    result;
    _wiredResult;

//this is initialize for 1st page
    @track page = 1; 
//it contains all the Product records.
    @track items = [];
//To display the data into datatable 
    @track data = [];
//holds column info. 
    @track columns;
//start record position per page 
    @track startingRecord = 1; 
//end record position per page
    @track endingRecord = 0; 
//10 records display per page
    @track pageSize = 10; 
//total count of record received from all retrieved records
    @track totalRecountCount = 0;
//total number of page is needed to display all records 
    @track totalPage = 0; 
//To display the column into the data table
    @track columns = [
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
        { label: 'Role', fieldName: 'UserRole__c'},
        { label: 'Manager', fieldName: 'Manager__c'}
    ];

    @track error;
    //@track columns = COLS;
    @track draftValues = [];
    @track users;
    @api Status ;
    @track status;
    @api Shifts;
    @track shifts;
    @track bShowModal = false;
    @track rowOffset = 0;
    @track record = {}; 

    
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

    @track
    defaultOptions = [];


//call the apex method and pass the search string into apex method.
    @wire(serachUsers, {strUserName : '$strSearchUserName' })
    wiredProducts(result) {
        this.items = result;
        this._wiredResult = result;
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
            this.items = result.data;
            this.totalRecountCount = result.data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
//initial data to be displayed ----------->
//slice will take 0th element and ends with 10, but it doesn't include 10th element
//so 0 to 9th rows will be displayed in the table
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;

            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }
    
    /*wiredProducts({ error, data }) {
        if (data) {
            this.items = data;
            this._wiredResult = data;
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
//initial data to be displayed ----------->
//slice will take 0th element and ends with 10, but it doesn't include 10th element
//so 0 to 9th rows will be displayed in the table
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;

            this.error = undefined;
            

          } else if (error) {
            this.error = error;
            this.data = undefined;
          }


       }*/
//this method is called when you clicked on the previous button 
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }
//this method is called when you clicked on the next button 
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }             
    }
//this method displays records page by page
    displayRecordPerPage(page){
    this.startingRecord = ((page -1) * this.pageSize) ;
    this.endingRecord = (this.pageSize * page);
    this.endingRecord = 
 (this.endingRecord > this.totalRecountCount) ?   this.totalRecountCount : this.endingRecord; 
 this.data = this.items.slice(this.startingRecord,   this.endingRecord);
 this.startingRecord = this.startingRecord + 1;
 }    
  
   handleUserName(event) {
       this.strSearchUserName = event.target.value;
       return refreshApex(this.result);
   }   
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
      //  this.salesRegion = event.target.value;
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
   // this.salesRegion = this.record.Sales_Region__c;
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
        return refreshApex(this._wiredResult);  
       // eval("$A.get('e.force:refreshView').fire();");
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

}