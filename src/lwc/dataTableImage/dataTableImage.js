/**
 * Created by 한성진 on 2022-11-24.
 */

import { LightningElement, api } from 'lwc';

export default class ImageControl extends LightningElement {
    @api url;
    @api altText;
}