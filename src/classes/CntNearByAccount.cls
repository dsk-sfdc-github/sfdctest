public with sharing class CntNearByAccount {

    public Account a{get;set;}

	//コンストラクタ
    public CntNearByAccount(ApexPages.StandardController stdController) {
        a = (Account)stdController.getRecord();
    }

	//自分以外の取引先情報を取得
    public Object[] getAccountsData(){
        Object[] jsonData = new Object[]{};
        // 表示取引先以外を取得
        for(Account AccountsData : [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode
            FROM Account where Id != :a.Id]){
            jsonData.add(
                '{name:\'' + AccountsData.Name +
                    '\', address:\'' + AccountsData.BillingPostalCode + AccountsData.BillingState + AccountsData.BillingCity + AccountsData.BillingStreet +
                    '\', id:\'' + AccountsData.Id +
                    '\', info:\'' + AccountsData.BillingState + AccountsData.BillingCity + AccountsData.BillingStreet +
                '\'}'
            );
        }
        return jsonData;
    }
}