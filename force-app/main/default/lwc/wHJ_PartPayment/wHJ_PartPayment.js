/* eslint-disable no-console */
import { LightningElement,track,api } from 'lwc';
import insertPayment from '@salesforce/apex/WHJ_PartPayment.insertPayment';
import onloaddata from '@salesforce/apex/WHJ_PartPayment.onloaddata';
import delmethod from'@salesforce/apex/WHJ_PartPayment.delmethod';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class WHJ_PartPayment extends LightningElement {

    @track pamount;
    @track checkDisabled = true;
    @track res;
    @api recordId;
    @track paydate;
    @track cre;
    @track checkitem;
    @track showcomponent = false;
    @track myJSON;
    @track wizard=[{'SFRecordID':'','id':1,'pamount':'','paydate':'','cre':''}
                ];
        
    connectedCallback(){
        onloaddata({oppID:this.recordId})
        .then(result=>{
          
            if(JSON.parse(result).length > 0){
                this.wizard=JSON.parse(result);
                this.checkitem = true;
                this.showcomponent = true;
            }
        })

    }    
    showcomphandle(event){
     if(event.target.checked === true){
            this.showcomponent = true;
            if(this.wizard.length===0){
            this.wizard=[{'SFRecordID':'','id':1,'pamount':'','paydate':'','cre':''}];
            this.checkDisabled = true;
        }

        }
     else{
        this.showcomponent = false;
       
     }
        }
         
        captureValue(event)
        {
            let index = event.target.dataset.index;
            if(event.target.name==="input1")
            {
                this.wizard[index].pamount =event.target.value;
                console.log(event.target.value);
            }
            else if(event.target.name==="input2")
            {
                this.wizard[index].paydate =event.target.value;
                console.log(event.target.value);
            }
            else if(event.target.name==="input3")
            {
                this.wizard[index].cre =event.target.value;
                console.log(event.target.value);
            }
         
        }
        handleClick()
        {
            this.myJSON = JSON.stringify(this.wizard);
            insertPayment({
                oppID: this.recordId  ,
                 jsonstr:this.myJSON
             })
             .then(result => {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message:'submitted successfully!!!!' ,
                    variant: 'success',
                    });
                    this.dispatchEvent(evt);
                    console.log(result);
                    this.wizard = JSON.parse(result);
            
            //this.showLoadingSpinner = false;
            })
            .catch(error => {
            this.error = error;
            const evt = new ShowToastEvent({
                title: 'ERROR !!',
                message: 'Error' ,
                variant: 'error',
                });
                this.dispatchEvent(evt);

            });
         
            
        }
         
        Add(){
            this.wizard.push({'SFRecordID':'','id':this.wizard.length+1,'pamount':'','paydate':'','cre':''});
            }
         
        del(event)
        { 
            this.myJSON = JSON.stringify(this.wizard);
           // alert(this.myJSON);
             delmethod({precId:this.wizard[event.target.value].SFRecordID,jsonstr:this.myJSON});
            this.wizard.splice(event.target.value,1);
            if(this.wizard.length===0){
                this.checkDisabled = false;
                this.checkitem = false;
               // this.showcomponent = true;


            }                            
        }





}