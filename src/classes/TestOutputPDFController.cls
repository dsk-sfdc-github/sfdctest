public with sharing class TestOutputPDFController {

    public List<List<Account>> pageData {get; set;}

    //コンストラクタ
    public TestOutputPDFController() {
        this.pageData = new List<List<Account>>();
        List<Account> rowData = [Select Id, Name From Account];

        //for (Account acc:rowData) {
            pageData.add(rowData);
        //}
    }

}