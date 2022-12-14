/**
 * Created by 한성진 on 2022-12-14.
 */

import { LightningElement } from 'lwc';

export default class HelloWebComponent extends LightningElement {
    greeting = 'Trailblazer';

    handleGreetingChange(event) {
    	this.greeting = event.target.value;
    }

    currentDate = new Date().toDateString();
    get capitalizedGreeting() {
    	return `Hello ${this.greeting.toUpperCase()}!`;
    }

}