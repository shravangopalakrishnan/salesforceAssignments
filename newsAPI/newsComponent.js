import { LightningElement, wire } from 'lwc';
import getNews from '@salesforce/apex/NewsApiCallout.getNews';

export default class NewsComponent extends LightningElement {
    newsItems;
    error;

    @wire(getNews)
    wiredNews({ error, data }) {
        if (data) {
            this.newsItems = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.newsItems = undefined;
        }
    }
}
