/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class AladinBatch_2_sc implements Schedulable, Database.AllowsCallouts{


    /*
    String CRON_EXP = '00 05 22 * * ? *';
    System.schedule('2. Insert total price.', CRON_EXP, new AladinBatch_2_sc());
    */
    public void execute(SchedulableContext sc) {

        String StringPrice = null;
        String FormattingPrice = null;
        String FormattedPrice = null;

        List<AggregateResult> AggregateBranchName = [SELECT Branch__c, SUM(f_MinPrice__c) TotalPrice
        FROM BranchBook__c
        GROUP BY Branch__c
        ORDER BY SUM(f_MinPrice__c) DESC];

        Map<Id, String> MapBranch = new Map<Id, String>();

        for(AggregateResult ABN : AggregateBranchName){
            MapBranch.put(String.valueOf(ABN.get('Branch__c')), String.valueOf(ABN.get('TotalPrice')));
        }

        List<Branch__c> ListBranch = [SELECT Id, Name, TotalPrice__c FROM Branch__c];

        for(Branch__c B : ListBranch){

            StringPrice = MapBranch.get(B.Id);
            FormattingPrice = ( Decimal.valueOf(StringPrice.trim()==''?'0':StringPrice).setScale(2)).format();
            FormattedPrice = FormattingPrice.substring(0,FormattingPrice.length())+'원';
            B.TotalPrice__c = FormattedPrice;
        }

        update ListBranch;

    }

}