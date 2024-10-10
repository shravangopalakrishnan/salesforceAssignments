import { LightningElement, track } from 'lwc';

export default class AccountOpportunityContainer extends LightningElement {
    @track isFirstScreen = true;
    @track selectedAccountId;

    handleAccountSelect(event) {
        this.selectedAccountId = event.detail;
        this.isFirstScreen = false;
    }

    handleBack() {
        this.isFirstScreen = true;
    }
}
