/**
 * Created by SUNGJIN on 2022-10-02.
 */

public with sharing class IF_GetDropshippingUsedBook {

    private static final String BASE_URL = 'http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?';

    private static String GetUrl(String ISBN13) {
        Map<String, String> paramMap = new Map<String, String>();
        paramMap.put('ttbkey', 'ttbtrstyq0151001');
        paramMap.put('ItemId', EncodingUtil.urlEncode(ISBN13, 'UTF-8'));
        paramMap.put('itemIdType', 'ISBN13');
        paramMap.put('OptResult', 'usedList');
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

    @Future(Callout = true)
    public static void getBookListInfo(Integer StartNum, Integer ENDNum){

        List<BookByVolume__c> ListBooks = [
                SELECT ISBN13__c, Name, Book__c
                FROM BookByVolume__c
                WHERE IsPurchased__c = FALSE
                AND f_order__c >=: StartNum
                AND f_order__c <: ENDNum];
        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();

        for(BookByVolume__c BBV : ListBooks){

            String searchWord = BBV.ISBN13__c;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(GetUrl(searchWord));
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {

                Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Books = (List<Object>) responseBooks.get('item');

                Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(Books[0]));
                Object subInfo = (Object) result1.get('subInfo');

                Map<String, Object> result2 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(subInfo));
                Object usedList = (Object) result2.get('usedList');

                Map<String, Object> result3 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(usedList));
                Object aladinUsed = (Object) result3.get('aladinUsed');

                Map<String, Object> result4 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(aladinUsed));

                Integer IsDropshipping = (Integer)result4.get('itemCount');
                Integer minPrice = (Integer)result4.get('minPrice');

                if(IsDropshipping != 0 && IsDropshipping != null){

                    System.debug(result3);

                    BranchBook__c BranchBook = new BranchBook__c();
                    BranchBook.Name = BBV.Name;
                    BranchBook.BranchName__c = '알라딘 직배송';
                    BranchBook.Book__c = BBV.Book__c;
                    BranchBook.BookLink__c = (String) result4.get('link');
                    BranchBook.MinPrice__c = String.valueOf(minPrice);
                    ListBranchBook.add(BranchBook);
                }

                Map<String, Object> result5 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(usedList));
                Object spaceUsed = (Object) result5.get('spaceUsed');

                Map<String, Object> result6 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(spaceUsed));

                Integer IsThereSpaceUsed = (Integer)result6.get('itemCount');
                Integer spaceMinPrice = (Integer)result6.get('minPrice');

                if(IsThereSpaceUsed != 0 && IsThereSpaceUsed != null){
                    List<BranchBook__c> spaceBranchBook = IF_GetUsedBookInfo.getUsedBookInfo(BBV.Name, searchWord, String.valueOf(spaceMinPrice), BBV.Book__c);

                    for(BranchBook__c SBB : spaceBranchBook){
                        ListBranchBook.add(SBB);
                    }
                }
            }
        }

        insert ListBranchBook;
    }

}