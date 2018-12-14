/**
 * チェックイン画面用のコントローラ
 **/
public with sharing class CheckinCtrl {

	/** チェックイン情報 **/
	public Checkin__c checkin {set; get;}

	/**
	 * ページ表示時の初期化処理
	 **/
	public PageReference init() {
		try {
			checkin = new Checkin__c();
			//リクエストパラメータで渡された緯度、経度をチェックイン情報の緯度、経度の初期値に設定
			checkin.Location__Latitude__s = Decimal.valueOf(System.currentPageReference().getParameters().get('latitude'));
			checkin.Location__Longitude__s = Decimal.valueOf(System.currentPageReference().getParameters().get('longitude'));
		}
		catch (Exception e) {
			System.debug(e);
		}
		return null;
	}

	/**
	 * 保存ボタンの処理
	 **/
	public PageReference save() {
		//チェックイン情報のInsert
		insert checkin;
		return null;
	}

}