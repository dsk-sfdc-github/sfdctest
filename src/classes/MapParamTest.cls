public without sharing class MapParamTest {

	//public Map<String, String> mapParam {get; put;}

	public String str1 {get; set;}

	//コンストラクタ
	public MapParamTest() {
		system.debug('***デバッグかいし***');
		//mapParam = new Map<String, String>();
		//mapParam.put('1-1', 'あいうえお');
		//mapParam.put('2-1', 'かきくけこ');
		str1 = 'あいうえお';
	}

	public Pagereference registaa() {

		system.debug('***デバッグかいし***');
		//system.debug('***PARAM1-1***'+mapParam.get('1-1'));
		//system.debug('***PARAM2-1***'+mapParam.get('2-1'));
		system.debug('***PARAM2-1***'+str1);

		//mapParam.put('4-1', 'あいうえお');
		//mapParam.put('5-1', 'かきくけこ');
		return null;
	}
}