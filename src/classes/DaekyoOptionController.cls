/**
 * Created by 한성진 on 2022-10-18.
 */

public with sharing class DaekyoOptionController {

    @AuraEnabled
    public static Map<String, List<DetailedOption__c>> GetOption(String recordId){

        Map<String, List<DetailedOption__c>> MapObject = new Map<String, List<DetailedOption__c>>();


        IF_Util IF_Util = new IF_Util();

        List<String> listOptionFields = IF_Util.getAllFields('Option__c');

        String query = '';
        query += ' SELECT '+ String.join(listOptionFields, ', ');
        query += ' FROM Option__c ';
        query += ' WHERE DaekyoProduct__c =: recordId Order By Name';

        List<Option__c> listOption = Database.query(query);
        List<DetailedOption__c> listDetailedOption = new List<DetailedOption__c>();

        for(Option__c Option : listOption){
            listDetailedOption = [SELECT Id, Name, Option__c
                                  FROM DetailedOption__c
                                  WHERE Option__c =: Option.Id
                                  ORDER BY Name];
            MapObject.put(Option.Name, listDetailedOption);
        }

        return MapObject;

    }

}