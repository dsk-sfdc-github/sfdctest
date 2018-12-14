/**
 * Class Name       :
 ----------------------------------------------------------------------
 * Package Name     : ZENRIN_CGIの確認
 ----------------------------------------------------------------------
 * Created By       : 
 * Created Date     : 
 * Updated By       : 
 * Updated Date     : 
 *
 * @author
 * @date
 * @description
*/
global class BatchCls_ZENRIN_CGI_TEST implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    public String errMsg;       //エラーメッセージ

    public Map<String, String> loginMap;

    public  String domainUrl = 'http://lab.zcgi.znet-town.net/cgi/'; //ZNET TOWN 検証環境ドメイン

    public String chkStr;

    /**
     * @description  バッチ開始処理
     * @param        bContext バッチパラメータ
     * @return       database.getQuerylocator バッチ対象レコード
     *
     * @author       FJ HAMANO
     * @date         2015/05/02
    */
    global Database.QueryLocator start(Database.BatchableContext bContext) {

        errMsg = '';

        String loginUrl = domainUrl; //ZNET TOWN 検証環境ドメイン
        loginUrl += 'auth_login.cgi?'; //ログインCGI
        loginUrl += 'otype=3'; //出力形式をXML
        loginUrl += '&enc=0'; //エンコードUTF-8
        loginUrl += '&encode=1'; //機能＆エリア情報を取得する
        loginUrl += '&sid=99999999'; //サービスコード
        loginUrl += '&cid=20090450'; //企業コード
        loginUrl += '&uid=fm7r1df5'; //ユーザID
        loginUrl += '&pwd=5avthj8u'; //パスワード
        loginUrl += '&serv_devcd=1'; //端末コード

        //Map<String, String> loginMap = null;
        loginMap = null;
        loginMap = zenrinRequestExec(loginUrl);

        system.debug('ログイン結果：'+loginMap);

        chkStr += 'ログイン';

        return database.getQuerylocator([Select Id From Account limit 1]);
    }

    /**
     * @description  バッチ実行処理
     * @param        bContext バッチパラメータ
     * @param        scope バッチ対象レコード
     * @return
     *
     * @author
     * @date
    */
    global void execute(Database.BatchableContext bContext, List<sObject> scope) {

        String retMsg = '';

        List<String> searchAddrList = new List<String>();
        searchAddrList.add('愛知県一宮市赤見');
        searchAddrList.add('愛知県一宮市今伊勢町宮後');
        searchAddrList.add('愛知県一宮市神山');
        searchAddrList.add('愛知県一宮市栄');
        searchAddrList.add('愛知県一宮市竹橋町');

        List<Account> resistAccList = new List<Account>();

        try {

            //for (String address: searchAddrList) {
                //住所フリーワード検索
                String freeSearchUrl = domainUrl; //ZNET TOWN 検証環境ドメイン
                freeSearchUrl += 'srch_addr_fw.cgi?'; //CGI
                freeSearchUrl += 'otype=3'; //出力形式をXML
                freeSearchUrl += '&enc=0'; //エンコードUTF-8
                freeSearchUrl += '&tod=13'; //都道府県コード
                freeSearchUrl += '&sep=1'; //区切り文字なし
                freeSearchUrl += '&aid='+loginMap.get('aid'); //認証承認ID
                freeSearchUrl += '&lmtinf='+loginMap.get('areaCode')+','+loginMap.get('funcInfoEncode'); //暗号化されたエリア情報、及び機能情報をカンマ(0x2c)で連結し記述する。
                //EncodingUtil.urlEncode(url, 'UTF-8');
                //freeSearchUrl += '&frewd='+'岐阜県岐阜市青柳町１－２３';   //検索したい住所フリーワードを指定する。URL エンコードが必要。
                //freeSearchUrl += '&frewd='+EncodingUtil.urlEncode(address, 'UTF-8');  //検索したい住所フリーワードを指定する。URL エンコードが必要。
                freeSearchUrl += '&frewd=%E7%A5%9E%E4%BF%9D%E7%94%BA';
                                            //都道府県コードを指定している場合は、都道府県名は記述しない。
                                            //数字から始まる語句の検索は不可。カナ検索には対応していない。

                system.debug('検索URL：'+freeSearchUrl);

                Map<String, String> freeSearchMap = null;
                freeSearchMap = zenrinRequestExec(freeSearchUrl);

                //system.debug('フリーワード検索住所：'+address);
                system.debug('フリーワード検索結果：'+freeSearchMap);

                String registData = '';

                if (freeSearchMap != null && freeSearchMap.size() != 0) {
                    for (String keyNm: freeSearchMap.keySet()) {
                        system.debug('キー名：'+keyNm+'|値：'+freeSearchMap.get(keyNm));
                        registData += '|キー名：'+keyNm+'|値：'+freeSearchMap.get(keyNm);
                    }
                }
                system.debug('フリーワード検索結果ステータス：'+freeSearchMap.get('status'));

                //Account acc = new Account(Name=address, TestField1__c=registData);
                //resistAccList.add(acc);
            //}


            if (resistAccList != null && resistAccList.size() != 0) {
                system.debug('データ登録');
                insert resistAccList;
            }


        } catch (Exception e) {
            if (errMsg != '') errMsg += '\r\n';
            errMsg += 'エラー発生日時：'+ String.valueOf(system.now());
            errMsg += '|エラーメッセージ：'+ e.getMessage();
            errMsg += '|エラー詳細：'+ e.getStackTraceString();
        }

        chkStr += '処理本体';
    }

    /**
     * @description  バッチ終了処理
     * @param        bContext バッチパラメータ
     * @return
     *
     * @author
     * @date
    */
    global void finish(Database.BatchableContext bContext) {


        String logoutUrl = domainUrl;
        logoutUrl += 'auth_logout.cgi?'; //ログアウトCGI
        logoutUrl += 'otype=3'; //出力形式をXML
        logoutUrl += '&enc=0'; //エンコードUTF-8
        logoutUrl += '&aid=' + loginMap.get('aid'); //認証承認ID

        Map<String, String> logoutMap = null;
        logoutMap = zenrinRequestExec(logoutUrl);

        system.debug('ログアウト結果：'+logoutMap);

        chkStr += 'ログアウト';

        system.debug(chkStr);

    }


    private Map<String, String> zenrinRequestExec(String url) {

        Map<String, String> retMap = new Map<String, String>();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        system.debug('ステータスコード：'+res.getStatusCode());
        system.debug('レスポンス：'+res);

        String bodyStr = res.getBody();

        system.debug('ボディ情報：'+bodyStr);

        XmlStreamReader reader = res.getXmlStreamReader();

        Boolean idFlg = false;
        Boolean subIdFlg = false;

        //MAPに必要なデータ
        //result
        //cid
        //sid
        //aid

        //以下、items内
        //areaCode
        //funcInfoEncode

        while(reader.hasNext()) {

            if (reader.getEventType() == XmlTag.START_ELEMENT) {

            	String key = reader.getLocalName();
            	String val = parseXML(reader);

            	system.debug('設定key：'+key);
            	system.debug('設定val：'+val);

				if (key == 'id' && val == '0004') {
					idFlg = true;
				} else if (key == 'id') {
					idFlg = false;
					subIdFlg = false;
				}

				if (idFlg && key == 'subid' && val == '0001') {
					subIdFlg = true;
				} else if (key == 'subid') {
					subIdFlg = false;
				}

				if (key == 'result' || key == 'cid' || key == 'sid' || key == 'aid' || (subIdFlg && key == 'areaCode') || (subIdFlg && key == 'funcInfoEncode')) {
					retMap.put(key, val);
				}

                //system.debug('設定XML：'+reader.getLocalName()+ '：'+parseXML(reader));

            }
            reader.next();
        }

		system.debug('作成済MAP：'+retMap);

        return retMap;
    }

    public static String parseXML(XmlStreamReader reader){

        String data = '';

        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                data = reader.getText();
            }
            reader.next();
            }
        return data;
    }
}