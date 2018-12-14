trigger CaseTrigger on Case (Before update, After update) {

system.debug('データチェック'+Trigger.old);
for (case rec: Trigger.new) {
    system.debug('チェック'+rec.KTypeChg__c);
}

/**
List<Account> customers = new List<Account>();

for(Case o:Trigger.new) {
Account a = [SELECT Id, IsPartner From Account WHERE ID = :o.AccountId];
a.IsPartner= true;
customers.add(a);
}
Database.update(customers, false);



    Case updateCase = null;

    for (Case rec: Trigger.new) {

        system.debug('rec.ContactId = ' + rec.ContactId);
                system.debug('UserInfo.getUserId() = ' + UserInfo.getUserId());
                system.debug(Userinfo.getUserType());

                User userRec = [Select ContactId, username From User Where Id = :UserInfo.getUserId()];

        //if (rec.ContactId == UserInfo.getUserId()) {
        //if (rec.ContactId == userRec.ContactId) {
        if (Trigger.isUpdate && rec.ApexFlg2__c) {
            system.debug('動きました');
            //updateCase = new Case(Id = rec.Id, ContactId = null, AccountId = null, ApexFlg2__c = false);
            rec.ContactId = null;
            rec.AccountId = null;
            rec.ApexFlg2__c = false;
        }
        if (Trigger.isInsert && rec.ContactId == null && userRec.username == 'toshi_hamanop2@densan-s.co.jp') {
            rec.ApexFlg__c = true;
        }
        
        //} else {

            //system.debug('一致しなかった');
        //}
    }

    //if (updateCase != null) update updateCase;
*/
}