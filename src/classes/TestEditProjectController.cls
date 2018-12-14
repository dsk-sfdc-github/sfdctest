public with sharing class TestEditProjectController {

	//遷移元ID
	public String selectionId {get; private set;}

	//新規フラグ
	public Boolean renderedRegistFlg {get; private set;}

	//更新フラグ
	public Boolean renderedUpdateFlg {get; private set;}

	//public TestProjectMst__c testProjectRec {get; private set;}
	public TestProjectMst__c testProjectRec {get; set;}

	//コンストラクタ
	public TestEditProjectController() {
		This.renderedRegistFlg = false;
		This.renderedUpdateFlg = false;
		This.testProjectRec = new TestProjectMst__c();
		//IDが渡ってきている場合、取得し更新モードへ
		This.selectionId = null;
		This.selectionId = System.currentPageReference().getParameters().get('hiddenId');

		if (This.selectionId != null) {
			This.renderedUpdateFlg = true;
			This.testProjectRec = [
									SELECT
										Name
										,TestProjectName__c
										,Status__c
										,StartDate__c
										,EndDate__c
										,Manager__c
									FROM
										TestProjectMst__c
									WHERE
										Name = :selectionId
									];
		} else {
			This.renderedRegistFlg = true;
		}
	}

	//登録処理
	public Pagereference registProject() {
		//入力チェック

		try {
			insert This.testProjectRec;
		} catch (Exception e) {
			//例外処理
		}

		//メッセージ設定

		//検索画面へ遷移
		return Page.TestSearchProject;
	}

	//更新処理
	public Pagereference updateProject() {
		//入力チェック

		try {
			update This.testProjectRec;
		} catch (Exception e) {
			//例外処理
		}

		//メッセージ設定

		//検索画面へ遷移
		return Page.TestSearchProject;
	}

	//削除処理
	public Pagereference deleteProject() {
		try {
			delete This.testProjectRec;
		} catch (Exception e) {
			//例外処理
		}

		//メッセージ設定

		//検索画面へ遷移
		return Page.TestSearchProject;
	}

	//戻る処理
	public Pagereference back() {
		return Page.TestSearchProject;
	}

}