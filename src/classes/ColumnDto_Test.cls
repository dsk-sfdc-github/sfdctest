/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: ColumnDto_Test.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/07/29 Li Lin
 * update
 */
@isTest
private class ColumnDto_Test 
{
    /**
     *	テストを実行する
     **/
    static testMethod void myUnitTest() 
    {
        //------------------------
        //	テスト対象クラスを生成する
        //------------------------
        ColumnDto cdto = new ColumnDto();
        ColumnDto cdto2 = new ColumnDto( 'String value' , 'String style');
        ColumnDto cdto3 = new ColumnDto( 'String value' );
        ColumnDto cdto4 = new ColumnDto( 'String value', 1, 1 );
        ColumnDto cdto5 = new ColumnDto( 'String value', 1, 1,'String style' );
    }
}