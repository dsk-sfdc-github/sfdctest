public with sharing class TestAjax {

	public Account acc {get; set;}
	
	public boolean accRendered {get; set;}
	
	//public String 
	
	//コンストラクタ
    public TestAjax(ApexPages.StandardController controller) {
		//案件情報を初期化
		this.acc = new Account();
		this.accRendered = true;
    }
    
    public Pagereference getAcc() {
    	return null;	
    }
}