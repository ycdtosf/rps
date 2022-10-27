public class API {
   
    @AuraEnabled
    public static List<Move__c> getMoves() {
        Map<String, Object> inputs = new Map<String, Object>();
        Flow.Interview.Get_Moves f = new Flow.Interview.Get_Moves(inputs);
        f.start();
        return (List<Move__c>)f.getVariableValue('records');
    }

    /*
    CreateGameRequest cgr = new CreateGameRequest();
    cgr.userId = [select Id from User where FirstName = 'User' limit 1].Id;
    cgr.opponentUserId = [select Id from User where LastName = 'U2' limit 1].Id;
    cgr.moveId = [select Id from Move__c where Name = 'Paper' limit 1].Id;
    API.createGame(cgr);
    */
    @AuraEnabled   
    public static GameData createGame(CreateGameRequest createGameRequest) {
        system.debug(createGameRequest);
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('createGameRequest', createGameRequest);
        Flow.Interview.Create_Game f = new Flow.Interview.Create_Game(inputs);
        f.start();
        return (GameData)f.getVariableValue('gameData'); 
    }

    @AuraEnabled
    public static GameData getGameById(Id gameId) {
        
        List<PlayerMove__c> playerMoves = [select
            Id,
            Player__r.Game__c,
            Player__r.Game__r.Rematch__c,
            Player__r.Game__r.CreatedDate,
            Player__r.Game__r.LastModifiedDate,
            Player__r.Game__r.Status__c,
            Player__r.Id,
            Player__r.User__c,
            Player__r.Status__c,
            Player__r.User__r.Name,
            Move__r.Id,
            Move__r.Name
            from PlayerMove__c
            where Player__r.Game__c = :gameId
            order by Game__c, Player__r.IsCurrentUser__c desc
        ];

        return initGameData(playerMoves);

    }
        
    private static GameData initGameData(List<PlayerMove__c> playerMoves) {
        GameData gameData = new GameData();
        gameData.gameId = playerMoves[0].Player__r.Game__c;
        gameData.rematchGameId = playerMoves[0].Player__r.Game__r.Rematch__c;
        gameData.createdDate = playerMoves[0].Player__r.Game__r.CreatedDate;
        gameData.modifiedDate = playerMoves[0].Player__r.Game__r.LastModifiedDate;
        gameData.status = playerMoves[0].Player__r.Game__r.Status__c;
        gameData.currentPlayer = initPlayerData(playerMoves[0]);
        gameData.opponent = initPlayerData(playerMoves[1]);
        if(gameData.status != 'Complete') gameData.opponent.move = null;
        return gameData;
    }

    private static PlayerData initPlayerData(PlayerMove__c playerMove) {
        PlayerData playerData = new PlayerData();
        playerData.playerId = playerMove.Player__c;
        playerData.userId = playerMove.Player__r.User__c;
        playerData.status = playerMove.Player__r.Status__c;
        playerData.name = playerMove.Player__r.User__r.Name;
        playerData.move = playerMove.Move__r.Name;
        return playerData;
    }

    /*
    GetGameRequest ggr = new GetGameRequest();
    ggr.userId = '0052100000ArkRMAAZ';
    API.getGamesByUser(ggr);
    */
    @AuraEnabled
    public static List<GameData> getGamesByUser(GetGameRequest getGameRequest) {

        List<Player__c> players = [select Id, Game__c from Player__c where User__c = :getGameRequest.userId order by Game__c desc];

        Set<Id> gameIds = new Set<Id>();
        for(Player__c p : players) gameIds.add(p.Game__c);

        List<PlayerMove__c> playerMoves = [select
            Id,
            Player__r.Game__c,
            Player__r.Game__r.Rematch__c,
            Player__r.Game__r.CreatedDate,
            Player__r.Game__r.LastModifiedDate,
            Player__r.Game__r.Status__c,
            Player__r.Id,
            Player__r.User__c,
            Player__r.Status__c,
            Player__r.User__r.Name,
            Move__r.Id,
            Move__r.Name
            from PlayerMove__c
            where Player__r.Game__c = :gameIds
            order by Game__c, Player__r.IsCurrentUser__c desc
        ];

        List<GameData> gameDatas = new List<GameData>();

        Integer idx = 0;
        List<PlayerMove__c> tempPlayerMoves;

        for(PlayerMove__c playerMove : playerMoves) {
            if(Math.mod(idx, 2) == 0) {
                tempPlayerMoves = new List<PlayerMove__c>();
                tempPlayerMoves.add(playerMove);
            }
            else {
                tempPlayerMoves.add(playerMove);
                gameDatas.add(initGameData(tempPlayerMoves));
            }
            idx++;
        }

        return gameDatas;

        /*

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('getGameRequest', getGameRequest);
        system.debug(getGameRequest);
        Flow.Interview.Get_Games_By_User f = new Flow.Interview.Get_Games_By_User(inputs);
        f.start();
        return (List<GameData>)f.getVariableValue('gameDataCollection');

        */
    }

}
