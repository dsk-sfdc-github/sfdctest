public with sharing class TestToDoListController {

    public String param =null;
    
    public void setParam(String s) {
        This.param = s;
    }
    
    public String getParam() {
        return This.param;
    }
    
    public Boolean renderedVal { get; set; }
    
    public Boolean renderedVal2 { get; set; }

    public String selectOption { get; set; }


    public ToDoTest__c toDoRec {get; set;}

    public String toName {get; set;}

    public String testName {get; set;}

    private final ToDoTest__c toDo;

    public TestToDoListController() {
        This.toDoRec = new ToDoTest__c();
        //This.testName = '濱野';
        This.renderedVal = true;
        This.renderedVal2 = false;
    }

    //リストボックスの切替を制御
    public PageReference chgToDoList() {
        This.toDoRec.toName__c = This.getParam();
        System.debug('chgToDoListkitayo');
        
        if (toDoRec.TodoList__c == '新規顧客') {
            This.renderedVal = true;
            This.renderedVal2 = false;
        } else {
            This.renderedVal = false;
            This.renderedVal2 = true;
        }
        
        return null;
    }
    
    public String getTestName() {
        return This.testName;
    }
}