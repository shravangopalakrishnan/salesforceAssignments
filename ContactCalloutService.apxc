public class ContactCalloutService {
    
    @future(callout=true)
    public static void sendContactId(Id contactId, String operationType) {

        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://demo.com/api/contact');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            String jsonBody = '{"contactId": "' + contactId + '",' +
            '"operationType": "' + operationType + '"}';

            req.setBody(jsonBody);
            Http http = new Http();
            HttpResponse res = http.send(req);

            if(res.getStatusCode() == 200) {
                System.debug('Contact Id sent successfully: ' " res.getBody());    
        }
        else {
                System.debug('Failed to send Contact Id: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
    } catch (Exception e){
        System.debug('Error making callout:' + e.getMessage());
     }
  }
}
