/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class AladinBatch_sc implements Schedulable, Database.AllowsCallouts{

    // String CRON_EXP = '0 0 8 * * ? *';
    // String CRON_EXP_TEST = '0 30 17 * * ? *';
    // System.schedule('AladinBatch_sc Schdule [매일 8시]', CRON_EXP_TEST, new AladinBatch_sc());
    public void execute(SchedulableContext sc) {

        String CRON_EXP_1 = '0 ';
        String CRON_EXP_2 = ' 13 * * ? *';
        String CRON_EXP;

        for(Integer i = 0; i < 5; i++){
            CRON_EXP = CRON_EXP_1 + String.valueOf(i*2) +CRON_EXP_2;

            switch on i {
                when 0 {
                    System.schedule('AladinGetBookInfo_'+ String.valueOf(i+1) +'_sc Schdule',
                            CRON_EXP, new AladinGetBookInfo_1_sc());
                }
                when 1 {
                    System.schedule('AladinGetBookInfo_'+ String.valueOf(i+1) +'_sc Schdule',
                            CRON_EXP, new AladinGetBookInfo_2_sc());
                }
                when 2 {
                    System.schedule('AladinGetBookInfo_'+ String.valueOf(i+1) +'_sc Schdule',
                            CRON_EXP, new AladinGetBookInfo_3_sc());
                }

                when 3 {
                    System.schedule('AladinGetBookInfo_'+ String.valueOf(i+1) +'_sc Schdule',
                            CRON_EXP, new AladinGetBookInfo_4_sc());
                }

                when 4 {
                    System.schedule('AladinGetBookInfo_'+ String.valueOf(i+1) +'_sc Schdule',
                            CRON_EXP, new AladinGetBookInfo_5_sc());

                }
                when else {

                }
            }
        }



    }
}