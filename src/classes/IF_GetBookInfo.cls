/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class IF_GetBookInfo {

    public static void getBookInfo(Integer StartNum, Integer ENDNum){

        IF_Util IF_Util = new IF_Util();
        Map<String, Object> BookMap = new Map<String, Object>();
        List<Book__c> ListBooks = [
                SELECT Id, Name, Volume__c, Type__c, Cover__c, f_Order__c
                FROM Book__c
                WHERE f_Order__c >=: StartNum
                AND f_Order__c <: ENDNum];
        List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();

        for(Book__c LB : ListBooks){

            Integer TotalVolume;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(IF_Util.getBookInfoURL(LB.Name));
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            List<Object> Books = new List<Object>();
            Integer price;


            if (response.getStatusCode() == 200) {

                Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Books = (List<Object>) responseBooks.get('item');

                if(Books.isEmpty()){
                    LB.HasNoResult__c = true;
                }else{
                    TotalVolume = Books.size();
                    for(Object objectBook : Books){

                        BookMap = (Map<String, Object>) objectBook;

                        BookByVolume__c BookByVolume = new BookByVolume__c();
                        String BookName = (String)BookMap.get('title');
                        if(BookName.length() > 70){
                            BookName = BookName.substring(0, 50);
                        }
                        BookByVolume.Name = BookName;
                        BookByVolume.ISBN13__c = (String) BookMap.get('isbn13');
                        price = (Integer) BookMap.get('priceSales');
                        BookByVolume.Price__c = String.valueOf(price);

                        String NormalCover = (String) BookMap.get('cover');

                        BookByVolume.Cover__c = NormalCover.replace('cover','cover500');
                        BookByVolume.Book__c = LB.Id;

                        if(LB.Cover__c == null){
                            LB.Cover__c = BookByVolume.Cover__c;
                        }

                        if(LB.Type__c == '만화' || LB.Type__c == '라노벨'){
                            BookByVolume.Volume__c = String.valueOf(TotalVolume);
                            TotalVolume--;
                        }

                        String searchName = BookByVolume.Name;
                        Boolean result = searchName.contains(LB.Name);

                        if(result){
                            ListBookByVolume.add(BookByVolume);
                        }
                    }
                    LB.TotalVolume__c = String.valueOf(TotalVolume);
                }
            }
        }

        update ListBooks;
        insert ListBookByVolume;
    }

}