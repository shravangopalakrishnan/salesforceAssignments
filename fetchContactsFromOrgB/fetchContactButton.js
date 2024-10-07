import { LightningElement, track } from 'lwc';
import fetchContacts from '@salesforce/apex/ContactSyncController.fetchContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FetchContactButton extends LightningElement {
    @track contacts; // To hold the fetched contacts
    @track error; // To hold any error messages

    columns = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Email', fieldName: 'Email' },
        // Add more fields as needed
    ];

    handleFetchContacts() {
        fetchContacts()
            .then(result => {
                this.contacts = result; // Store fetched contacts
                this.showToast('Success', 'Contacts fetched and synced successfully!', 'success');
            })
            .catch(error => {
                this.error = error.body.message; // Store error message
                this.showToast('Error', 'Failed to fetch contacts: ' + this.error, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
