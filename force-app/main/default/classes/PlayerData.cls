public class PlayerData {
    @AuraEnabled public Id playerId { get; set; }
    @AuraEnabled public Id userId { get; set; }
    @AuraEnabled public String status { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String move { get; set; }
}
