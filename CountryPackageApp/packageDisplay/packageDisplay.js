import { LightningElement, api, track, wire } from 'lwc';
import getPlansByCountry from '@salesforce/apex/PlanController.getPlansByCountry';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
import COUNTRY_PACKAGE_CHANNEL from '@salesforce/messageChannel/CountryPackageChannel__c';


export default class PackageDisplay extends LightningElement {
    @api countryId;
    @track packages = [];
    @wire(MessageContext) messageContext;


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
        console.log('Plan selected and published:', planId);

        const message = { planId, countryId: this.countryId };
        publish(this.messageContext, COUNTRY_PACKAGE_CHANNEL, message);

        this.dispatchEvent(new CustomEvent('proceedtocustomerdetails', { detail: { planId } }));

    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }
}
