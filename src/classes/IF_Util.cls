/**
 * Created by 한성진 on 2022-10-18.
 */

public with sharing class IF_Util {

    public String getBookInfoURL(String searchWord) {

        String BASE_URL = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?';

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


    public String getDropshippingUsedBookURL(String ISBN13) {

        String BASE_URL = 'http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?';

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

    public String getUsedBookInfoURL(String ISBN13) {

        String BASE_URL = 'http://www.aladin.co.kr/ttb/api/ItemOffStoreList.aspx?';

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

    public Map<String, Id> getBranch() {

        Map<String, Id> MapBranchNameId = new Map<String, Id>();

        List<Branch__c> ListBranch = [SELECT Id, Name FROM Branch__c];

        for(Branch__c B : ListBranch){
            MapBranchNameId.put(B.Name, B.Id);
        }

        return MapBranchNameId;
    }

    public List<String> getAllFields(String strObjectName){
        SObjectType objType = Schema.getGlobalDescribe().get(strObjectName);
        Map<String,Schema.SObjectField> mapFields = objType.getDescribe().fields.getMap();
        List<String> listFields = new List<String>();

        for(String key : mapFields.keySet()){
            listFields.add(String.valueOf(mapFields.get(key)));
        }

        return listFields;
    }

}