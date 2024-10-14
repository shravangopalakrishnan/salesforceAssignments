import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createAccount from '@salesforce/apex/AccountContactController.createAccount';

export default class AccountForm extends LightningElement {
    @track accountName = '';
    @track phone = '';
    @track website = '';
    @track billingStreet = '';
    @track billingCity = '';

    handleAccountNameChange(event) {
        this.accountName = event.target.value;
        console.log('Account Name:', this.accountName);
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
        console.log('Phone:', this.phone);
    }

    handleWebsiteChange(event) {
        this.website = event.target.value;
        console.log('Website:', this.website);
    }

    handleBillingStreetChange(event) {
        this.billingStreet = event.target.value;
        console.log('Billing Street:', this.billingStreet);
    }

    handleBillingCityChange(event) {
        this.billingCity = event.target.value;
        console.log('Billing City:', this.billingCity);
    }

    handleNext() {
        if (!this.accountName) {
            this.showToast('Error', 'Account Name is required.', 'error');
            return;
        }

        createAccount({
            accountName: this.accountName,
            phone: this.phone,
            website: this.website,
            billingStreet: this.billingStreet,
            billingCity: this.billingCity
        })
        .then(result => {
            console.log('Account created with ID:', result);
            console.log('Account Name:', this.accountName);
        
            this.showToast('Success', 'Account created successfully!', 'success');
            this.dispatchEvent(new CustomEvent('accountcreated', { 
                detail: { accountId: result, accountName: this.accountName }
            }));
        })
        
        .catch(error => {
            console.error('Error creating account:', error);
            this.showToast('Error', `Failed to create Account: ${error.body.message}`, 'error');
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
