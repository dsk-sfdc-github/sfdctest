public with sharing class EventEditController_Report {

 Event event;
 Opportunity opp;
 
     public EventEditController_Report() {
         event = new Event();
     }

    public Event getEvent() {
      //if(event ==null)
        //event = [select id, Location, Subject,ActivityDatetime,Description from Event where id = :System.currentPageReference().getParameters().get('id')];
        //event = new Event();
      return event;
    }
 
    public Opportunity getOpportunity() {
      String strWhatId = System.currentPageReference().getParameters().get('whatid');
      if(strWhatId == ''){
        opp = new Opportunity();
      }else if(opp == null){
        opp= [select id,Name,StageName,Description,CloseDate,Amount from Opportunity where id = :strWhatId ];
      }
      return opp;
    }
    
    public PageReference saveApp(){
      String strWhatId = System.currentPageReference().getParameters().get('whatid');
        //IDを設定
        event.WhatId = strWhatId;
      insert event;

      
      if(strWhatId != ''){
        update opp;
      }
      
      PageReference eventPage = new PageReference('/apex/CloseHTML');
      eventPage.setRedirect(true);
      return eventPage;

    }
    public PageReference cancel(){
      
      PageReference eventPage = new PageReference('/apex/CloseHTML');
      eventPage.setRedirect(true);
      return eventPage;

    }
}