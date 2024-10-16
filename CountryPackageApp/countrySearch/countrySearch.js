import { LightningElement, track } from 'lwc';
import searchCountries from '@salesforce/apex/CountryController.searchCountries';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CountrySearch extends LightningElement {
    @track searchTerm = '';
    @track countries = [];

    handleSearch(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm.length > 1) {
            searchCountries({ searchTerm: this.searchTerm })
                .then(result => {
                    this.countries = result;
                    if (this.countries.length === 0) {
                        this.showToast('Info', 'No countries found', 'info');
                    }
                })
                .catch(error => {
                    console.error(error);
                    this.showToast('Error', 'Failed to search countries', 'error');
                });
        } else {
            this.countries = [];
        }
    }

    handleSelect(event) {
        const countryId = event.target.dataset.id;
        this.showToast('Success', 'Country selected', 'success');
        const selectedEvent = new CustomEvent('countryselected', { detail: { countryId } });
        this.dispatchEvent(selectedEvent);
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }
}
