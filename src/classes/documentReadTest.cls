public without sharing class documentReadTest {
	
	//ドキュメントの中身
	public string documentValueTxt {get; set;}
	
	//コンストラクタ
	public documentReadTest() {
		String fileName = 'hamanotest';
		List<Document> documnetList = [select Body from Document where Name = :fileName];

		this.documentValueTxt = documnetList.get(0).Body.toString();
	}
}