import { LightningElement, track } from 'lwc';

export default class AccountContactManager extends LightningElement {
    @track showAccountForm = true;
    @track showContactForm = false;
    @track showSummaryScreen = false;

    @track accountId;
    @track accountName;
    @track accountDetails;
    @track contactDetails;

    handleAccountCreated(event) {
        this.accountId = event.detail.accountId;
        this.accountName = event.detail.accountName;
        this.accountDetails = { 
            accountId: this.accountId, 
            accountName: this.accountName 
        };
        this.showAccountForm = false;
        this.showContactForm = true;
    }

handleContactCreated(event) {
    this.contactDetails = {
        contactId: event.detail.contactId,
        firstName: event.detail.firstName,
        lastName: event.detail.lastName,
        email: event.detail.email,
        phone: event.detail.phone,
    };

    console.log('Contact Details:', this.contactDetails);

    this.showContactForm = false;
    this.showSummaryScreen = true;
}

}
