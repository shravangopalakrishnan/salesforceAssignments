public class UserSyncScheduler implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        syncUsers();
    }

    @future(callout=true)
    public static void syncUsers() {
        Datetime twoHoursAgo = Datetime.now().addHours(-2);
        List<User> newUsers = [SELECT Id, FirstName, LastName, Email, Username, Alias, TimeZoneSidKey, LocaleSidKey 
                               FROM User 
                               WHERE CreatedDate >= :twoHoursAgo];

        if (!newUsers.isEmpty()) {
            for (User user : newUsers) {
                String requestBody = JSON.serialize(new Map<String, Object>{
                    'FirstName' => user.FirstName,
                    'LastName' => user.LastName,
                    'Email' => user.Email,
                    'Username' => user.Username,
                    'Alias' => user.Alias,
                    'TimeZoneSidKey' => user.TimeZoneSidKey,
                    'LocaleSidKey' => user.LocaleSidKey
                });

                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:myNamedCred/services/data/v56.0/sobjects/User');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setBody(requestBody);

                Http http = new Http();
                try {
                    HttpResponse res = http.send(req);

                    if (res.getStatusCode() == 201) {
                        System.debug('User created successfully in Org_B.');
                    } else {
                        System.debug('Failed to create user in Org_B. Status: ' + res.getStatus());
                    }
                } catch (Exception ex) {
                    System.debug('Exception occurred during callout: ' + ex.getMessage());
                }
            }
        } else {
            System.debug('No new users to sync in the past two hours.');
        }
    }
}
