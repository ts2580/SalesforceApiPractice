/**
 * Created by 한성진 on 2022-12-09.
 */

public with sharing class IF_GetDropshippingUsedBookQuable implements Queueable{

    // 근데 애초에 external에 있는 데이터 5천개 이상 한꺼번에 못가져와서 못씀.
    // 연습했다고 생각하지뭐...

    private final List<BookByVolume__c> listBooks;

    public IF_GetDropshippingUsedBookQuable(List<BookByVolume__c> listBooks){
        this.listBooks = listBooks;
    }

    public void execute(QueueableContext context) {

        IF_Util IF_Util = new IF_Util();

        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();
        List<Object> Books = new List<Object>();

        Map<String, Id> BranchMap = IF_Util.getBranch();
        Map<String, Object> aladinUsed = new Map<String, Object>();
        Map<String, Object> spaceUsed = new Map<String, Object>();
        Map<String, String> ParamMap = new Map<String, String>();

        for(BookByVolume__c BBV : listBooks){

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(IF_Util.getDropshippingUsedBookURL(BBV.ISBN13__c));
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {

                Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Books = (List<Object>) responseBooks.get('item');

                aladinUsed = (Map<String, Object>) Books[0];
                aladinUsed = (Map<String, Object>) aladinUsed.get('subInfo');
                aladinUsed = (Map<String, Object>) aladinUsed.get('usedList');
                spaceUsed = aladinUsed;

                aladinUsed = (Map<String, Object>) aladinUsed.get('aladinUsed');

                Integer IsDropShipping = (Integer)aladinUsed.get('itemCount');
                Integer minPrice = (Integer)aladinUsed.get('minPrice');

                if(IsDropShipping != 0 && IsDropShipping != null){

                    BranchBook__c BranchBook = new BranchBook__c();
                    BranchBook.Name = BBV.Name;
                    BranchBook.Branch__c = BranchMap.get('알라딘 직배송');
                    BranchBook.BranchName__c = '알라딘 직배송';
                    BranchBook.Book__c = BBV.Book__c;

                    String link = (String) aladinUsed.get('link');
                    BranchBook.BookLink__c = link.replace('amp;','');

                    BranchBook.MinPrice__c = String.valueOf(minPrice);
                    ListBranchBook.add(BranchBook);
                }

                spaceUsed = (Map<String, Object>) spaceUsed.get('spaceUsed');

                Integer IsThereSpaceUsed = (Integer)spaceUsed.get('itemCount');
                Integer spaceMinPrice = (Integer)spaceUsed.get('minPrice');

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