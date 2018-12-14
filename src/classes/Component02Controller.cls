public class Component02Controller extends BaseComponentController{

public PageReference moveNext(){
PageReference nextPage = Page.Page2;
return nextPage;
}
public PageReference movePrevious(){
dto.strA = 'スケジュール画面から戻りました';
PageReference nextPage = Page.Page1;
return nextPage;
}
}