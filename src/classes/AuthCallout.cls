public class AuthCallout {

	public AuthCallout() {
		system.debug('初期');
	}

	/**
	* @author 濱野敏明
	* @date 25/01/2011
	* @description このクラスの説明書きです。<BR>改行しました。
	*/
	public Pagereference basicAuthCallout() {
		//TestHttpCallout.callouttest();
		system.debug('HTTP通信開始(Class)');
		/*//HTTPリクエストの作成
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://toshi-app-dev.appspot.com/getRequestTest');
		req.setBody('SalesForce_param');
		req.setMethod('GET');

		//HTTPリクエストの送信
		Http http = new Http();
		HttpResponse res = http.send(req);

		//レスポンスチェック
		if (res.getStatusCode() == 200) {
			//成功時に実行したい処理
			system.debug('Callout success: ' + res);
		} else {
			system.debug('Callout failed: ' + res);
		}
		system.debug('HTTP通信終了(Class)');*/

		//Account acc = new Account();
		//acc.Name = '新規取引先';
		//insert acc;
		Account acc = [Select Id From Account limit 1];
		update acc;
		return null;
	}
}