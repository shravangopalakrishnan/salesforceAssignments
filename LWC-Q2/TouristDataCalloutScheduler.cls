public class TouristDataCalloutScheduler implements Schedulable {

    // Method to fetch Tourist Data asynchronously
    @future(callout=true)
    public static void fetchTouristData(){
        // Perform the callout to get the tourist data
        List<TouristDataResponse.Tourist> touristList = TouristDataCallout.getTouristData();
        System.debug('Fetched Tourist Data: ' + touristList);
        
        // Call the method to send the tourist data as an email
        sendTouristEmailResponse(touristList);
    }
    
    // Method to generate and send the Tourist Email Response
    public static void sendTouristEmailResponse(List<TouristDataResponse.Tourist> tourists){
        String emailBody = 'Tourist Data:\n\n';
        for(TouristDataResponse.Tourist tourist : tourists){
            emailBody += 'Name: ' + tourist.tourist_name + ', Email: ' + tourist.tourist_email + ', Location: ' + tourist.tourist_location + '\n';
        }

        // Prepare and send email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'shravgop@gmail.com'});
        email.setSubject('Tourist Data Report');
        email.setPlainTextBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

    // Execute method for Schedulable interface - schedule the callout
    public void execute(SchedulableContext sc){
        fetchTouristData(); // Async callout
    }
}
