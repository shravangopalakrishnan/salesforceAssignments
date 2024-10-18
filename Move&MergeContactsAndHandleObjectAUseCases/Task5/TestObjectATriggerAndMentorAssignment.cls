@isTest
private class TestObjectATriggerAndMentorAssignment {

    @isTest static void testAutoApprovalAndDuplicateDetection() {
        Object_A__c completedRecord = new Object_A__c(
            Email__c = 'autoapprove@example.com',
            Request_Status__c = 'Completed',
            Roles__c = 'Admin'
        );
        insert completedRecord;

        Object_A__c autoApproveRecord = new Object_A__c(
            Email__c = 'autoapprove@example.com',
            Roles__c = 'Developer'
        );
        insert autoApproveRecord;

        autoApproveRecord = [SELECT Request_Status__c, Is_Auto_Approved__c FROM Object_A__c WHERE Id = :autoApproveRecord.Id];
        System.assertEquals('Approved', autoApproveRecord.Request_Status__c);
        System.assertEquals(true, autoApproveRecord.Is_Auto_Approved__c);

        Object_A__c duplicateRecord = new Object_A__c(
            Email__c = 'duplicate@example.com',
            Roles__c = 'Admin;Developer',
            Request_Type__c = 'Mentee'
        );
        insert duplicateRecord;

        Object_A__c secondDuplicateRecord = new Object_A__c(
            Email__c = 'duplicate@example.com',
            Roles__c = 'Manager'
        );
        insert secondDuplicateRecord;

        secondDuplicateRecord = [SELECT Request_Status__c FROM Object_A__c WHERE Id = :secondDuplicateRecord.Id];
        System.assertEquals('Duplicate', secondDuplicateRecord.Request_Status__c);
    }

    @isTest static void testMentorAssignment() {
        Object_A__c mentor = new Object_A__c(
            Email__c = 'mentor@example.com',
            Request_Status__c = 'Approved',
            Roles__c = 'Developer',
            Experience__c = '6-10 yr',
            Language__c = 'English',
            Request_Type__c = 'Mentor',
            Match_Found__c = false
        );
        insert mentor;

        Object_A__c mentee = new Object_A__c(
            Email__c = 'mentee@example.com',
            Request_Status__c = 'New',
            Roles__c = 'Developer',
            Experience__c = '4-5 yr',
            Language__c = 'English',
            Request_Type__c = 'Mentee',
            Action__c = 'Find Mentor'
        );
        insert mentee;

        mentee.Action__c = 'Find Mentor';
        update mentee;

        mentee = [SELECT Match_Found__c, Request_Status__c FROM Object_A__c WHERE Id = :mentee.Id];
        System.assertEquals(true, mentee.Match_Found__c);
        System.assertEquals('Match Found', mentee.Request_Status__c);

        mentor = [SELECT Match_Found__c, Request_Status__c FROM Object_A__c WHERE Id = :mentor.Id];
        System.assertEquals(true, mentor.Match_Found__c);
        System.assertEquals('Match Found', mentor.Request_Status__c);
    }
}
