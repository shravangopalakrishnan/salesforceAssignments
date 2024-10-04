public class AccountQueueableService implements Queueable {
    
    private Set<String> accountNames;

    public AccountQueueableService(Set<String> accountNames) {
        this.accountNames = accountNames;
    }

    public void execute(QueueableContext context) {
        AccountFutureService.createAccounts(accountNames);
    }
}
