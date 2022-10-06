/**
 * Created by SUNGJIN on 2022-10-01.
 */

public with sharing class AladinGetBookInfo_3_sc implements Schedulable, Database.AllowsCallouts{

    public void execute(SchedulableContext sc) {

        AladinApiController.getBookInfo(100, 150);


    }
}