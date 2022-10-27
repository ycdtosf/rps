import { LightningElement, api } from 'lwc';
import getUserId from '@salesforce/user/Id';
import createGame from '@salesforce/apex/API.createGame'; 

export default class RpsArenaGame extends LightningElement {
    
    userId = getUserId;
    
    _game;
    @api set game(val) {
        this._game = val;
        this.rematchGameId = this._game.rematchGameId;
    }
    get game() {
        return this._game;
    }

    @api moves;
    rematching = false;
    rematchGameId;

    winWords = ['beats', 'defeats', 'conquers', 'vanquishes', 'trounces', 'bests', 'prevails over'];
    loseWords = ['loses to', 'bows to', 'concedes to', 'defeated by', 'submits to', 'yields to', 'says uncle to'];
    tieWords = ['tie', 'stalemate', 'deadlock', 'standoff', 'draw', 'impasse'];
    vsWords = ['versus', 'fights', 'battles', 'summons', 'engages', 'confronts'];

    get containerStyle() {
        return 'slds-box slds-m-bottom_medium ' + this.outcome;
    }

    get outcome() {
        switch(this.game.status.toUpperCase()) {
            case 'PENDING':
                return 'PENDING';
            case 'TIE':
                return 'TIE';
            case 'COMPLETED':
                if(this.game.currentPlayer.status == 'Winner') return 'WIN';
                return 'LOSE';
        }
    }

    getRandomArrayElement(array) {
        return array[Math.floor(Math.random() * array.length)];
    }

    get winWord() {
        return this.getRandomArrayElement(this.winWords);
    }

    get loseWord() {
        return this.getRandomArrayElement(this.loseWords);
    }

    get tieWord() {
        return this.getRandomArrayElement(this.tieWords);
    }

    get vsWord() {
        return this.getRandomArrayElement(this.vsWords);
    }

    get outcomeBadgeLabel() {
        switch(this.outcome) {
            case 'PENDING':
                return this.vsWord.toUpperCase();
            case 'TIE':
                return this.tieWord.toUpperCase();
            case 'WIN':
                return this.winWord.toUpperCase();
            case 'LOSE':
                return this.loseWord.toUpperCase();
        }
    }

    get outcomeIcon() {
        switch(this.outcome) {
            case 'PENDING':
                return 'utility:threedots';
            case 'TIE':
                return 'utility:assignment';
            case 'WIN':
                return 'utility:check';
            case 'LOSE':
                return 'utility:close';
        }
    }

    get outcomeIconVariant() {
        switch(this.outcome) { 
            case 'PENDING':
                return 'warning';
            case 'TIE':
                return 'inverse';
            case 'WIN':
                return 'success';
            case 'LOSE':
                return 'error';
        }
    }

    get createdDateObject() {
        return new Date(game.createdDate);
    }

    get modifiedDateObject() {
        return new Date(game.modifiedDate);
    }

    get currentPlayerMoveIcon() {
        return this.getMoveIconName(this.game.currentPlayer);
    }

    get opponentMoveIcon() {
        return this.getMoveIconName(this.game.opponent);
    }

    get rockIconName() {
        return 'utility:record';
    }

    get paperIconName() {
        return 'utility:page';
    }

    get scissorsIconName() {
        return 'utility:cut';
    }

    get cancelIconName() {
        return 'utility:clear';
    }

    getMoveIconName(player) {
        if(player.move === undefined) {
            if(player.userId === this.userId) {
                return null;
            }
            else {
                return 'utility:question';
            }
        }
        if(player.move.toLowerCase() === 'rock') return this.rockIconName;
        if(player.move.toLowerCase() === 'paper') return this.paperIconName;
        if(player.move.toLowerCase() === 'scissors') return this.scissorsIconName;
    }

    handleCurrentPlayerButtonEnter(e) {
        e.target.label = "DAT'S YOU!";
    }

    handleCurrentPlayerButtonLeave(e) {
        e.target.label = this.game.currentPlayer.name;
    }

    handleOpponentButtonEnter(e) {
        if(this.outcome === 'PENDING' || this.rematchGameId !== undefined) return;
        e.target.label = "REMATCH?";
    }

    handleOpponentButtonLeave(e) {
        e.target.label = this.game.opponent.name;
    }

    handleOpponentButtonClick(e) {
        if(this.outcome === 'PENDING' || this.rematchGameId !== undefined) return;
        this.rematching = true;
    }

    findMoveByName(moveName) {
        return this.moves.find((element) => {
            return element.Name.toLowerCase() === moveName;
        });
    }

    async rematch(e) {
        let move = this.findMoveByName(e.target.dataset.moveName);
        await this.call_createGame(move.Id);
    }

    unrematch(e) {
        this.rematching = false;
    }

    async call_createGame(moveId) {
        try {
            let gameData = await createGame({ 
                createGameRequest : { 
                    userId : this.userId,
                    opponentUserId : this.game.opponent.userId,
                    moveId : moveId,
                    isRematch : true,
                    previousGameId : this.game.gameId
                }
            });
            this.rematchGameId = gameData.gameId;
            this.unrematch();
            let newGameData = JSON.parse(JSON.stringify(gameData));
            newGameData.rematchGameId = this.rematchGameId;
            this.dispatchEvent(new CustomEvent("newgame", { detail: newGameData }));

            // TODO: tell rpsArena
        }
        catch(error) {
            console.log(error);
        }
        finally {
            console.log('Create Game completed.');
        }
    }

}