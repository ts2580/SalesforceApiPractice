/************************************************************************************
* File Name   : HierarchyController.class
* Author      : 한성진
* Date        : 2022.12.19
* Class       :
* Target      :
* Description :  조직도 컴포넌트 컨트롤러.
* Modification Log
* ===================================================================================
* Ver      Date            Author              Modification
* ===================================================================================
1.0      2022.12.19        한성진               Create
<*************************************************************************************/

public with sharing class HierarchyController {

    @AuraEnabled(Cacheable=true)
    public static String getHierarchy(){

        String StringHierarchy = null;
        String regExp = '"items" : \\[ \\],';

        List<OrgTest__c> listOrg = [
                SELECT  Id , Name, RecordType.Name,
                (
                        SELECT  Id , Name, RecordType.Name
                        FROM    Org_UpperOrg__r
                )
                FROM    OrgTest__c
                WHERE   UpperOrganization__c = NULL
        ];

        Map<Id, OrgTest__c> mapOrg = new Map<Id , OrgTest__c>([
                SELECT  Id , Name, RecordType.Name,
                (
                        SELECT Id , Name, RecordType.Name
                        FROM Org_UpperOrg__r
                )
                FROM    OrgTest__c
        ]);

        List<OrgWrapper> listOrgWrapper = new List<OrgWrapper>();
        for(OrgTest__c objOrgLv1 : listOrg){
            OrgWrapper oWrapper = new OrgWrapper();
            oWrapper.name = objOrgLv1.Name;
            oWrapper.Id = objOrgLv1.Id;
            oWrapper.type = objOrgLv1.RecordType.Name;

            List<Items> listItemsLv2 = new List<Items>();
            for(OrgTest__c objOrgLv2 : objOrgLv1.Org_UpperOrg__r){
                Items objItemLv2 = new Items();
                objItemLv2.name = objOrgLv2.Name;
                objItemLv2.Id = objOrgLv2.Id;
                objItemLv2.type = objOrgLv2.RecordType.Name;

                List<Items> listItemsLv3 = new List<Items>();
                for(OrgTest__c objOrgLv3 : mapOrg.get(objOrgLv2.Id).Org_UpperOrg__r){
                    Items objItemLv3 = new Items();
                    objItemLv3.name = objOrgLv3.Name;
                    objItemLv3.Id = objOrgLv3.Id;
                    objItemLv3.type = objOrgLv3.RecordType.Name;

                    List<Items> listItemsLv4 = new List<Items>();
                    for(OrgTest__c objOrgLv4 : mapOrg.get(objOrgLv3.Id).Org_UpperOrg__r) {
                        Items objItemLv4 = new Items();
                        objItemLv4.name = objOrgLv4.Name;
                        objItemLv4.Id = objOrgLv4.Id;
                        objItemLv4.type = objOrgLv4.RecordType.Name;

                        List<Items> listItemsLv5 = new List<Items>();
                        for(OrgTest__c objOrgLv5 : mapOrg.get(objOrgLv4.Id).Org_UpperOrg__r) {
                            Items objItemLv5 = new Items();
                            objItemLv5.name = objOrgLv5.Name;
                            objItemLv5.Id = objOrgLv5.Id;
                            objItemLv5.type = objOrgLv5.RecordType.Name;

                            List<Items> listItemsLv6 = new List<Items>();
                            for(OrgTest__c objOrgLv6 : mapOrg.get(objOrgLv5.Id).Org_UpperOrg__r) {
                                Items objItemLv6 = new Items();
                                objItemLv6.name = objOrgLv6.Name;
                                objItemLv6.Id = objOrgLv6.Id;
                                objItemLv6.type = objOrgLv6.RecordType.Name;
                                listItemsLv6.add(objItemLv6);
                            }
                            objItemLv5.items = listItemsLv6;
                            listItemsLv5.add(objItemLv5);
                        }
                        objItemLv4.items = listItemsLv5;
                        listItemsLv4.add(objItemLv4);
                    }
                    objItemLv3.items = listItemsLv4;
                    listItemsLv3.add(objItemLv3);
                }
                objItemLv2.items = listItemsLv3;
                listItemsLv2.add(objItemLv2);
            }
            oWrapper.items = listItemsLv2;
            listOrgWrapper.add(oWrapper);

        }

        StringHierarchy = JSON.serializePretty(listOrgWrapper, true).replaceAll(regExp,'');

        System.debug(StringHierarchy);

        return StringHierarchy;
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

    private class OrgWrapper{
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    }

    private class Items{
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    }
}