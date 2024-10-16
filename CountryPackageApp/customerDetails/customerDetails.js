import { LightningElement, api } from 'lwc';
import saveCustomerDetail from '@salesforce/apex/CustomerDetailController.saveCustomerDetail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomerDetails extends LightningElement {
    @api countryId;
    name = '';
    phone = '';

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }

    handleSave() {
        saveCustomerDetail({ name: this.name, phone: this.phone, countryId: this.countryId })
            .then((customerId) => {
                this.showToast('Success', 'Customer details saved', 'success');
                const saveEvent = new CustomEvent('customersaved', { detail: { customerId } });
                this.dispatchEvent(saveEvent);
            })
            .catch(error => {
                console.error(error);
                this.showToast('Error', 'Failed to save customer details', 'error');
            });
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }
}
