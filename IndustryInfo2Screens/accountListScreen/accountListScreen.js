import { LightningElement, track, wire } from 'lwc';
import getIndustries from '@salesforce/apex/AccountController.getIndustries';
import getAccountsByIndustry from '@salesforce/apex/AccountController.getAccountsByIndustry';

export default class AccountListScreen extends LightningElement {
    @track industryOptions = [];
    @track selectedIndustry = '';
    @track accounts = [];
    columns = [
        { label: 'Account Name', fieldName: 'Name', type: 'text' },
        { label: 'Phone Number', fieldName: 'Phone', type: 'phone' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { type: 'button', typeAttributes: { label: 'View Opportunities', name: 'view_opportunities' } }
    ];

    @wire(getIndustries)
    wiredIndustries({ error, data }) {
        if (data) {
            this.industryOptions = data.map(industry => ({ label: industry, value: industry }));
        } else if (error) {
            console.error('Error fetching industries:', error);
        }
    }

    handleIndustryChange(event) {
        this.selectedIndustry = event.detail.value;
        if (this.selectedIndustry) {
            getAccountsByIndustry({ industry: this.selectedIndustry })
                .then(result => {
                    this.accounts = result;
                })
                .catch(error => {
                    console.error('Error fetching accounts:', error);
                });
        }
    }

    handleAccountSelect(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view_opportunities') {
            const selectedEvent = new CustomEvent('accountselect', { detail: row.Id });
            this.dispatchEvent(selectedEvent);
        }
    }
}
