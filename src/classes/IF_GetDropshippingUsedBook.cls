/**
 * Created by SUNGJIN on 2022-10-02.
 */

public with sharing class IF_GetDropshippingUsedBook {


    @Future(Callout = true)
    public static void getBookListInfo(Integer StartNum, Integer ENDNum){

        IF_Util IF_Util = new IF_Util();

        String a = null;

        List<BookByVolume__c> ListBooks = [
                SELECT ISBN13__c, Name, Book__c
                FROM BookByVolume__c
                WHERE IsPurchased__c = FALSE
                AND f_order__c >=: StartNum
                AND f_order__c <: ENDNum];
        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();



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

                Integer IsDropshipping = (Integer)result4.get('itemCount');
                Integer minPrice = (Integer)result4.get('minPrice');

                if(IsDropshipping != 0 && IsDropshipping != null){

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
                    List<BranchBook__c> spaceBranchBook = IF_GetUsedBookInfo.getUsedBookInfo(BBV.Name, BBV.ISBN13__c, String.valueOf(spaceMinPrice), BBV.Book__c);

                    for(BranchBook__c SBB : spaceBranchBook){
                        ListBranchBook.add(SBB);
                    }
                }
            }
        }
        insert ListBranchBook;
    }

}