import { LightningElement, track } from 'lwc';

export default class ParentComponent extends LightningElement {
    @track currentStep = '1';
    @track selectedCountryId = null;
    @track selectedPlanId = null;
    @track savedCustomerId = null;

    get showCountrySearch() {
        return this.currentStep === '1';
    }

    get showPackageDisplay() {
        return this.currentStep === '2';
    }

    get showCustomerDetails() {
        return this.currentStep === '3';
    }

    get showRating() {
        return this.currentStep === '4';
    }

    get showThankYouScreen() {
        return this.currentStep === 'completed';
    }

    handleCountrySelected(event) {
        this.selectedCountryId = event.detail.countryId;
        this.currentStep = '2';
    }

    handleProceedToCustomerDetails(event) {
        this.selectedPlanId = event.detail.planId;
        this.currentStep = '3';
    }

    handleCustomerSaved(event) {
        this.savedCustomerId = event.detail.customerId;
        this.currentStep = '4';
    }

    handleRatingSubmitted() {
        this.currentStep = 'completed'; // Set to completed to show the Thank You screen
    }
}
