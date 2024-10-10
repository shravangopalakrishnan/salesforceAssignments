import { LightningElement, api, track, wire } from 'lwc';
import getOpportunitiesByAccountId from '@salesforce/apex/AccountController.getOpportunitiesByAccountId';

export default class OpportunityListScreen extends LightningElement {
    @api accountId;
    @track opportunities = [];
    columns = [
        { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
        { label: 'Amount', fieldName: 'Amount', type: 'currency' },
        { label: 'Stage', fieldName: 'StageName', type: 'text' },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
    ];

    @wire(getOpportunitiesByAccountId, { accountId: '$accountId' })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data;
        } else if (error) {
            console.error('Error fetching opportunities:', error);
        }
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('back'));
    }
}
