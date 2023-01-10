/************************************************************************************
* File Name   : HierarchyController2.class
* Author      : 한성진
* Date        : 2023.01.05
* Class       :
* Target      :
* Description :  조직도 컴포넌트 컨트롤러. 재귀 형식으로
* Modification Log
* ===================================================================================
* Ver      Date            Author              Modification
* ===================================================================================
1.0      2023.01.05        한성진               Create
<*************************************************************************************/

public with sharing class HierarchyController2 {

    private static List<OrgTest__c> listOrg;
    private static Map<Id, OrgTest__c> mapOrg;
    private static final List<WrapperItem> listOrgWrapper = new List<WrapperItem>();

    private static void getOrg() {
        listOrg = [
                SELECT  Id , Name, RecordType.Name, UpperOrganization__c,
                (
                        SELECT  Id , Name, RecordType.Name, UpperOrganization__c
                        FROM    Org_UpperOrg__r
                )
                FROM    OrgTest__c
                WHERE   UpperOrganization__c = NULL
        ];

        mapOrg = new Map<Id , OrgTest__c>([
                SELECT  Id , Name, RecordType.Name, UpperOrganization__c,
                (
                        SELECT Id , Name, RecordType.Name, UpperOrganization__c
                        FROM Org_UpperOrg__r
                )
                FROM    OrgTest__c
        ]);

    }

    private static WrapperItem makingTree(String orgId){

        WrapperItem oWrapper = new WrapperItem();
        oWrapper.name = mapOrg.get(orgId).Name;
        oWrapper.Id = mapOrg.get(orgId).Id;
        oWrapper.type = mapOrg.get(orgId).RecordType.Name;

        List<WrapperItem> listItems = new List<WrapperItem>();
        for(OrgTest__c objOrg : mapOrg.get(orgId).Org_UpperOrg__r){
            listItems.add(makingTree(objOrg.Id));
        }

        oWrapper.items = listItems;

        if(mapOrg.get(orgId).UpperOrganization__c == null){
            listOrgWrapper.add(oWrapper);
        }

        return oWrapper;
    }

    @AuraEnabled(Cacheable=true)
    public static String getHierarchy(){

        String regExp = '"items" : \\[ \\],';
        String JSONTree = null;

        getOrg();

        for(OrgTest__c objOrg : listOrg){
            makingTree(objOrg.Id);
        }

        JSONTree = JSON.serializePretty(listOrgWrapper, true).replaceAll(regExp,'');

        return JSONTree;

    }

    @AuraEnabled
    public static List<ListView> getOrgListviewId(){

        List<ListView> listviews = [
                SELECT  Id, Name
                FROM    ListView
                WHERE   SobjectType = 'OrgTest__c'
        ];

        return listviews;
    }

    private class WrapperItem{
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public List<WrapperItem> items {get;set;}
    }

}