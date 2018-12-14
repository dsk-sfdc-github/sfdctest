/**
 * チェックイン履歴画面用のコントローラ
 **/
public with sharing class SearchCheckinsCtrl {

	/** 検索時の距離 **/
	public String distance {set; get;}

	/** チェックイン履歴の有無 **/
	public Boolean hasCheckins {set; get{
		return (checkins != null && checkins.size() > 0);
	}}

	/** チェックイン履歴 **/
	public List<Checkin__c> checkins {set; get;}

	/**
	 * ページ表示時の初期化処理
	 **/
	public PageReference init() {

		//リクエストパラメータから検索距離、緯度、経度を取得
		distance = System.currentPageReference().getParameters().get('distance');
		String latitude = System.currentPageReference().getParameters().get('latitude');
		String longitude = System.currentPageReference().getParameters().get('longitude');

		try {
			//検索距離、緯度、経度を指定してSOQLの実行
			checkins = Database.query(
				'select Id, Address__c, LocationName__c, NickName__c, CreatedDate from Checkin__c ' +
				'where DISTANCE(Location__c, GEOLOCATION(' + String.escapeSingleQuotes(latitude) + ',' + String.escapeSingleQuotes(longitude) + '), \'km\') < ' + String.escapeSingleQuotes(distance) + ' ' +
				'order by CreatedDate desc'
			);
		}
		catch (Exception e) {
			System.debug(e);
		}

		return null;
	}

}