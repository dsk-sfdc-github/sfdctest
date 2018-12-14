trigger Trgr_AccountTest on Account (before insert,before update, after insert, after update) {


    for (Account acc: Trigger.new) {
        acc.addError('This ID is already being used in Account:<a href="https://na7.salesforce.com/003A000001qScaW" target="_blank">test name</a>',FALSE);
        

    }
/**
    Contact rec =  [Select LastName From Contact Where Id = '003A000001diDp1'][0];
    rec.LastName = 'あいうえお';
    update rec;

    Contact newRec = new Contact();
    newRec.LastName = 'あかさたな';
    insert newRec;

    system.debug('ここまで来たかを確認するLAST');
*/
    //メール送信
    /**Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();

    List<ID> contactIds = new List<ID>();
    contactIds.add('003A000001diDp1');


    mail.setWhatIds(contactIds);
    //mail.setTargetObjectIds(contactIds);
    mail.setTemplateID('00XA0000001mtkx'); //送信メールのテンプレートのID
    Messaging.sendEmail(new Messaging.MassEmailMessage[] {mail});
    */
/**
    if (Trigger.isBefore) {
        List<String> sendAddressList = new List<String>();
        sendAddressList.add('toshi_hamano@densan-s.co.jp');

        ID tempId = '00XA0000001mtlC';
        ID objId = '003A000001diDp1';
        //ID objId2 = 'a08A000000GEHXC';
        pjmng__c pjMng = [Select Id, OwnerId From pjmng__c Where Id = 'a08A000000GEHXC'];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //mail.setToAddresses(sendAddressList);
        mail.setTemplateId(tempId);
        mail.setTargetObjectId(pjMng.OwnerId);  //ユーザ
        mail.setSaveAsActivity(false);
        mail.setWhatId(pjMng.Id);
        //mail.setTargetObjectId(pjMng.Id); //ユーザ

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
*/

/**
    Contact con = [select Id, FirstName From Contact Where Id= '003A000001diDp1'][0];

    system.debug('デバッグ１'+con);

    con.FirstName = '書き換えた9/4';
    update con;

    Contact con2 = [select Id, FirstName From Contact Where Id= '003A000001diDp1'][0];

    system.debug('デバッグ２'+con2);
*/
/**
    system.debug('トリガ開始です');

    for (Account rec: Trigger.new) {
        system.debug('トリガLOOP中です');
        if (Trigger.isAfter && Trigger.oldmap != null && Trigger.oldmap.get(rec.id).Field9__c != rec.Field9__c && rec.Field9__c) {
            system.debug('もう１っかい更新します１');
            Account acc = new Account(Id = rec.Id, Field9__c = false);
            update acc;
        }
        if (Trigger.isAfter && Trigger.oldmap != null && Trigger.oldmap.get(rec.id).Field10__c != rec.Field10__c && rec.Field10__c) {
            system.debug('もう１っかい更新します２');
            Account acc = new Account(Id = rec.Id, Field10__c = false);
            update acc;
        }
    }
*/

    /**for (Account acc : Trigger.New) {
        TestHttpCallout.callouttest(acc.Id);
    }*/
    //for (Account acc : Trigger.New) {
        //if (acc.Field6__c != null && !acc.Field6__c.contains('abc')) {
            //String sBreak = '\r\n';
            //acc.addError('abcを'+ sBreak + '含んで下さい');
        //}
    //}
    //List<AggregateResult> resultList = [Select (Select count(Id) From Tasks group by WhatId) taskCnt,
            //(Select count(Id) From Opportunities group by AccountId) oppCnt, (Select count(Id) From Events group by WhatId) evCnt,
            //(Select count(Id) From Cases group by AccountId) caseCnt From Account a group by Id];

    //system.debug('検索結果：'+resultList);

    //String zenKana = 'カナ';
    //String hanKana = 'ｶﾅ';
    //String zenEiji = 'ＡＢＣＤＥ';
    //String hanEiji = 'ABCDE';
    //String zenSuuji = '１２３４５';
    //String hanSuuji = '12345';

    //連動項目デバッグ
//    system.debug('連動項目１：'+Account.seigyoBase__c.getDescribe().getController());
//    system.debug('連動項目２：'+Account.seigyosaki__c.getDescribe().getController());


    //system.debug('禁止文字チェック：'+ system.label.MOJITEST);

    //for (Account acc : Trigger.New) {
        //カナ（全角・半角）比較
        //if (acc.CyubuCheck__c == zenKana) system.debug('【' + acc.CyubuCheck__c + '】【' + zenKana + '】'+'全角カナに一致しました。');
        //if (acc.CyubuCheck__c == hanKana) system.debug('【' + acc.CyubuCheck__c + '】【' + hanKana + '】'+'半角カナに一致しました。');

        //英字（全角・半角）比較
        //if (acc.CyubuCheck__c == zenEiji) system.debug('【' + acc.CyubuCheck__c + '】【' + zenEiji + '】'+'全角英字に一致しました。');
        //if (acc.CyubuCheck__c == hanEiji) system.debug('【' + acc.CyubuCheck__c + '】【' + hanEiji + '】'+'半角英字に一致しました。');

        //数字（全角・半角）比較
        //if (acc.CyubuCheck__c == zenSuuji) system.debug('【' + acc.CyubuCheck__c + '】【' + zenSuuji + '】'+'全角数字に一致しました。');
        //if (acc.CyubuCheck__c == hanSuuji) system.debug('【' + acc.CyubuCheck__c + '】【' + hanSuuji + '】'+'半角数字に一致しました。');

        //if (acc.CyubuCheck__c == acc.CyubuCheck2__c) system.debug('【' + acc.CyubuCheck__c + '】【' + acc.CyubuCheck2__c + '】'+'一致しました。');

        //if (acc.Name.contains()) {
        //}
    //}
}