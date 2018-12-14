<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>InsertMerchandisePrice</fullName>
        <description>製品価格挿入</description>
        <field>UnitPrice__c</field>
        <formula>Merchandise__r.Price__c</formula>
        <name>InsertMerchandisePrice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStockInventry</fullName>
        <field>Quantity__c</field>
        <formula>IF (
     ISNEW(),
     Merchandise__r.Quantity__c - UnitsSold__c,
     Merchandise__r.Quantity__c - (UnitsSold__c - PRIORVALUE(UnitsSold__c))
)</formula>
        <name>UpdateStockInventry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Merchandise__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>LineItemCreated</fullName>
        <actions>
            <name>InsertMerchandisePrice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>品目の新規レコード追加時に品目の単価情報(空の場合)に製品管理情報の単価を反映する。</description>
        <formula>IF (1 == 1, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LineItemUpdated</fullName>
        <actions>
            <name>UpdateStockInventry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>InvoiceStatement__c.Status__c</field>
            <operation>equals</operation>
            <value>オープン</value>
        </criteriaItems>
        <description>品目の個数を製品管理の在庫数に反映させます。</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
