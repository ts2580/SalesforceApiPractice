/**
 * Created by 한성진 on 2022-10-28.
 */

public with sharing class IF_InsertLatestBook {

    public static void insertLatestBook(Integer StartNum, Integer ENDNum){

        IF_Util IF_Util = new IF_Util();
        Map<String, Object> BookMap = new Map<String, Object>();
        List<BookByVolume__c> ListBooks = [
                SELECT Id, ISBN13__c, Name, Price__c, Cover__c
                FROM BookByVolume__c
                WHERE f_order__c >=: StartNum
                AND f_order__c <: ENDNum];

        for(BookByVolume__c BBV : ListBooks){

            Integer TotalVolume;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(IF_Util.getBookInfoURL(BBV.Name));
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            List<Object> Books = new List<Object>();
            Integer price;


            if (response.getStatusCode() == 200) {

                Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Books = (List<Object>) responseBooks.get('item');

                TotalVolume = Books.size();
                for(Object objectBook : Books){

                    BookMap = (Map<String, Object>) objectBook;

                    String BookName = (String)BookMap.get('title');
                    if(BookName.length() > 70){
                        BookName = BookName.substring(0, 50);
                    }
                    BBV.Name = BookName;
                    BBV.ISBN13__c = (String) BookMap.get('isbn13');
                    price = (Integer) BookMap.get('priceSales');
                    BBV.Price__c = String.valueOf(price);

                    String NormalCover = (String) BookMap.get('cover');

                    BBV.Cover__c = NormalCover.replace('cover','cover500');
                }
            }
        }
        update ListBooks;
    }
}