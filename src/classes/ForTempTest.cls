/**
 * Created by SUNGJIN on 2022-10-02.
 */

public with sharing class ForTempTest {

    public void SetPurchedBook(Integer b, Integer e){

        String purchasedBook;

        List<Book__c> ListBook = [
                SELECT Id, purchased__c
                FROM Book__c
                WHERE f_Order__c >=: b
                AND f_Order__c <: e];

        List<BookByVolume__c> ListBookByVolume;

        for (Book__c Book : ListBook){
            ListBookByVolume = [
                    SELECT Id, Volume__c
                    FROM BookByVolume__c
                    WHERE IsPurchased__c = TRUE
                    AND Book__r.Id =: Book.Id
                    ORDER BY f_Volume__c];
            purchasedBook = '';
            for(BookByVolume__c BookByVolume : ListBookByVolume){

                System.debug(purchasedBook);
                purchasedBook += BookByVolume.Volume__c + '권' + ' ';
            }
            Book.purchased__c = purchasedBook;
        }

        update ListBook;

    }

    public void FindNoSearchResult(Integer b, Integer e){

        String HasNoResult;

        List<Book__c> ListBook = [
                SELECT Id, name
                FROM Book__c
                WHERE f_Order__c >=: b
                AND f_Order__c <: e];

        List<BookByVolume__c> ListBookByVolume;

        for(Book__c book : ListBook){
            ListBookByVolume = [
                    SELECT Id, Name
                    FROM BookByVolume__c
                    WHERE Book__r.Id =: Book.Id];

            if(ListBookByVolume.isEmpty()){
                HasNoResult += '\n' + book.Name;
            }
        }

        System.debug(HasNoResult);


    }
    public void fieldSetTest(){

    }



}