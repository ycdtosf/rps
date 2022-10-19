public with sharing class lwcRpsArena {
    
    public class NewGameRequest {
        @AuraEnabled public Id userId;
        @AuraEnabled public Id opponentUserId;
        @AuraEnabled public Id moveId;
        @AuraEnabled public Boolean isRematch;
        @AuraEnabled public Id previousMatchId;
    }

    public static GameData newGame(NewGameRequest newGameRequest) {
        return null;
    }

    @AuraEnabled
    public static List<GameData> queryGamesByUser(Id userId) {
       
        List<Player__c> players = [select 
            Game__c
            from 
            Player__c 
            where User__c = :userId
        ];

        Set<Id> gameIds = new Set<Id>();
        for(Player__c p : players) gameIds.add(p.Game__c);

        List<Game__c> games = [select 
            Id,
            CreatedDate,
            LastModifiedDate,
            Status__c,
            (select Id, Status__c, Move__r.Name, User__c, User__r.Name from Players__r)
            from Game__c
            where Id = :gameIds
            order by Status__c, CreatedDate
        ];

        List<GameData> gameData = new List<GameData>();

        Set<Id> playersWithoutMoves = new Set<Id>();

        for(Game__c g : games) {
            
            GameData gd = new gameData();
            gd.gameId = g.Id;
            gd.createdDate = g.CreatedDate;
            gd.modifiedDate = g.LastModifiedDate;
            gd.status = g.Status__c;

            for(Player__c p : g.Players__r) {
                PlayerData pd = new PlayerData();
                pd.playerId = p.Id;
                pd.userId = p.User__c;
                pd.name = p.User__r.Name;
                pd.status = p.Status__c;
                if(p.Move__r != null) pd.move = p.Move__r.Name;
                else playersWithoutMoves.add(p.Id);
                if(pd.userId == userId) gd.currentPlayer = pd;
                else gd.opponent = pd;
            }

            if(g.Status__c == 'Pending') {
                gd.outcome = 'PENDING';
                gd.outcomeLabel = 'VS';
            }
            else if(g.Status__c == 'Tie') {
                gd.outcome = 'TIE';
                gd.outcomeLabel = 'TIED';
            }
            else if(g.Status__c == 'Completed') {
                if(gd.currentPlayer.status == 'Winner') {
                    gd.outcome = 'WIN';
                    gd.outcomeLabel = 'DEFEATED';
                }
                else if(gd.currentPlayer.status == 'Loser') {
                    gd.outcome = 'LOSE';
                    gd.outcomeLabel = 'DEFEATED BY';
                }
            }

            gameData.add(gd);
        }

        if(!playersWithoutMoves.isEmpty()) {
            List<PlayerMove__c> playerMoves = [select Id, Move__c, Player__c, Move__r.Name from PlayerMove__c where Player__c = :playersWithoutMoves];
            for(gameData gd : gameData) {
                for(PlayerMove__c pm : playerMoves) {
                    if(pm.Player__c == gd.currentPlayer.playerId) {
                        gd.currentPlayer.move = pm.Move__r.Name;
                        break;
                    }
                    if(pm.Player__c == gd.opponent.playerId) {
                        gd.opponent.move = pm.Move__r.Name;
                        break;
                    }
                }
            }
        }

        return gameData;

    }

    public class GameData {
        @AuraEnabled public Id gameId { get; set; }
        @AuraEnabled public DateTime createdDate { get; set; }
        @AuraEnabled public DateTime modifiedDate { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String outcome { get; set; }
        @AuraEnabled public String outcomeLabel { get; set; }
        @AuraEnabled public PlayerData currentPlayer { get; set; }
        @AuraEnabled public PlayerData opponent { get; set; }
    }

    public class PlayerData {
        @AuraEnabled public Id playerId { get; set; }
        @AuraEnabled public Id userId { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String move { get; set; }
    }
    
}
