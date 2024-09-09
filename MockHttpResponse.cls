@isTest
global class MockHttpResponse implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {

        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody(' {"status": "success"}');

        return res;
    }


    @isTest
    global class MockHttpErrorResponse implements HttpCalloutMock{
        global HttpResponse respond(Httprequest req){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody(' {"status": "error"}');
            return res;
       
        }
    }
}
