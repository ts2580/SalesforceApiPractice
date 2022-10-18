/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class AladinBatch_sc implements Schedulable, Database.AllowsCallouts{


    // String CRON_EXP = '00 00 22 * * ? *';
    // System.schedule('AladinBatch', CRON_EXP, new AladinBatch_sc());
    public void execute(SchedulableContext sc) {

        List<BranchBook__c> BranchBook= [SELECT Id FROM BranchBook__c];

        delete BranchBook;

        Integer startNum = 1;
        Integer endNum = 50;

        for(Integer i = 2; i < 30; i++){
            IF_GetDropshippingUsedBook.getBookListInfo(startNum, endNum);
            startNum = endNum;
            endNum = 50*i;
        }
    }

}