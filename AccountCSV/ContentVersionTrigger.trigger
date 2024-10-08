trigger ContentVersionTrigger on ContentVersion (after insert) {
    for (ContentVersion cv : Trigger.New) {
        if (cv.PathOnClient.endsWith('.csv')) {
            CSVProcessor.processCSV(cv.ContentDocumentId);
        }
    }
}
