/** 権限チェックテスト用クラス
 * 取引先に対して参照権限しか持たないユーザがアプリを利用して更新処理をかけてみます。
 */
public with sharing class AccountTestController {

	public String accIdParam {get; set;}

    //コンストラクタ
    public AccountTestController() {

    }

    //更新処理
    public PageReference updateTorihikisaki() {
        Account acc = [Select Id,Name From Account limit 1];

        System.debug('***取得***'+acc);
        acc.Name= '書き換えました。';
        try {
            update acc;
        } catch(Exception e) {
            System.debug('***EXCEPTION***'+e.getMessage());
        }
        return null;
    }

    //更新処理
    public PageReference updateTorihikisaki2() {

    	Account acc = [Select Id From Account Where Name = '濱野取引先'];
    	accIdParam = acc.Id;
        return null;
    }
}