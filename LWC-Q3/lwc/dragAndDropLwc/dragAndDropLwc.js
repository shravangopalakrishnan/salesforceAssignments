import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DragAndDropLwc extends LightningElement {
    records;
    pickVals;
    recordId;

    /*** Fetching Opportunity lists ***/
    @wire(getListUi, {
        objectApiName: OPPORTUNITY_OBJECT,
        listViewApiName: 'AllOpportunities'
    }) wiredListView({ error, data }) {
        if (data) {
            console.log("getListUi", data);
            this.records = data.records.records.map(item => {
                // Add null checks to prevent errors
                let field = item?.fields;
                let account = field?.Account?.value?.fields;
                
                return {
                    'Id': field?.Id?.value,
                    'Name': field?.Name?.value,
                    'AccountId': account?.Id?.value,
                    'AccountName': account?.Name?.value,
                    'CloseDate': field?.CloseDate?.value,
                    'StageName': field?.StageName?.value,
                    'Amount': field?.Amount?.value
                };
            }).filter(record => record.Id); // Filter out any incomplete records
        }
        if (error) {
            console.error(error);
        }
    }

    /*** Fetch metadata about the opportunity object ***/
    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo;

    /*** Fetching Stage Picklist ***/
    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: STAGE_FIELD
    })
    stagePicklistValues({ data, error }) {
        if (data) {
            console.log("Stage Picklist", data);
            this.pickVals = data.values.map(item => item.value);
        }
        if (error) {
            console.error(error);
        }
    }

    /*** Getter to calculate the width dynamically ***/
    get calcWidth() {
        let len = this.pickVals.length + 1;
        return `width: calc(100vw/ ${len})`;
    }

    handleListItemDrag(event) {
        this.recordId = event.detail;
    }

    handleItemDrop(event) {
        let stage = event.detail;
        this.updateHandler(stage);
    }

    updateHandler(stage) {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[STAGE_FIELD.fieldApiName] = stage;
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                console.log("Updated Successfully");
                this.showToast();
                return refreshApex(this.wiredListView);
            })
            .catch(error => {
                console.error(error);
            });
    }

    showToast() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Stage updated Successfully',
                variant: 'success'
            })
        );
    }
}
