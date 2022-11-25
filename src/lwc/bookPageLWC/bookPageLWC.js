/**
 * Created by 한성진 on 2022-11-24.
 */

import { LightningElement, wire, api } from 'lwc';
// wires the Apex method
import getBook from '@salesforce/apex/AladinHomePageComponentController.getBook';

const bookColumns =  [
    { label: '제목', fieldName: 'Name__c', type: 'text'},
    { label: '구매여부', fieldName: 'IsPurchased__c', type: 'boolean'},
    { label: '가격', fieldName: 'Price__c', type: 'text'},
    { label: '권', fieldName: 'Volume__c', type: 'Number'},
    { label: '표지', fieldName: 'Cover__c', type: 'url'},
];

export default class BookPageLwc extends LightningElement {

    @api recordId;
    bookColumns = bookColumns;

    @wire(getBook, {recordId : '$recordId'})
    books;
}