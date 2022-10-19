/**
 * Created by 한성진 on 2022-10-18.
 */

public with sharing class AladinHomePageComponentController {

    @AuraEnabled
    public static Map<String, List<String>> getBranchBook(){

        Map<String, List<String>> MapBook = new Map<String, List<String>>();
        List<BranchBook__c> ListBranchBook = new List<BranchBook__c>();


        String BranchName;
        List<AggregateResult> ListBranchName = [SELECT BranchName__c, SUM(f_MinPrice__c)
                                                FROM BranchBook__c
                                                GROUP BY BranchName__c
                                                ORDER BY SUM(f_MinPrice__c) DESC];

        for(AggregateResult LBN : ListBranchName){

            List<String> BranchBooks = new List<String>();
            BranchName = String.valueOf(LBN.get('BranchName__c'));
            ListBranchBook = [SELECT Name FROM BranchBook__c WHERE BranchName__c =: BranchName];

            for(BranchBook__c LBB : ListBranchBook){
                BranchBooks.add(LBB.Name);
            }

            MapBook.put(BranchName, BranchBooks);
        }

        return MapBook;
    }

    @AuraEnabled
    public static Map<String, List<String>> fetchMapData(){
        Map<String, List<String>> mapCustomer = new Map <String, List<String>>();
        mapCustomer.put('Sample', new List<String> {'aaaaa','aaaaa'});
        mapCustomer.put('Sample2', new List<String> {'bbbbb','bbbbb'});
        mapCustomer.put('Sample3', new List<String> {'ccccc','ccccc'});
        mapCustomer.put('Sample4', new List<String> {'ddddd','dddd'});
        return mapCustomer;
    }

}