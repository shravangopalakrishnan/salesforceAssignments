public with sharing class FileUploadController {
    
    @AuraEnabled
    public static String uploadFile(String fileName, String base64) {
        Blob fileBody = Blob.valueOf(base64);
        ContentVersion contentVersion = new ContentVersion(
            Title = fileName,
            PathOnClient = fileName,
            VersionData = fileBody
        );
        insert contentVersion;
        return contentVersion.Id;
    }
}
