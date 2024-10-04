public class TouristDataResponse {
    public List<Tourist> data;
    
    public class Tourist{
        public Integer id;
        public String tourist_name;
        public String tourist_email;
        public String tourist_location;            
    }
    
    public static TouristDataResponse parse(String jsonResponse){
        return (TouristDataResponse) JSON.deserialize(jsonResponse, TouristDataResponse.class);
    }

}
