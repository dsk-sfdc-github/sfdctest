public with sharing class GoogleMapTest {

	//地図中心点取引先を取得
	public Account acc {get;set;}

	//取引先リスト
	public List<Account> accList {get;set;}

	//一覧を表示するかどうか
	public Boolean listRenderFlg {get; set;}

	//検索条件設定用オブジェクト
	public Account accForSearch {get; set;}

	//緯度
	public String latitude {get; set;}

	//経度
	public String longitude {get; set;}

	//検索範囲
	public List<SelectOption> distance {get; set;}
	public String distanceSelected {get; set;}

	//中心地点選択
	public List<SelectOption> fieldCenter {get; set;}
	public String fieldCenterSelected {get; set;}

	//コンストラクタ
	public GoogleMapTest() {

        //検索条件作成・初期値etc指定

        //電算システムの情報を取得
		//this.acc = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account Where Id = '001A0000014oRt7'];

		//中心地点
		this.createFieldCenter();

		//検索範囲
		this.createDistance();

		//顧客ランク
		this.accForSearch = new Account();

    }

	//中心地点選択リスト作成
    private void createFieldCenter() {
        this.fieldCenter = new List<SelectOption>();
        this.fieldCenter.add(new SelectOption('ownPlace', '現在地点'));
        this.fieldCenter.add(new SelectOption('selectAccount', '取引先選択'));
        this.fieldCenterSelected = 'ownPlace';
    }

    //検索範囲選択リスト作成
    private void createDistance() {
        this.distance = new List<SelectOption>();
        this.distance.add(new SelectOption('1', '半径１Km以内'));
        this.distance.add(new SelectOption('5', '半径５Km以内'));
        this.distance.add(new SelectOption('10', '半径１０Km以内'));
        this.distance.add(new SelectOption('25', '半径２５Km以内'));
        this.distanceSelected = '1';
    }


	//検索実行
	public Pagereference searchAction() {

		return null;
	}

	//自身の取引先情報を取得（検索条件で指定取引先を選択した場合）
	private void getOwnAccountsData(){
		this.acc = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account Where Id = :accForSearch.Id];
	}

	//自分以外の取引先情報を取得
    public Object[] getAccountsData(){
        Object[] jsonData = new Object[]{};
        // 表示取引先以外を取得
        //for(Account AccountsData : [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account Where Id != :acc.Id]){
        for(Account AccountsData : Database.query('select Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode from Account ' +
				'where DISTANCE(Location__c, GEOLOCATION(' + String.escapeSingleQuotes(this.latitude) + ',' + String.escapeSingleQuotes(this.longitude) + '), \'km\') < ' + String.escapeSingleQuotes(distanceSelected) + ' ' +
				'order by CreatedDate desc')){
            jsonData.add(
                '{name:\'' + AccountsData.Name +
                    '\', address:\'' + AccountsData.BillingPostalCode + AccountsData.BillingState + AccountsData.BillingCity + AccountsData.BillingStreet +
                    '\', id:\'' + AccountsData.Id +
                    '\', info:\'' + AccountsData.BillingState + AccountsData.BillingCity + AccountsData.BillingStreet +
                '\'}'
            );
        }
        return jsonData;
    }
}