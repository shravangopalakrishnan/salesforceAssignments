public class NewsApiCallout {
    @AuraEnabled(cacheable=true)
    public static List<NewsItem> getNews() {
        String endpoint = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=6fa0e9b398f54c7783994cc0b568fd00';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        List<NewsItem> newsList = new List<NewsItem>();
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> articles = (List<Object>) results.get('articles');
            
            for (Object article : articles) {
                Map<String, Object> articleMap = (Map<String, Object>) article;
                
                String imageUrl = (String) articleMap.get('urlToImage');
                String url = (String) articleMap.get('url');
                
                if (imageUrl != null && url != null) {
                    newsList.add(new NewsItem(imageUrl, url));
                }
            }
        }
        return newsList;
    }
    
    public class NewsItem {
        @AuraEnabled public String imageUrl {get; set;}
        @AuraEnabled public String url {get; set;}
        
        public NewsItem(String imageUrl, String url) {
            this.imageUrl = imageUrl;
            this.url = url;
        }
    }
}
