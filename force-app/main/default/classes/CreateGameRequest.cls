public class CreateGameRequest {
    @AuraEnabled public Id userId { get; set; }
    @AuraEnabled public Id opponentUserId { get; set; }
    @AuraEnabled public Id moveId { get; set; }
    @AuraEnabled public Boolean isRematch { get; set; }
    @AuraEnabled public Id previousGameId { get; set; }
}
