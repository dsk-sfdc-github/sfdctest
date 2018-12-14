@istest
public class FieldEntity_Test {
    static testMethod void myUnitTest() {
        FieldEntity  cls = new FieldEntity ( Schema.SObjectType.Enquete__c.fieldSets.Enquete.getFields()[0]);
    }
}