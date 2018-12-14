public with sharing class SampleApexDetailController2 {

  public ApexPages.StandardController sCon = null;
  
  public String paramNewID {get; set;}

  public SampleApexDetailController2(ApexPages.StandardController controller) {
    this.sCon = controller;
    
    //ApexPages.currentPage().getParameters().get('id')
    system.debug(ApexPages.currentPage().getParameters());
    this.paramNewID = ApexPages.currentPage().getParameters().get('newid');
    
  }

  
}