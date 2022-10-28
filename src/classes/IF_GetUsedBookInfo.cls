/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class IF_GetUsedBookInfo {

    public static List<BranchBook__c> getUsedBookInfo(Map<String, Id> BranchMap, Map<String, String> ParamMap) {

        IF_Util IF_Util = new IF_Util();

        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(IF_Util.getUsedBookInfoURL(ParamMap.get('ISBN13')));
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {

            Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Books = (List<Object>) responseBooks.get('itemOffStoreList');

            for(Object objectBook : Books){

                Map<String, Object> BranchDetail = (Map<String, Object>) objectBook;
                BranchBook__c BranchBook = new BranchBook__c();
                BranchBook.Name = ParamMap.get('BookName');
                BranchBook.Branch__c = BranchMap.get((String) BranchDetail.get('offName'));
                BranchBook.Book__c = ParamMap.get('MasterBook');

                String link = (String) BranchDetail.get('link');
                BranchBook.BookLink__c = link.replace('amp;','');

                BranchBook.MinPrice__c = ParamMap.get('MinPrice');
                ListBranchBook.add(BranchBook);
            }

        }

        return ListBranchBook;
    }

}