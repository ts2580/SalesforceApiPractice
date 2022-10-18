/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class IF_GetUsedBookInfo {

    public static List<BranchBook__c> getUsedBookInfo(String Name,String ISBN13, String MinPrice, Id BookId) {

        IF_Util IF_Util = new IF_Util();

        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(IF_Util.getUsedBookInfoURL(ISBN13));
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {

            Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Books = (List<Object>) responseBooks.get('itemOffStoreList');

            for(Object objectBook : Books){

                Map<String, Object> BranchDetail = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));
                BranchBook__c BranchBook = new BranchBook__c();
                BranchBook.Name = Name;
                BranchBook.BranchName__c = (String) BranchDetail.get('offName');
                BranchBook.Book__c = BookId;
                BranchBook.BookLink__c = (String) BranchDetail.get('link');
                BranchBook.MinPrice__c = MinPrice;
                ListBranchBook.add(BranchBook);
            }


        }

        return ListBranchBook;
    }

}