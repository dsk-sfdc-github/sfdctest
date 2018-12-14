/**
 *	PDF作成テスト
 *
*/
public without sharing class TestCreatePDF {

	public String renderAsStr {get; set;}

	public String outputName {get; set;}

	public Account acc {get; set;}

	//コンストラクタ
	public TestCreatePDF() {
		this.renderAsStr = '';
		//IDを拾い、DB検索処理
		String accId = Apexpages.currentPage().getParameters().get('id');
		this.acc = [Select Name From Account Where id = :accId];

		this.outputName = this.acc.Name;
		//this.outputName = 'あいうえお';
		this.renderAsStr = 'aa';
	}

	public Pagereference seikyuUp() {
		//更新処理

		if (this.outputName == 'あいうえお') {
			System.debug('******サイズはあり');
			this.renderAsStr = 'pdf';
		} else {
			System.debug('******サイズはなし');
			this.renderAsStr = '';
		}
		return null;
	}
}