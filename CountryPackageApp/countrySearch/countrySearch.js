import { LightningElement, track, wire } from 'lwc';
import searchCountries from '@salesforce/apex/CountryController.searchCountries';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
import COUNTRY_PACKAGE_CHANNEL from '@salesforce/messageChannel/CountryPackageChannel__c';

export default class CountrySearch extends LightningElement {
    @track searchTerm = '';
    @track countries = [];
    @wire(MessageContext) messageContext;


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
        console.log('Country selected and published:', countryId);
        const message = { countryId };
        publish(this.messageContext, COUNTRY_PACKAGE_CHANNEL, message);
        this.dispatchEvent(new CustomEvent('countryselected', { detail: { countryId } }));

    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);
    }
}
