trigger HandleProductPriceChange on Merchandise__c (after update) {

	//LineItem__c(品目)カスタムオブジェクトから情報をリストで取得
	//Trigger.new 新規レコードを判定
	List<LineItem__c> openLineItems = [
										SELECT
											j.UnitPrice__c,
											j.Merchandise__r.Price__c
										FROM
											LineItem__c j
										WHERE
											j.InvoiceStatement__r.Status__c = '交渉中'
											AND j.Merchandise__r.id IN :Trigger.new
										FOR UPDATE
									];

	//リストで取得したデータのLoop
	for (lineItem__c li:  openLineItems) {
		//製品価格 < 現単価
		if (li.Merchandise__r.Price__c < li.UnitPrice__c) {
			li.UnitPrice__c = li.Merchandise__r.Price__c;
		}
	}

	//更新処理
	update openLineItems;
}