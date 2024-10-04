public class TouristDataCallout {
    
    public static HttpResponse makeCallout(){
        Http Http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('http://restapi.adequateshop.com/api/Tourist?page=2');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        
        return http.send(req);
    }
    
    public static List<TouristDataResponse.Tourist> getTouristData(){
        HttpResponse res = makeCallout();
        
        if(res != null && res.getStatusCode() == 200){
            STring jsonResponse = res.getBody();
            TouristDataResponse touristData = TouristDataResponse.parse(jsonResponse);
            return touristData.data;
        }
        
        return new List<TouristDataResponse.Tourist>();
    }

}
