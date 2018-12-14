trigger Trgr_ClientBasic on ClientBaseInfo__c (before insert, before update, before delete) {
    system.debug('基本情報トリガー起動確認');
}