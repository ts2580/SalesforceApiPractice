/**
 * Created by 한성진 on 2022-10-18.
 */

public with sharing class DaekyoOptionController {

    @AuraEnabled
    public static Option__c GetOption(String recordId){

        IF_Util IF_Util = new IF_Util();

        List<String> listOptionFields = IF_Util.getAllFields('Option__c');

        String query = '';
        query += ' SELECT '+ String.join(listOptionFields, ', ');
        query += ' FROM Option__c ';
        query += ' WHERE Id =: recordId ';

        List<Option__c> listOption = Database.query(query);

        Option__c ObjectOption = null;

        if(!listOption.isEmpty()){
            ObjectOption = listOption.get(0);
        }

        Map<String, List<String>> MapOptions = new Map<String, List<String>>();
        List<String> BranchIdAndTotalPrice = new List<String>();

        for(AggregateResult ABN : AggregateBranchName){


            BranchIdAndTotalPrice.add(String.valueOf(ABN.get('TotalPrice')));
            BranchIdAndTotalPrice.add(String.valueOf(ABN.get('Branch__c')));

            MapOptions.put(String.valueOf(ABN.get('BranchName__c')), BranchIdAndTotalPrice);
        }



        return ObjectOption;

    }

}