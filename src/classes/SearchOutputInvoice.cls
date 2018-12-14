/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name  : Interbrains
 * class name	  : SearchOutputInvoice.cls
 * remarks		  :
 * version		  : 1.0.0
 * create		    : [1.0.0] 2011/08/29 Toshiaki Hamano
 * update       :
 */
//請求書発行検索
//public with sharing class SearchOutputInvoice extends lettyBase {
public without sharing class SearchOutputInvoice extends lettyBase {

	//案件
	public CustomObject11__c project {get; set;}

	//取引先
	public Account account {get; set;}

	//検索結果
	public List<SelectionWrapper> searchedList {get; set;}

	//検索結果表示有無
	public Boolean searchedListRendered {get; set;}

	//未請求チェックボックス
	public Boolean claimValue {get; set;}

	//伝票フェーズチェックボックス
	public Boolean phaseValue {get; set;}

	//締め月選択値
	public String selectMonth {get; set;}

	//検索条件
	public String CampWhere {get; private set;}

	//選択担当者ID
	public String contactId {get; private set;}

	//案件ごとフラグ
	public String projectFlg {get; private set;}

	//処理成功フラグ
	public Boolean successFlg {get; private set;}

	//締切り日(請求書発行用)
	public String DeadlineDate {get; private set;}

	//締め年月設定日付
	private final Integer setListMonth = 3;

	//一度に処理可能なレコード件数を設定
	private final Integer maxOutputCnt = 50;

	//コンストラクタ
	public SearchOutputInvoice(Apexpages.Standardcontroller con) {
		this.account = (Account)con.getRecord();
		this.project = new CustomObject11__c();
		this.searchedListRendered = false;

		this.successFlg = false;
		this.claimValue = true;
		this.phaseValue = true;
	}

	//年月取得(現在月から前後3ヶ月をリストに設定)
    public List<SelectOption> getMonthItems() {
    	List<SelectOption> options = new List<SelectOption>();

		options.add(new SelectOption('null',''));

    	//for (Integer i = 1; i <= 12; i++) {
			//options.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
    	//}
    	//現在日より前後（設定月間）を取得する。
    	Date nowDate = Date.today();
    	Date setDate = null;
    	String listParam = null;
    	String listValue = null;

    	for (Integer i = setListMonth; i >= 1; i--) {
    		//前月取得
    		setDate = nowDate.addMonths(-i);
    		listParam = String.valueOf(setDate.year()) + '-'+ String.valueOf(setDate.month());
    		listValue = String.valueOf(setDate.year()) + '年'+ String.valueOf(setDate.month()) + '月';
    		options.add(new SelectOption(listParam,listParam));
    	}
    	//当月設定
    	listParam = String.valueOf(nowDate.year()) + '-'+ String.valueOf(nowDate.month());
    	listValue = String.valueOf(nowDate.year()) + '年'+ String.valueOf(nowDate.month()) + '月';
    	options.add(new SelectOption(listParam,listParam));
    	for (Integer i = 1; i <= setListMonth; i++) {
    		//後月取得
    		setDate = nowDate.addMonths(i);
    		listParam = String.valueOf(setDate.year()) + '-'+ String.valueOf(setDate.month());
    		listValue = String.valueOf(setDate.year()) + '年'+ String.valueOf(setDate.month()) + '月';
    		options.add(new SelectOption(listParam,listParam));
    	}

    	return options;
    }

	//検索実行
	public Pagereference searchList() {

		Integer sumiCnt = 0;
		List<ID> idList = null;
		//入力チェック
		if (this.checkSearch() == false) {
			return null;
		}

		//TODO 検索条件をCookieに格納
		//cookieUtil.cookieSet('検索条件');
		this.searchedList = new List<SelectionWrapper>();
		//SOQL
		String soql = ' select '+
							' ContactId__c , '+
							' count(Name) cntPj, '+
							' Max(AccountId__c) accountId, '+
							' Max(AccountId__r.Name) accountNm, '+
							' Max(AccountId__r.Field5__c) point, '+
							' sum(SaleAmount__c) ammount '+
						' from '+
							' CustomObject11__c ';
		//GROUP BY
		String grouping = ' group by ContactId__c ';

		//検索条件設定
		String whereStr = this.getWhereStr();
		//検索条件をCookieに保存
		//CookieUtil.cookieSet('campWhere', whereStr);
		//検索条件を公開変数に保存
		this.CampWhere = this.getWhereStr();
		System.debug('***公開変数***'+this.campWhere);

		List<AggregateResult> groupedResults = null;
		System.debug('***CREATE_SOQL***'+soql + whereStr + grouping);
		try {
			//TODO ページング機能は必要か確認 ApexPagingController
			groupedResults = Database.query(soql + whereStr + grouping);
		} catch (Exception e) {
			System.debug('***EXCEPTION***'+e.getMessage());
			//TODO エラー処理
			ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, '検索中に予期せぬエラーが発生しました。');
			ApexPages.addMessage(message);
			return null;
		}

		if (groupedResults.size() != 0) {
			this.searchedListRendered = true;

			for (AggregateResult result: groupedResults) {
				//案件情報格納
				CustomObject11__c pj = new CustomObject11__c();
				pj.ContactId__c = String.valueOf(result.get('ContactId__c'));
				pj.AccountId__c = String.valueOf(result.get('accountId'));
				pj.SaleAmount__c = Integer.valueOf(result.get('ammount'));

				SelectionWrapper wrap = new SelectionWrapper(pj);
				wrap.closePoint = String.valueOf(result.get('point'));
				wrap.cntProject = Integer.valueOf(result.get('cntPj'));
				//wrap.projectIdList = this.getProjectIdList(pj.ContactId__c);
				List<CustomObject11__c> projectList = this.getProjectIdList(pj.ContactId__c);

				if (projectList != null) {
					sumiCnt = 0;
					idList = new List<ID>();
					for (CustomObject11__c rec: projectList) {
						idList.add(rec.Id);
						for (seikyuu__c seikyu: rec.LnkAnkenToSeikyu__r) {
							if (seikyu.sumi__c) {
								sumiCnt++;
							}
						}
					}
				}

				wrap.projectIdList = idList;
				//済件数
				wrap.cntProjectInvoiced = sumiCnt;
				//追加
				this.searchedList.add(wrap);
			}
		} else {
			//検索結果0件
			this.searchedListRendered = false;
			ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, '条件に一致する結果はありません。');
			ApexPages.addMessage(message);
		}
		return null;
	}

	//案件IDを取得します。
	//private List<ID> getProjectIdList(ID contactId) {
	private List<CustomObject11__c> getProjectIdList(ID contactId) {
		//List<ID> idList = new List<ID>();
		List<CustomObject11__c> obj = null;

		String soql = ' Select '+
						' Id, '+
						' (Select sumi__c From LnkAnkenToSeikyu__r)' +
						' From '+
						' CustomObject11__c ';

		String whereStr = this.getWhereStr();
		if (contactId != null) {
			whereStr = setWhereStr(whereStr);
			whereStr = whereStr + ' ContactId__c = \'' + contactId +'\'';
		}

		try {
			obj = Database.query(soql + whereStr);
		} catch (Exception e) {
			System.debug('***EXCEPTION***'+e.getMessage());
			//TODO エラー処理
		}

		return obj;

		/**if (obj != null) {
			for (CustomObject11__c rec: obj) {
				idList.add(rec.Id);
				for (seikyuu__c seikyu: rec.LnkAnkenToSeikyu__r) {
					if (seikyu.sumi__c) {

					}
				}
			}
		}
		return idList;*/
	}

	//検索条件を取得
	private String getWhereStr() {
		String whereStr = '';

		//whereStr = setWhereStr(whereStr);
		//whereStr = whereStr + ' Phase__c <> \'【入金】入金処理済\'';

		//締め日
		//完了予定日の日付範囲の条件を確認
		if (this.account.Field5__c != '' && this.account.Field5__c != null) {
			whereStr = setWhereStr(whereStr);
			//取引先の締め日が該当するレコード
			whereStr = whereStr + ' AccountId__r.Field5__c = \'' + this.account.Field5__c +'\'';
		}
		//取引先名
		if (this.project.AccountId__c != null) {
			whereStr = setWhereStr(whereStr);
			whereStr = whereStr + ' AccountId__c = \'' + project.AccountId__c +'\'';
		}
		//先方担当者
		if (this.project.ContactS__c != null) {
			whereStr = setWhereStr(whereStr);
			whereStr = whereStr + ' ContactId__c = \'' + project.ContactS__c +'\'';
		}
		//未請求のみ表示
		//TODO請求オブジェクトを参照 ここの条件では無理？
		if (this.claimValue == true) {
			whereStr = setWhereStr(whereStr);
			whereStr = whereStr + ' Id in (Select anken__c From seikyuu__c Where sumi__c = false) ';
		}
		//伝票フェーズのみ表示(フェーズに「伝票が含まれているもの」)
		if (this.phaseValue == true) {
			whereStr = setWhereStr(whereStr);
			whereStr = whereStr + ' Phase__c like \'%伝票%\'';
		}

		return whereStr;
	}

	//請求書発行
	public Pagereference outputInvoice() {

		this.successFlg = false;
		//入力チェック
		if (this.checkOutputInvoice() == false) {
			return null;
		} else {
			//請求締め日を設定
			//TODO 年月日に整形
			if (this.account.targetDate__c != null) {
				//指定締日
				/**this.DeadlineDate = String.valuOf(this.account.targetDate__c.year()) + '年' +
									String.valuOf(this.account.targetDate__c.month()) + '月' +
									String.valuOf(this.account.targetDate__c.day()) + '日';*/
				this.DeadlineDate = String.valueOf(this.account.targetDate__c);
			} else {
				//指定年月
				Integer setDay = null;
				try {
					setDay = Integer.valueOf(Account.Field5__c.replace('毎月', '').replace('日締', ''));
				} catch (Exception e) {
					//末締めの場合(TODO 数値判断用メソッドを用意)
					String[] splitParam = this.selectMonth.split('-');
					setDay = Date.newInstance(Integer.valueOf(splitParam[0]), Integer.valueOf(splitParam[1]), 1).addMonths(1).addDays(-1).day();
				}
				this.DeadlineDate = this.selectMonth.replace('-', '年') + '月' + String.valueOf(setDay);
			}
			//this.DeadlineDate = String.valueOf(this.account.targetDate__c);
			System.debug('***指定日付***'+this.DeadlineDate);
		}
		//チェックの入っているレコードの案件を請求済に更新
		//TODO チェックの入っているレコードの担当者ID＋検索条件をCookieに保存
		if (this.updateProject() == true) {
			//

		}
		System.debug('***ここまできました。***'+this.successFlg);
		//TODO PDFページへ遷移
		//更新処理はこのApexクラスが担当。成功時、ページに戻し、Window.openの処理をかける
		this.successFlg = true;
		System.debug('***結果***'+ this.successFlg);
		return null;
	}

	//検索時、入力チェック
	private Boolean checkSearch() {
		Boolean ret = true;

		//取引先・締め日、共に未入力の場合エラー
		if (project.AccountId__c == null && Account.Field5__c == null) {
			project.AccountId__c.addError('【締め日】または【取引先】は必須です。');
			Account.Field5__c.addError('【締め日】または【取引先】は必須です。');
			ret = false;
		}
		return ret;
	}

	//更新時、入力チェック
	private Boolean checkOutputInvoice() {
		Boolean ret = true;

		//発行に一つもチェックがない場合、エラー
		Integer checkCnt = 0;
		for (SelectionWrapper wrap: this.searchedList) {
			if (wrap.outputSelected == true) {
				checkCnt++;
				break;
			}
		}
		if (checkCnt == 0) {
			ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, '発行を選択してください。');
			ApexPages.addMessage(message);
			ret = false;
		}

		//月項目・指定日締め共に空の場合、エラー
		if ((this.selectMonth.equals('null') && this.account.targetDate__c == null) ||
			(!this.selectMonth.equals('null') && this.account.targetDate__c != null)) {
			ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, '【締め日設定】　締め日・指定日締め のどちらかを入力して下さい。');
			ApexPages.addMessage(message);
			ret = false;
		}
		return ret;
	}

	//案件更新処理
	private Boolean updateProject() {
		Boolean ret = false;
		List<seikyuu__c> updateObj = new List<seikyuu__c>();

		//Cookie保存情報変数
		this.contactId = null;
		this.projectFlg = null;
		Integer counter = 0;
		for (SelectionWrapper wrap: this.searchedList) {
			//カウンターチェック
			counter++;
			if (counter > maxOutputCnt) break;

			if (wrap.outputSelected == true) {
				//発行にチェックあり=>発行済へ
				//TODO 請求フラグは案件に紐づく「請求」オブジェクトのフラグを更新に変更
				for (ID projectId: wrap.projectIdList) {
					try {
						seikyuu__c obj = [Select sumi__c From seikyuu__c Where anken__c = :projectId];
						obj.sumi__c = true;
						updateObj.add(obj);
					} catch (Exception e) {
						System.debug('***EXCEPTION***'+e.getMessage());
						//TODO エラー処理
					}
				}
				//公開変数へ情報をセット
				if (this.contactId != null) {
					this.contactId = this.contactId + ',' + String.valueOf(wrap.record.ContactId__c);
				} else {
					this.contactId = String.valueOf(wrap.record.ContactId__c);
				}

				//案件ごとにチェックあり
				if (this.projectFlg != null) {
					this.projectFlg = this.projectFlg + ',' + String.valueOf(wrap.projectSelected? '1': '0');
				} else {
					this.projectFlg = String.valueOf(wrap.projectSelected? '1': '0');
				}
			}
		}

		System.debug('***公開変数***'+this.contactId);
		System.debug('***公開変数***'+this.projectFlg);
		//CookieUtil.cookieSet('contactId', this.contactId);
		//CookieUtil.cookieSet('projectFlg', this.projectFlg);
		try {
			//TODO 更新件数と処理最大件数の比較
			update updateObj;
			ret = true;
		} catch (Exception e) {
			System.debug('***EXCEPTION***'+e.getMessage());
			//TODO エラー処理
		}
		return ret;
	}

	//SOQL条件設定
	private String setWhereStr(String whereStr) {
    	if (whereStr == '') {
			whereStr = whereStr + ' WHERE ';
		} else {
			whereStr = whereStr + ' AND ';
		}
		return whereStr;
    }
}