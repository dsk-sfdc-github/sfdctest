public with sharing class TestSearchProjectController {

    //検索条件：プロジェクト名
    public String searchProjectName {get; set;}

    //一覧レコード格納リスト
    public List<TestProjectMst__c> listProject {get; private set;}

    //レコード選択ID格納
    public String selectionId {get; private set;}

    //一覧表示フラグ
    public Boolean gridRenderedFlg {get; private set;}

    //コンストラクタ
    public TestSearchProjectController() {
        //検索条件・リスト一覧のクリア
        This.listProject = null;
        This.gridRenderedFlg = false;

        //検索項目の作成(リストボックス等)
    }

    //検索処理
    public PageReference searchProject() {
        //画面上の検索条件パラメータの取得
        //String projectName = Apexpages.currentPage().getParameters().get("searchProjectName");

        //一覧の取得
        This.listProject = null;

        /**This.listProject = [
                            SELECT
                                Name
                                ,TestProjectName__c
                                ,StartDate__c
                                ,EndDate__c
                                ,Manager__c
                                ,Status__c
                            FROM
                                TestProjectMst__c
                            WHERE
                            	Name like \'%\' + This.searchProjectName + \'%\'
                            ];*/
        String sql = 'SELECT Name ,TestProjectName__c ,StartDate__c,EndDate__c,Manager__c,Status__c FROM TestProjectMst__c ';

        if (This.searchProjectName != '') {
        	sql = sql + 'WHERE Name like \'%' + This.searchProjectName + '%';
        }

        //queryResult = Database.query(qryString) ;
        try {
        	This.listProject = Database.query(sql);
        } catch (Exception e) {
        	//例外処理
        }


		//一覧が取得できている場合、グリッドを表示する。
		if (This.listProject != null) {
			This.gridRenderedFlg = true;
		}

        return Page.TestSearchProject;
    }

    //新規登録押下時
    public Pagereference regist() {
        return Page.TestEditProject;
    }

    //編集画面遷移時
    public Pagereference edit() {
        //IDを設定し、編集画面へ遷移
        //TestSearchProject.getParameters().put('selectionId', This.selectionId);
        return Page.TestEditProject;
    }


}