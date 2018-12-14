/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: Invoice03Ctrl.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/08/29 Atsuhiro Inaba
 * update
 */
 public with sharing class Invoice03Ctrl {
	
	public string strCampWhere { get; set; }
	public string strContIdList { get; set; }
	//public string strCampFlagList { get; set; }
	public List<string> ContIdList { get; set; }
	//public List<string> CampFlagList { get; set; }
	public List<CustomObject11__c> CampInfoList { get; set; }
	public map<string, string> mapShowFlag { get; set; }
	public map<string, List<CustomObject11__c>> mapCampInfo { get; set; }
	public List<TableDto> TableList { get; set; }
	
	private string styleBorder =' border: 1px solid #000000; font-size:13px;';
	private integer maxlines = 33;
	private integer nowlines = 0;
	
	public Invoice03Ctrl(){

		TableList = new List<TableDto>();

		//抽出条件を取得
/*
		strCampWhere = '';
		strContIdList = '003A000000oj7mWIAQ,003A000000qYZBCIA4';
		strCampFlagList = '1,1';
*/	
		if(TableList.size() > 0){
			TableList[TableList.size()-1].pageBreakInfo = '';
		}
	}
	
	// 検索条件の更新
	public PageReference setQueryWhere(){
		
		//抽出条件を取得
		strCampWhere = formatNull( ApexPages.currentPage().getParameters().get( 'CampWhere' ));
		strContIdList = formatNull( ApexPages.currentPage().getParameters().get( 'contactId' ));
		//strCampFlagList = formatNull( ApexPages.currentPage().getParameters().get( 'projectFlg' ));
		
		ContIdList = strContIdList.split(',');
		//CampFlagList = strCampFlagList.split(',');


		String campQuery = ' SELECT Id, CompletionDate__c, ankennumber__c, Name, Owner, AccountId__c, ' + 
		'AccountId__r.BillingStreet, AccountId__r.BillingState, AccountId__r.BillingPostalCode, AccountId__r.BillingCountry, AccountId__r.BillingCity,'+ 
		'AccountId__r.Phone, AccountId__r.Fax, ContactId__c, ContactId__r.FirstName, ContactId__r.LastName, ContactId__r.Department, ContactId__rTitle'+ 
		'(SELECT Id, koumoku__c, suuryou__c, tanka__c, uriage__c FROM AuX5__r) FROM CustomObject11__c WHERE '+ strCampWhere + 
		' AND ContactId__c in :ContIdList order by ContactId__c, CompletionDate__c, ankennumber__c';
		
		CampInfoList = database.query(campQuery);
		
		/*
		 *　ここで案件の並び順ソート
		 *　1.案件所有者ロール（本社 ⇒ 本社グループ ⇒首都圏  ⇒首都圏グループ  ⇒ 管理本部 ）
		 *　2.担当者名
		 *　3.伝票日付
		 *　4.伝票No.
		 */



		//担当者ごとの案件情報MAP
		mapCampInfo = new map<string, List<CustomObject11__c>>();
		//担当者ごとの案件情報MAPを作成
		for(CustomObject11__c CI: CampInfoList){
			if(!mapCampInfo.containskey(string.valueof(CI.ContactId__c))){				
				mapCampInfo.put(CI.ContactId__c, new List<CustomObject11__c>());
				mapCampInfo.get(CI.ContactId__c).add(CI);				
			}else{				
				mapCampInfo.get(CI.ContactId__c).add(CI);
			}
		}
		
		TableDto tableInfo;
		
		//渡された担当者ID順で情報を表示する。
		for(string ContId : ContIdList){
			for(CustomObject11__c CampInfo : mapCampInfo.get(ContId)){
				nowlines = 0;
				//取引先情報
				Account AccInfo 			= new Account();
				AccInfo.BillingStreet 		= CampInfo.AccountId__r.BillingStreet;
				AccInfo.BillingState 		= CampInfo.AccountId__r.BillingState;
				AccInfo.BillingPostalCode 	= CampInfo.AccountId__r.BillingPostalCode;
				AccInfo.BillingCountry 		= CampInfo.AccountId__r.BillingCountry;
				AccInfo.BillingCity 		= CampInfo.AccountId__r.BillingCity;
				AccInfo.Phone 				= CampInfo.AccountId__r.Phone;
				AccInfo.Fax 				= CampInfo.AccountId__r.Fax;
				//取引責任者情報
				Contact ConInfo 			= new Contact();
				ConInfo.FirstName			= CampInfo.ContactId__r.FirstName;
				ConInfo.LastName			= CampInfo.ContactId__r.LastName;
				ConInfo.Department			= CampInfo.ContactId__r.Department;
				ConInfo.Title				= CampInfo.ContactId__r.Title;

				tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');

/*
				//案件情報
				tableInfo.rowList.add(rowInfoSetting(string.valueOf(CampInfo.CompletionDate__c),CampInfo.ankennumber__c,CampInfo.Name,'','',''));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}
				//空白行
				tableInfo.rowList.add(rowInfoSetting('','','','','',''));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}
				//売上情報		
				Decimal goukei = 0;
				for(uriage__c uriageInfo:CampInfo.AuX5__r){
					tableInfo.rowList.add(rowInfoSetting('','',uriageInfo.koumoku__c,uriageInfo.suuryou__c,uriageInfo.tanka__c.format(),uriageInfo.uriage__c.format()));					
					goukei += uriageInfo.uriage__c;
					if(nowlines == 0){
						TableList.add(tableInfo);
						tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
					}
				}				
				//空白行
				tableInfo.rowList.add(rowInfoSetting('','','','','',''));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}
				//消費税
				tableInfo.rowList.add(rowInfoSetting('','','&lt;消費税&gt;','','',(goukei*0.05).format()));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}
				//伝票計
				tableInfo.rowList.add(rowInfoSetting('','','&lt;&lt;伝票計&gt;&gt;','','',(goukei*1.05).format()));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}		
				//案件備考						
				tableInfo.rowList.add(rowInfoSetting('','','','','',''));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}
				//空白行
				tableInfo.rowList.add(rowInfoSetting('','','','','',''));
				if(nowlines == 0){
					TableList.add(tableInfo);
					tableInfo = new TableDto(AccInfo, ConInfo, '<div style="page-break-after: always"/>');
				}
*/
			}
			//空白行
			if(nowlines > 0){
				for(integer i = 0; i < maxlines - nowlines; i++ ){
					tableInfo.rowList.add(rowInfoSetting('','','','',''));
				}
				TableList.add(tableInfo);
			}
		}

		return null;
	}
	
	//===============================================================
	// 行の情報をセットする。	
	//===============================================================
	//private RowDto rowInfoSetting(string dDate, string dNo, string cName, string suryo, string tanka, string kingaku){	
	private RowDto rowInfoSetting(string dDate, string dNo, string cName, string kingaku, string bikou){	
		
		RowDto rowTotal = new RowDto(); 

/*
		rowTotal.columnList.add( new ColumnDto( formatNull(dDate), styleBorder + ' vertical-align:top; text-align:center; width:80px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(dNo), styleBorder + ' vertical-align:top; text-align:center; width:80px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(cName), styleBorder + ' vertical-align:top; text-align:left; width:280px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(suryo), styleBorder + ' vertical-align:top; text-align:right; width:80px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(tanka), styleBorder + ' vertical-align:top; text-align:right; width:80px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(kingaku), styleBorder + ' vertical-align:top; text-align:right; width:80px; height:19px;' ) );
*/		
		rowTotal.columnList.add( new ColumnDto( formatNull(dDate), styleBorder + ' vertical-align:top; text-align:center; width:80px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(dNo), styleBorder + ' vertical-align:top; text-align:center; width:80px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(cName), styleBorder + ' vertical-align:top; text-align:left; width:280px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(kingaku), styleBorder + ' vertical-align:top; text-align:right; width:100px; height:19px;' ) );
		rowTotal.columnList.add( new ColumnDto( formatNull(bikou), styleBorder + ' vertical-align:top; text-align:right; width:140px; height:19px;' ) );

		nowlines++;
		
		if(nowlines >= maxlines){
			nowlines = 0;
		}
		
		return rowTotal;
	}
	
	
	//===============================================================
	// null->[]に変換
	//===============================================================
	private String formatNull( String obj ){
		if( obj == null ){
			return '';
		}
		return obj;
	}
	
	
	
}