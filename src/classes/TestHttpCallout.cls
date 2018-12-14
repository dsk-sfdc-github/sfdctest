public class TestHttpCallout {

    //このメソッドを非同期実行するために、@futureを記述
    @future(callout=true)
    //public static void callouttest() {
    public static void callouttest(String id) {

        system.debug('HTTP通信開始');
        //HTTPリクエストの作成
        HttpRequest req = new HttpRequest();

        //送信先
        req.setEndpoint('http://toshi-app-dev.appspot.com/getRequestTest?');

        String name='HAMANO';
        String city = 'GIFU';

        //Header情報にセット
        req.setHeader('name', EncodingUtil.urlEncode(name, 'UTF-8'));
        req.setHeader('city', EncodingUtil.urlEncode(city, 'UTF-8'));

        //メソッド種別(今回はHeader情報へ)
        req.setMethod('HEAD');

        //HTTPリクエストの送信
        Http http = new Http();
        HttpResponse res = http.send(req);

        //レスポンスチェック
        if (res.getStatusCode() == 200) {
            //成功時に実行したい処理
            system.debug('Callout success: ' + res);
            //受け取ったパラメータ
            system.debug('Callout success(recName): ' + res.getHeader('recName'));
            system.debug('Callout success(recResponse): ' + res.getHeader('recResponse'));
        } else {
            system.debug('Callout failed: ' + res);
        }
        //Account acc = [Select Name From Account Where Id = :id];
        //acc.Name = '書き換えTEST';
        //update acc;

        system.debug('HTTP通信終了');
    }
}