import { LightningElement, api, track } from 'lwc';
import getUserId from '@salesforce/user/Id';
import getMoves from '@salesforce/apex/API.getMoves'; 
import getGamesByUser from '@salesforce/apex/API.getGamesByUser';

export default class RpsArena extends LightningElement {
    
    userId = getUserId;
    inited = false;
    moves;
    @track games;

    connectedCallback() {
        this.init();
    }

    async init() {
        try {
            this.moves = await getMoves();
            this.games = await getGamesByUser({ 
                getGameRequest : { userId : this.userId }
            });
        }
        catch(error) {
            console.log(error);
        }
        finally {
            console.log('RpsArena component initialized.');
            this.inited = true;
        }
    }

}