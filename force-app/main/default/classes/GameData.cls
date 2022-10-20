public class GameData {
    @AuraEnabled public Id gameId { get; set; }
    @AuraEnabled public Id rematchGameId { get; set; }
    @AuraEnabled public DateTime createdDate { get; set; }
    @AuraEnabled public DateTime modifiedDate { get; set; }
    @AuraEnabled public String status { get; set; }
    @AuraEnabled public PlayerData currentPlayer { get; set; }
    @AuraEnabled public PlayerData opponent { get; set; }
}
