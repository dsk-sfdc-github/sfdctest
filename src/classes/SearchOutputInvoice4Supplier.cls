/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name  : Interbrains
 * class name	  : SearchOutputInvoice4Supplier.cls
 * remarks		  :
 * version		  : 1.0.0
 * create		    : [1.0.0] 2011/08/29 Hirokazu Izawa
 * update       :
 */
//請求書発行検索
public with sharing class SearchOutputInvoice4Supplier extends lettyBase {

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

	//締め年月リスト作成期間(前後期間)
	private final Integer setEndDate = 3;

	//コンストラクタ
	public SearchOutputInvoice4Supplier(Apexpages.Standardcontroller con) {
		this.project = new CustomObject11__c();
		this.account = (Account)con.getRecord();
		this.searchedListRendered = false;
	}

	//締め年月取得
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

    	for (Integer i = setEndDate; i <= 1; i--) {
    		//前月取得
    		setDate = nowDate.addMonths(-i);
    		listParam = String.valueOf(setDate.year()) + '年'+ String.valueOf(setDate.month()) + '月';
    		options.add(new SelectOption(listParam,listParam));
    	}
    	//当月設定
    	listParam = String.valueOf(nowDate.year()) + '年'+ String.valueOf(nowDate.month()) + '月';
    	options.add(new SelectOption(listParam,listParam));
    	for (Integer i = 1; i <= setEndDate; i++) {
    		//後月取得
    		setDate = nowDate.addMonths(i);
    		listParam = String.valueOf(setDate.year()) + '年'+ String.valueOf(setDate.month()) + '月';
    		options.add(new SelectOption(listParam,listParam));
    	}

    	return options;
    }

	//検索実行
	public Pagereference searchList() {

		//入力チェック
		//締め月日か指定締め日は必須。

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

		if (groupedResults != null) {
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
				wrap.projectIdList = this.getProjectIdList(pj.ContactId__c);

				//案件を取得
				this.searchedList.add(wrap);
			}
		} else {
			//検索結果0件
			ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, '条件に一致する結果はありません。');
			ApexPages.addMessage(message);
		}
		return null;
	}

	//案件IDを取得します。
	private List<ID> getProjectIdList(ID contactId) {
		List<ID> idList = new List<ID>();
		List<CustomObject11__c> obj = null;

		String soql = ' Select '+
						' Id '+
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

		if (obj != null) {
			for (CustomObject11__c rec: obj) {
				idList.add(rec.Id);
			}
		}
		return idList;
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
			//whereStr = whereStr + ' EndInvoice__c = true ';
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

		//入力チェック
		if (this.checkOutputInvoice() == false) {
			return null;
		}
		//チェックの入っているレコードの案件を請求済に更新
		//TODO チェックの入っているレコードの担当者ID＋検索条件をCookieに保存
		if (this.updateProject() == true) {
			//

		}

		//TODO PDFページへ遷移
		//更新処理はこのApexクラスが担当。成功時、ページに戻し、Window.openの処理をかける
		return null;
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
		if (this.selectMonth.equals('null') && this.account.targetDate__c == null) {
			ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, '締め日・指定日締め のどちらかを入力して下さい。');
			ApexPages.addMessage(message);
			ret = false;
		}
		return ret;
	}

	//案件更新処理
	private Boolean updateProject() {
		Boolean ret = false;
		List<CustomObject11__c> updateObj = new List<CustomObject11__c>();

		for (SelectionWrapper wrap: this.searchedList) {
			if (wrap.outputSelected == true) {
				//発行にチェックあり=>発行済へ
				//TODO 請求フラグは案件に紐づく「請求」オブジェクトのフラグを更新に変更
				for (ID projectId: wrap.projectIdList) {
					CustomObject11__c obj = [Select EndInvoice__c From CustomObject11__c Where Id = :projectId];
					obj.EndInvoice__c = true;
					updateObj.add(obj);
				}
			}
		}

		try {
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