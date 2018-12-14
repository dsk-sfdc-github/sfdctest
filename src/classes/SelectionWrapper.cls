public with sharing class SelectionWrapper {

	//元オブジェクト
	public CustomObject11__c record {get; private set;}
	//public AggregateResult record {get; private set;}

	//発行チェックボックスの選択状態
	public Boolean outputSelected {get; set;}

	//案件ごとチェックボックスの選択状態
	public Boolean projectSelected {get; set;}

	//案件数
	public Integer cntProject {get; set;}

	//済案件数
	public Integer cntProjectInvoiced {get; set;}

	//締め日
	public String closePoint {get; set;}

	//案件IDリスト
	public List<ID> projectIdList {get; set;}

	//コンストラクタ
	public SelectionWrapper(CustomObject11__c record) {
    	this.record = record;
		this.outputSelected = false;
		this.projectSelected = false;
	}
}