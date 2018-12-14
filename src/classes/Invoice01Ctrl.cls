/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: Invoice01Ctrl.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/08/29 Li Lin
 * update
 */
 public with sharing class Invoice01Ctrl {
	
	public string strCampWhere { get; set; }
	public string strContIdList { get; set; }
	public string strCampFlagList { get; set; }
	public List<string> ContIdList { get; set; }
	public List<string> CampFlagList { get; set; }
	public List<CustomObject11__c> CampInfoList { get; set; }
	public map<string, string> mapShowFlag { get; set; }
	public map<string, List<CustomObject11__c>> mapCampInfo { get; set; }
	public List<pageDto> pageList { get; set; }
	public String preview { get; set; }
	
	private string styleBorder =' border: 1px solid #000000; font-size:13px;';
	private integer maxlines = 33;
	private integer nowlines = 0;
	public String previewFlg = '';
	
	public Invoice01Ctrl(){

		pageList = new List<pageDto>();
		
		previewFlg = strCampWhere = formatNull( ApexPages.currentPage().getParameters().get( 'previewFlg' ));
		
		if (previewFlg == '0'){
			preview = 'pdf';
		}else{
			preview = '';
		}
		
	}
	
	// 検索条件の更新
	public PageReference setQueryWhere(){
		
		//抽出条件を取得
		strCampWhere = formatNull( ApexPages.currentPage().getParameters().get( 'CampWhere' ));
		strContIdList = formatNull( ApexPages.currentPage().getParameters().get( 'contactId' ));
		strCampFlagList = formatNull( ApexPages.currentPage().getParameters().get( 'projectFlg' ));	

		//strCampWhere = '';
		//strContIdList = '003Q000000OioGGIAZ';
		//strCampFlagList = '0';	

		ContIdList = strContIdList.split(',');
		CampFlagList = strCampFlagList.split(',');
	
		mapShowFlag = new map<string, string>();
		for(integer index = 0; index < ContIdList.size(); index++ ){
			mapShowFlag.put(ContIdList[index], CampFlagList[index]);		
		}
		
		system.debug('*************************');
		system.debug('strCampWhere--' + strCampWhere);
		system.debug('strContIdList--' + strContIdList);
		system.debug('strCampFlagList--' + strCampFlagList);
		
		String campQuery = ' SELECT Id, CompletionDate__c, ankennumber__c, Name, Memo__c, OwnerId, AccountId__c, ' + 
		'AccountId__r.BillingStreet, AccountId__r.BillingState, AccountId__r.BillingPostalCode, AccountId__r.BillingCountry, AccountId__r.BillingCity,'+ 
		'AccountId__r.Phone, AccountId__r.Fax, ContactId__c, ContactId__r.FirstName, ContactId__r.LastName, ContactId__r.Department, ContactId__r.Title,'+ 
		'(SELECT Id, koumoku__c, suuryou__c, tanka__c, uriage__c FROM AuX5__r) FROM CustomObject11__c WHERE '+ strCampWhere + 
		' ContactId__c in :ContIdList order by ContactId__c, CompletionDate__c, ankennumber__c';
		
		CampInfoList = database.query(campQuery);
		
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
		
		pageDto tableInfo;
		
		//渡された担当者ID順で情報を表示する。
		for(string ContId : ContIdList){
			if(mapShowFlag.get(ContId) == '1'){
				maxlines = 29;
				for(CustomObject11__c CampInfo : mapCampInfo.get(ContId)){
					nowlines = 0;
					
					tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					
					//案件情報
					tableInfo.rowList.add(rowInfoSetting(string.valueOf(CampInfo.CompletionDate__c),CampInfo.ankennumber__c,CampInfo.Name,'','',''));
					if(nowlines == 0){
						//案件備考						
						tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
						tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left; height:57px;"></td></tr>';

						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					
					//空白行
					tableInfo.rowList.add(rowInfoSetting('','','','','',''));
					if(nowlines == 0){
						//案件備考						
						tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
						tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left; height:57px;"></td></tr>';

						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					
					//売上情報		
					Decimal goukei = 0;
					for(uriage__c uriageInfo:CampInfo.AuX5__r){
						if(uriageInfo.suuryou__c == null){
							uriageInfo.suuryou__c = '0';
						}
						if(uriageInfo.tanka__c == null){
							uriageInfo.tanka__c = 0;
						}						
						if(uriageInfo.uriage__c == null){
							uriageInfo.uriage__c = 0;
						}
						tableInfo.rowList.add(rowInfoSetting('','',uriageInfo.koumoku__c,uriageInfo.suuryou__c,uriageInfo.tanka__c.format(),uriageInfo.uriage__c.format()));					
						goukei += uriageInfo.uriage__c;
						if(nowlines == 0){
							//案件備考						
							tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
							tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left; height:57px;"></td></tr>';

							pageList.add(tableInfo);
							tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
						}
					}				
					
					//空白行
					tableInfo.rowList.add(rowInfoSetting('','','','','',''));
					if(nowlines == 0){
						//案件備考						
						tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
						tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left; height:57px;"></td></tr>';

						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					
					//消費税
					tableInfo.rowList.add(rowInfoSetting('','','&lt;消費税&gt;','','',(goukei*0.05).format()));
					if(nowlines == 0){
						//案件備考						
						tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
						tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left; height:57px;"></td></tr>';

						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					
					//伝票計
					tableInfo.rowList.add(rowInfoSetting('','','&lt;&lt;伝票計&gt;&gt;','','',(goukei*1.05).format()));
					if(nowlines == 0){
						//案件備考						
						tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
						tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; white-space: normal; text-align:left; vertical-align:top; height:57px;">' + formatNull(CampInfo.Memo__c) + '</td></tr>';

						pageList.add(tableInfo);
					}		
					
					//空白行
					integer intNum = maxlines - nowlines;
					if(nowlines > 0){
						for(integer i = 0; i < intNum; i++ ){
							tableInfo.rowList.add(rowInfoSetting('','','','','',''));
						}
						//案件備考						
						tableInfo.campMemoLabel = '<tr><td colspan="6" style="border-right:1px solid #000000;border-top:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; text-align:left;">&lt;備　考&gt;</td></tr>';		
						tableInfo.campMemoInfo = '<tr><td colspan="6" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000; border-collapse:collapse; font color:#000000; font-size:13px; width:680px; white-space: normal; text-align:left; vertical-align:top; height:57px;">' + formatNull(CampInfo.Memo__c) + '</td></tr>';
						pageList.add(tableInfo);
					}		
				}
			}else{
				maxlines = 33;
				Boolean firstTimeFlg = true;		
				nowlines = 0;				
				for(CustomObject11__c CampInfo : mapCampInfo.get(ContId)){

					if(!firstTimeFlg){
						//空白行
						tableInfo.rowList.add(rowInfoSetting('','','','','',''));
						if(nowlines == 0){
							pageList.add(tableInfo);
							tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
						}
					}else{
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
						firstTimeFlg = false;
					}
					//案件情報
					tableInfo.rowList.add(rowInfoSetting(string.valueOf(CampInfo.CompletionDate__c),CampInfo.ankennumber__c,CampInfo.Name,'','',''));
					if(nowlines == 0){
						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					//空白行
					tableInfo.rowList.add(rowInfoSetting('','','','','',''));
					if(nowlines == 0){
						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					//売上情報		
					Decimal goukei = 0;
					for(uriage__c uriageInfo:CampInfo.AuX5__r){
						if(uriageInfo.suuryou__c == null){
							uriageInfo.suuryou__c = '0';
						}
						if(uriageInfo.tanka__c == null){
							uriageInfo.tanka__c = 0;
						}						
						if(uriageInfo.uriage__c == null){
							uriageInfo.uriage__c = 0;
						}
										
						tableInfo.rowList.add(rowInfoSetting('','',uriageInfo.koumoku__c,uriageInfo.suuryou__c,uriageInfo.tanka__c.format(),uriageInfo.uriage__c.format()));					
						goukei += uriageInfo.uriage__c;
						if(nowlines == 0){
							pageList.add(tableInfo);
							tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
						}
					}				
					//空白行
					tableInfo.rowList.add(rowInfoSetting('','','','','',''));
					if(nowlines == 0){
						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					//消費税
					tableInfo.rowList.add(rowInfoSetting('','','&lt;消費税&gt;','','',(goukei*0.05).format()));
					if(nowlines == 0){
						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}
					//伝票計
					tableInfo.rowList.add(rowInfoSetting('','','&lt;&lt;伝票計&gt;&gt;','','',(goukei*1.05).format()));
					if(nowlines == 0){
						pageList.add(tableInfo);
						tableInfo = new pageDto(CampInfo.AccountId__r, CampInfo.ContactId__r, '<div style="page-break-after: always"/>');
					}		
					//案件備考						
					tableInfo.rowList.add(rowInfoSetting('','',CampInfo.Memo__c,'','',''));
					if(nowlines == 0){
						pageList.add(tableInfo);
					}
				}
				//空白行
				if(nowlines > 0){
					integer intNum2 = maxlines - nowlines;
					for(integer i = 0; i < intNum2; i++ ){
						tableInfo.rowList.add(rowInfoSetting('','','','','',''));
					}
					pageList.add(tableInfo);
				}
			}
		}
		system.debug('*************************');
		system.debug('pageList--' + pageList);

		if(pageList.size() > 0){
			pageList[pageList.size()-1].pageBreakInfo = '';
		}
		
		return null;
		
		PageReference pr = ApexPages.currentPage();		
		pr.getParameters().put('previewFlg','0');
		
		return pr;
		
	}
	
	//===============================================================
	// 行の情報をセットする。	
	//===============================================================
	private List<string> rowInfoSetting(string dDate, string dNo, string cName, string suryo, string tanka, string kingaku){
		
		List<string> rowInfo = new List<string>(); 
		
		rowInfo.add( formatNull(dDate));
		rowInfo.add( formatNull(dNo));
		rowInfo.add( formatNull(cName));
		rowInfo.add( formatNull(suryo));
		rowInfo.add( formatNull(tanka));
		rowInfo.add( formatNull(kingaku));
		
		nowlines++;
		
		if(nowlines >= maxlines){
			nowlines = 0;
		}
		
		return rowInfo;
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