public class BatchExecutor {
    public static void startAccountBatch() {
        AccountBatch batch = new AccountBatch();
        Database.executeBatch(batch, 10); 
    }
}
