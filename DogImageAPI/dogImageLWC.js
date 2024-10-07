import { LightningElement, track } from 'lwc';

export default class DogImageLWC extends LightningElement {
    @track dogImageUrl; 
    @track isLoading = false; 
    @track errorMessage = '';
    connectedCallback() {
        this.fetchDogImage();
    }

    fetchDogImage() {
        this.isLoading = true;
        this.errorMessage = '';

        fetch('https://dog.ceo/api/breeds/image/random')
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then((data) => {
                return fetch(data.message);
            })
            .then((imageResponse) => {
                if (!imageResponse.ok) {
                    throw new Error('Failed to fetch the image');
                }
                return imageResponse.blob();
            })
            .then((imageBlob) => {
                const objectURL = URL.createObjectURL(imageBlob);
                this.dogImageUrl = objectURL;
                this.isLoading = false;
            })
            .catch((error) => {
                console.error('Error fetching dog image:', error);
                this.errorMessage = 'Failed to fetch the dog image due to CSP or network issues.';
                this.isLoading = false;
            });
    }

    handleGetNewImage() {
        this.fetchDogImage();
    }
}
