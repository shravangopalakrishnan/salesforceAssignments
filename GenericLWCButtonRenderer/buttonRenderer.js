import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ButtonRenderer extends NavigationMixin(LightningElement) {
    @api buttonNames = '';  
    @api buttonTypes = '';  
    
    buttonNamesArray = [];
    buttonTypesArray = [];

    connectedCallback() {
        if (this.buttonNames) {
            this.buttonNamesArray = this.buttonNames.replace(/[\[\]]/g, '').split(',').map(name => name.trim());
        }
        if (this.buttonTypes) {
            this.buttonTypesArray = this.buttonTypes.replace(/[\[\]]/g, '').split(',').map(type => type.trim().toLowerCase());
        }
        console.log('Initialized button names:', this.buttonNamesArray);
        console.log('Initialized button types:', this.buttonTypesArray);
    }

    handleButtonClick(event) {
        const index = event.target.dataset.index;
        const buttonType = this.buttonTypesArray[index];
        const buttonName = this.buttonNamesArray[index];
    
        console.log(`Button clicked - Name: ${buttonName}, Type: ${buttonType}`);
    
        if (buttonType === 'url') {
            this.showToast('Navigating to:', buttonName, 'success');
            console.log('Navigating directly to URL:', buttonName);
            if (buttonName.startsWith('http://') || buttonName.startsWith('https://')) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: buttonName
                    }
                });
            } else {
                this.showToast('Navigation Error', 'Invalid URL format', 'error');
            }
        } else if (buttonType === 'button') {
            console.log('Triggering toast for button:', buttonName);
            this.showToast('Button Clicked', `You clicked the ${buttonName} button!`, 'success');
        } else {
            console.log(`Unknown button type: ${buttonType}`);
        }
    }
    

    navigateToUrl(url) {
        if (url && (url.startsWith('http://') || url.startsWith('https://'))) {
            console.log('Navigating to:', url);
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: url
                }
            });
        } else {
            console.error('Invalid or unsupported URL format:', url);
            this.showToast('Navigation Error', `Invalid URL: ${url}`, 'error');
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}
