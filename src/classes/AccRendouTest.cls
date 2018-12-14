public class AccRendouTest {

    public Account acc {get; set;}

    public AccRendouTest() {
        acc = [select Id, Field12__c, Field13__c From Account Where Id = '001A0000014oRt7' ];
        
        
    }
    
    
}