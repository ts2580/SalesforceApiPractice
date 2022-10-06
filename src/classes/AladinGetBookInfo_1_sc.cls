/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class AladinGetBookInfo_1_sc implements Schedulable, Database.AllowsCallouts{

    // String CRON_EXP = '0 0 8 * * ? *';
    // String CRON_EXP_TEST = '0 30 17 * * ? *';
    // System.schedule('AladinGetBookInfo_1_sc Schdule [매일 8시]', CRON_EXP_TEST, new AladinGetBookInfo_1_sc());
    public void execute(SchedulableContext sc) {

        // 삭제구문 만들기

        List<BookByVolume__c> BookByVolume= [SELECT Id FROM BookByVolume__c];

        Delete BookByVolume;

        AladinApiController.getBookInfo(1, 50);

    }
}