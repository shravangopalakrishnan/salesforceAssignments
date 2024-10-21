import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveDataLoadTemplate from '@salesforce/apex/DataLoadTemplateController.saveDataLoadTemplate';
import { NavigationMixin } from 'lightning/navigation';

export default class DataLoadTemplate extends NavigationMixin(LightningElement) {
    @track selectedObject = '';
    @track availableFields = [];
    @track selectedFields = [];
    @track selectedAvailableFields = [];
    @track selectedSelectedFields = [];
    @track templateName = '';
    @track selectedDML = '';
    @track errorMessage = '';

    objectOptions = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Lead', value: 'Lead' },
        { label: 'Opportunity', value: 'Opportunity' }
    ];

    dmlOptions = [
        { label: 'Insert', value: 'Insert' },
        { label: 'Update', value: 'Update' },
        { label: 'Delete', value: 'Delete' }
    ];

    fieldLabelColumn = [
        { label: 'Field Label', fieldName: 'label' }
    ];

    handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        this.fetchFields();
    }

    fetchFields() {
        this.availableFields = [
            { id: 1, label: 'Name', apiName: 'Name' },
            { id: 2, label: 'Email', apiName: 'Email' },
            { id: 3, label: 'Phone', apiName: 'Phone' },
            { id: 4, label: 'Industry', apiName: 'Industry' }
        ];
    }

    handleAvailableFieldSelection(event) {
        this.selectedAvailableFields = event.detail.selectedRows.map(row => row.id);
    }

    handleSelectedFieldSelection(event) {
        this.selectedSelectedFields = event.detail.selectedRows.map(row => row.id);
    }

    addFieldsToSelection() {
        const fieldsToAdd = this.availableFields.filter(
            field => this.selectedAvailableFields.includes(field.id) &&
                !this.selectedFields.some(selected => selected.id === field.id)
        );
        this.selectedFields = [...this.selectedFields, ...fieldsToAdd];
        this.selectedAvailableFields = [];
    }

    removeFieldsFromSelection() {
        this.selectedFields = this.selectedFields.filter(
            field => !this.selectedSelectedFields.includes(field.id)
        );
        this.selectedSelectedFields = [];
    }

    handleTemplateNameChange(event) {
        this.templateName = event.detail.value;
    }

    handleDMLChange(event) {
        this.selectedDML = event.detail.value;
    }

    handleCreateTemplate() {
        this.errorMessage = '';
    
        if (!this.templateName || !this.selectedDML) {
            this.showToast('Error', 'All fields are required: Please fill Template Name and select DML Type.', 'error');
            return;
        }
    
        if (this.selectedFields.length === 0) {
            this.showToast('Error', 'At least one field should be selected to create the template.', 'error');
            return;
        }
    
        if (this.selectedDML === 'Insert') {
            const requiredFields = ['Name', 'Email'];  
            const selectedFieldLabels = this.selectedFields.map(field => field.label);
    
            const missingRequiredFields = requiredFields.filter(field => !selectedFieldLabels.includes(field));
            if (missingRequiredFields.length > 0) {
                this.showToast('Error', `Required fields missing for Insert: ${missingRequiredFields.join(', ')}`, 'error');
                return;
            }
    
        }
    
        if (this.selectedDML === 'Update') {
            if (this.selectedFields.length !== 1) {
                this.showToast('Error', 'Exactly one field must be selected for Update.', 'error');
                return;
            }
        }
    
        const selectedFieldLabels = this.selectedFields.map(field => field.label).join(', ');
        const selectedApiNames = this.selectedFields.map(field => field.apiName).join(', ');
    
        saveDataLoadTemplate({
            templateName: this.templateName,
            dmlType: this.selectedDML,
            fieldLabels: selectedFieldLabels,
            apiNames: selectedApiNames
        })
        .then(result => {
            this.errorMessage = '';
            this.showToast('Success', 'Template Created and Submitted for Approval', 'success');
            this.navigateToRecord(result);
        })
        .catch(error => {
            this.errorMessage = error.body.message;
            this.showToast('Error', this.errorMessage, 'error');
        });
    }
    
    
    validateInputs() {
        if (!this.selectedObject || !this.selectedFields.length || !this.templateName || !this.selectedDML) {
            this.errorMessage = 'All fields are required, and at least one field should be selected.';
            this.showToast('Error', this.errorMessage, 'error');
            return false;
        }
        return true;
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view',
            },
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}
