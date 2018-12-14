/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: TableDto_Test.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/07/29 Li Lin
 * update
 */
@isTest
private class TableDto_Test
{

	static testMethod void myUnitTest()
    {
		String value = 'test';

		//---------------------------------
		//	テスト対象クラスを生成する
		//---------------------------------
		TableDto tableDto1 = new TableDto();
		TableDto tableDto2 = new TableDto(value);

	}
}