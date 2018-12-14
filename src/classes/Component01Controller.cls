public class Component01Controller extends BaseComponentController{

public PageReference moveNext(){
PageReference nextPage = Page.Page2;
return nextPage;
}
public PageReference movePrevious(){
PageReference nextPage = Page.Page1;
return nextPage;
}

}