public class CreateGameRequest {
    @AuraEnabled public Id userId;
    @AuraEnabled public Id opponentUserId;
    @AuraEnabled public Id moveId;
    @AuraEnabled public Boolean isRematch;
    @AuraEnabled public Id previousMatchId;
}
