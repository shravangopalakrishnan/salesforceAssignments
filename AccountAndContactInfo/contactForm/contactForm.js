import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createContact from '@salesforce/apex/AccountContactController.createContact';

export default class ContactForm extends LightningElement {
    @api accountId;
    @api accountName;
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleNext() {
        if (!this.lastName) {
            this.showToast('Error', 'Last Name is required.', 'error');
            return;
        }

        createContact({
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            phone: this.phone,
            accountId: this.accountId
        })

        .then(result => {
        this.showToast('Success', 'Contact created successfully!', 'success');
     this.dispatchEvent(new CustomEvent('contactcreated', { 
         detail: {
            contactId: result,
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            phone: this.phone
         }
     }));
    })

        .catch(error => {
            console.error('Error creating contact:', error);
            const errorMessage = error?.body?.message || 'An unknown error occurred while creating the Contact.';
            this.showToast('Error', errorMessage, 'error');
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}
