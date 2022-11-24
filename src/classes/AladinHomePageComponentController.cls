/**
 * Created by 한성진 on 2022-10-18.
 */

public with sharing class AladinHomePageComponentController {

    @AuraEnabled
    public static Map<String, List<String>> getBranch(){

        Map<String, List<String>> MapBranch = new Map<String, List<String>>();

        List<AggregateResult> AggregateBranchName = [SELECT BranchName__c, Branch__c, SUM(f_MinPrice__c) TotalPrice
                                                FROM BranchBook__c
                                                GROUP BY BranchName__c, Branch__c
                                                ORDER BY BranchName__c DESC];

        for(AggregateResult ABN : AggregateBranchName){

            List<String> BranchIdAndTotalPrice = new List<String>();
            BranchIdAndTotalPrice.add(String.valueOf(ABN.get('TotalPrice')));
            BranchIdAndTotalPrice.add(String.valueOf(ABN.get('Branch__c')));

            MapBranch.put(String.valueOf(ABN.get('BranchName__c')), BranchIdAndTotalPrice);
        }

        return MapBranch;
    }

    @AuraEnabled(Cacheable=true)
    public static List<bookByVolumeExt__x> getBook(Id recordId){

        List<bookByVolumeExt__x> listBookByVolume = [SELECT name__c, ispurched__c, Id, cover__c, price__c, volume__c
        FROM bookByVolumeExt__x
        WHERE book__c =: recordId];

        return listBookByVolume;
    }

}