// Schedules the job to run every hour
String cronExp = '0 0 * * * ?';  
System.schedule('Hourly Contact Sync', cronExp, new ContactSyncScheduler());
