/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class IF_GetUsedBookInfo {

    private static final String BASE_URL = 'http://www.aladin.co.kr/ttb/api/ItemOffStoreList.aspx?';

    private static String GetUrl(String ISBN13) {
        Map<String, String> paramMap = new Map<String, String>();
        paramMap.put('ttbkey', 'ttbtrstyq0151001');
        paramMap.put('ItemId', EncodingUtil.urlEncode(ISBN13, 'UTF-8'));
        paramMap.put('itemIdType', 'ISBN13');
        paramMap.put('output', 'JS');
        paramMap.put('Version', '20131101');

        String URL = BASE_URL;
        Iterator<String> iter = paramMap.keySet().iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            String value = paramMap.get(key);

            URL += key + '=' + value + '&';
        }

        return URL;
    }

    public static List<BranchBook__c> getUsedBookInfo(String Name,String ISBN13, String MinPrice) {



        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();

        String searchWord = GetUrl(ISBN13);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(GetUrl(searchWord));
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {

            Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Books = (List<Object>) responseBooks.get('itemOffStoreList');



            for(Object objectBook : Books){

                Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(Books));
                BranchBook__c BranchBook = new BranchBook__c();
                BranchBook.Name = Name;
                BranchBook.BranchName__c = (String) result1.get('offName');
                BranchBook.MinPrice__c = MinPrice;
                ListBranchBook.add(BranchBook);
            }


        }

        return ListBranchBook;
    }

}