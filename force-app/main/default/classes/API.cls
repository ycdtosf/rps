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

    /*
    GetGameRequest ggr = new GetGameRequest();
    ggr.userId = '0052100000ArkRMAAZ';
    API.getGamesByUser(ggr);
    */
    @AuraEnabled
    public static List<GameData> getGamesByUser(GetGameRequest getGameRequest) {
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('getGameRequest', getGameRequest);
        system.debug(getGameRequest);
        Flow.Interview.Get_Games_By_User f = new Flow.Interview.Get_Games_By_User(inputs);
        f.start();
        return (List<GameData>)f.getVariableValue('gameDataCollection');
    }

}
