/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class IF_GetBookInfo {

    private static final String BASE_URL = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?';

    private static String GetUrl(String searchWord) {
        Map<String, String> paramMap = new Map<String, String>();
        paramMap.put('ttbkey', 'ttbtrstyq0151001');
        paramMap.put('Query', EncodingUtil.urlEncode(searchWord, 'UTF-8'));
        paramMap.put('Sort', 'PublishTime');
        paramMap.put('QueryType', 'Title');
        paramMap.put('MaxResults', '50');
        paramMap.put('start', '1');
        paramMap.put('Cover', 'Big');
        paramMap.put('SearchTarget', 'Book');
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


    public static void getBookInfo(Integer StartNum, Integer ENDNum){

        List<Book__c> ListBooks = [
                SELECT Id, Name, Volume__c, Type__c, Cover__c, f_Order__c
                FROM Book__c
                WHERE f_Order__c >=: StartNum
                AND f_Order__c <: ENDNum];
        List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();
        Integer i = 1;

        for(Book__c LB : ListBooks){

            String searchWord = LB.Name;
            Integer TotalVolume;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(GetUrl(searchWord));
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            List<Object> Books = new List<Object>();
            Integer price;


            if (response.getStatusCode() == 200) {

                Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Books = (List<Object>) responseBooks.get('item');

                System.debug(Books);

                if(Books.isEmpty()){
                    LB.HasNoResult__c = true;
                }else{
                    TotalVolume = Books.size();
                    for(Object objectBook : Books){

                        Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));

                        BookByVolume__c BookByVolume = new BookByVolume__c();
                        String BookName = (String)result1.get('title');
                        if(BookName.length() > 70){
                            BookName = BookName.substring(0, 50);
                        }
                        BookByVolume.Name = BookName;
                        BookByVolume.ISBN13__c = (String) result1.get('isbn13');
                        price = (Integer) result1.get('priceSales');
                        BookByVolume.Price__c = String.valueOf(price);

                        String NormalCover = (String) result1.get('cover');

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