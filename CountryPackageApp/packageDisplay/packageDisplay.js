import { LightningElement, api, track, wire } from 'lwc';
import getPlansByCountry from '@salesforce/apex/PlanController.getPlansByCountry';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PackageDisplay extends LightningElement {
    @api countryId;
    @track packages = [];

    @wire(getPlansByCountry, { countryId: '$countryId' })
    wiredPlans({ error, data }) {
        if (data) {
            this.packages = data;
        } else if (error) {
            this.showToast('Error', 'Failed to load packages', 'error');
        }
    }

    handleProceed(event) {
        const planId = event.target.dataset.id;
        this.showToast('Success', 'Proceeding to Booking', 'success');
        const proceedEvent = new CustomEvent('proceedtocustomerdetails', { detail: { planId } });
        this.dispatchEvent(proceedEvent);
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }
}
