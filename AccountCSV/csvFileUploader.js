import { LightningElement } from 'lwc';
import uploadFile from '@salesforce/apex/FileUploadController.uploadFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CSVFileUploader extends LightningElement {
    fileData;

    handleFileChange(event) {
        const file = event.target.files[0];
        this.fileData = {
            'fileName': file.name,
            'fileContent': file
        };
    }

    handleUpload() {
        const { fileName, fileContent } = this.fileData;
        const reader = new FileReader();
        reader.onload = () => {
            const base64 = reader.result.split(',')[1];
            uploadFile({ fileName, base64 }).then(result => {
                this.showToast('Success', 'File uploaded successfully', 'success');
            }).catch(error => {
                this.showToast('Error', 'File upload failed', 'error');
            });
        };
        reader.readAsDataURL(fileContent);
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(evt);
    }
}
