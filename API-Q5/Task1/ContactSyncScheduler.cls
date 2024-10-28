public class ContactSyncScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        ContactSyncService.syncContacts();
    }
}
