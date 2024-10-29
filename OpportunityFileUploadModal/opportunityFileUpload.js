import { LightningElement, api, wire } from 'lwc';
import shareOpportunityAndFile from '@salesforce/apex/OpportunityFileSyncService.shareOpportunityAndFile';
import uploadAndLinkFiles from '@salesforce/apex/OpportunityFileController.uploadAndLinkFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

const FIELDS = ['Opportunity.Name'];

export default class OpportunityFileUpload extends LightningElement {
    @api recordId;
    isFileUploadModalOpen = false;
    isMainModalOpen = true;
    isSendDisabled = true;
    uploadedFiles = [];
    wiredOpportunity;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    opportunity;

    handleUploadClick() {
        this.isFileUploadModalOpen = true;
        this.isMainModalOpen = false;
    }

    handleFileUploadFinish(event) {
        const uploadedFilesDetails = event.detail.files;
        this.uploadedFiles = uploadedFilesDetails.map(file => ({
            contentDocumentId: file.documentId
        }));

        if (this.uploadedFiles.length > 0) {
            uploadAndLinkFiles({
                opportunityId: this.recordId,
                fileWrapperList: this.uploadedFiles
            })
            .then(() => {
                this.isSendDisabled = false;
                this.showToast('Success', 'Files uploaded and linked to the Opportunity successfully.', 'success');
                this.isFileUploadModalOpen = false;
                this.isMainModalOpen = true;

                return refreshApex(this.opportunity);

            })
            .catch(error => {
                this.showToast('Error', 'Failed to link files: ' + error.body.message, 'error');
                console.error('Error in file upload and link:', error);
            });
        }
    }

    closeModal() {
        this.isFileUploadModalOpen = false;
        this.isMainModalOpen = false;

        const backdrop = this.template.querySelector('.slds-backdrop');
        if (backdrop) {
            backdrop.classList.remove('slds-backdrop_open');
        }
    }

    handleSendClick() {
        shareOpportunityAndFile({
            opportunityId: this.recordId,
            fileIds: this.uploadedFiles.map(file => file.contentDocumentId)
        })
        .then(() => {
            this.showToast('Success', 'Opportunity and Files synced to Org B.', 'success');
            this.isMainModalOpen = false;
            this.isSendDisabled = true;
        })
        .catch(error => {
            this.showToast('Error', 'Failed to sync with Org B: ' + error.body.message, 'error');
            console.error('Error syncing files and opportunity:', error);
        });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}
