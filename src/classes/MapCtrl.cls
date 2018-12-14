/**
 * チェックイン詳細画面用コントローラ
 **/
public with sharing class MapCtrl {

	/** チェックイン情報 **/
	public Checkin__c checkin {set; get;}

	/**
	 * ページ表示時の初期化処理
	 **/
	public PageReference init() {
		//リクエストパラメータで渡されたIDのチェックイン情報を取得
		List<Checkin__c> checkins = [select NickName__c, LocationName__c, Address__c, Location__Latitude__s, Location__Longitude__s, CreatedDate from Checkin__c where Id = :System.currentPageReference().getParameters().get('id')];
		if (checkins.size() == 1) {
			checkin = checkins.get(0);
		}
		return null;
	}

}