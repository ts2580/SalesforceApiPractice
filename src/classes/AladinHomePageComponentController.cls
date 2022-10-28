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
                                                ORDER BY SUM(f_MinPrice__c) DESC];

        for(AggregateResult ABN : AggregateBranchName){

            List<String> BranchIdAndTotalPrice = new List<String>();
            BranchIdAndTotalPrice.add(String.valueOf(ABN.get('TotalPrice')));
            BranchIdAndTotalPrice.add(String.valueOf(ABN.get('Branch__c')));

            MapBranch.put(String.valueOf(ABN.get('BranchName__c')), BranchIdAndTotalPrice);
        }

        return MapBranch;
    }

    @AuraEnabled
    public static Map<String, List<String>> TestMapData(){
        Map<String, List<String>> mapCustomer = new Map <String, List<String>>();
        mapCustomer.put('Sample', new List<String> {'aaaaa','aaaaa'});
        mapCustomer.put('Sample2', new List<String> {'bbbbb','bbbbb'});
        mapCustomer.put('Sample3', new List<String> {'ccccc','ccccc'});
        mapCustomer.put('Sample4', new List<String> {'ddddd','dddd'});
        return mapCustomer;
    }

}