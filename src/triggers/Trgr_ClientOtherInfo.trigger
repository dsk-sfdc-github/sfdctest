trigger Trgr_ClientOtherInfo on ClientOtherInfo__c (before insert, before update, before delete) {
    system.debug('小情報起動確認');
}