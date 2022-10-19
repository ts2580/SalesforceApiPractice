/**
 * Created by SUNGJIN on 2022-10-02.
 */

public with sharing class IF_GetDropshippingUsedBook {


    @Future(Callout = true)
    public static void getBookListInfo(Integer StartNum, Integer ENDNum){

        IF_Util IF_Util = new IF_Util();

        List<BookByVolume__c> ListBooks = [
                SELECT ISBN13__c, Name, Book__c
                FROM BookByVolume__c
                WHERE IsPurchased__c = FALSE
                AND f_order__c >=: StartNum
                AND f_order__c <: ENDNum];
        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();

        Map<String, Id> BranchMap = IF_Util.getBranch();
        Map<String, String> ParamMap = new Map<String, String>();

        for(BookByVolume__c BBV : ListBooks){

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(IF_Util.getDropshippingUsedBookURL(BBV.ISBN13__c));
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

                Integer IsDropShipping = (Integer)result4.get('itemCount');
                Integer minPrice = (Integer)result4.get('minPrice');

                if(IsDropShipping != 0 && IsDropShipping != null){

                    BranchBook__c BranchBook = new BranchBook__c();
                    BranchBook.Name = BBV.Name;
                    BranchBook.Branch__c = BranchMap.get('알라딘 직배송');
                    BranchBook.Book__c = BBV.Book__c;

                    String link = (String) result4.get('link');
                    BranchBook.BookLink__c = link.replace('amp;','');

                    BranchBook.MinPrice__c = String.valueOf(minPrice);
                    ListBranchBook.add(BranchBook);
                }

                Map<String, Object> result5 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(usedList));
                Object spaceUsed = (Object) result5.get('spaceUsed');

                Map<String, Object> result6 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(spaceUsed));

                Integer IsThereSpaceUsed = (Integer)result6.get('itemCount');
                Integer spaceMinPrice = (Integer)result6.get('minPrice');

                if(IsThereSpaceUsed != 0 && IsThereSpaceUsed != null){
                    ParamMap.put('BookName', BBV.Name);
                    ParamMap.put('ISBN13', BBV.ISBN13__c);
                    ParamMap.put('MinPrice', String.valueOf(spaceMinPrice));
                    ParamMap.put('MasterBook', BBV.Book__c);
                    List<BranchBook__c> spaceBranchBook = IF_GetUsedBookInfo.getUsedBookInfo(BranchMap, ParamMap);

                    for(BranchBook__c SBB : spaceBranchBook){
                        ListBranchBook.add(SBB);
                    }
                }
            }
        }
        insert ListBranchBook;
    }

}