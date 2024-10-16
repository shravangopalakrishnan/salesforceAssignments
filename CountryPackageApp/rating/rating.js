import { LightningElement, api } from 'lwc';
import saveRating from '@salesforce/apex/RatingController.saveRating';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Rating extends LightningElement {
    @api customerId;
    @api planId;
    @api countryId;
    ratingValue = '';
    feedback = '';

    handleRatingChange(event) {
        this.ratingValue = event.target.value;
    }

    handleFeedbackChange(event) {
        this.feedback = event.target.value;
    }

    handleSave() {
        saveRating({
            customerDetailId: this.customerId, 
            planId: this.planId, 
            countryId: this.countryId, 
            rating: parseFloat(this.ratingValue), 
            feedback: this.feedback 
        })
        .then(() => {
            this.showToast('Success', 'Thank you for your rating', 'success');
            this.dispatchEvent(new CustomEvent('ratingsubmitted')); // Notify the parent component
        })
        .catch(error => {
            console.error(error);
            this.showToast('Error', 'Failed to submit rating', 'error');
        });
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }
}
