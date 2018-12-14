public with sharing class GanttChartTestController {

    public String getHeaderTitle() {
        This.projectId = ApexPages.currentPage().getParameters().get('selectId');
        String prrojectName = [select name from pjmng__c where id = :This.projectId].name;
        return prrojectName;
    }


    public String projectId {get; set;}

    //public task__c[] taskList {get; set;}

    //コンストラクタ
    //public GanttChartTestController() {
        //System.currentPageReference().getParameters().get('Id');
    //}

    //初期処理
    public Pagereference init() {
        //List<task__c> taskList = new List<task__c>();

        //This.taskList = [Select Name From task__c];
        //This.projectId = 'hamanoId';
        //This.projectId = System.currentPageReference().getParameters().get('selectId');
        This.projectId = ApexPages.currentPage().getParameters().get('selectId');
        return null;
    }

}