import { LightningElement, api } from 'lwc';

export default class SummaryScreen extends LightningElement {
    @api accountDetails;  
    @api contactDetails;  
}
