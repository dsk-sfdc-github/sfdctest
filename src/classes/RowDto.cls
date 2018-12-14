/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: RowDto.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/07/29 Li Lin
 * update
 */
public without sharing class RowDto 
{
	public List<ColumnDto> columnList { get; set; } // データリスト
	public List<String> columnDataList { get; set; } // 表示内容リスト
	public String style { get; set; } // スタイル
	public String styleClass { get; set; }// スタイルクラス

	public RowDto()
	{
		columnList = new List<ColumnDto>();
		columnDataList = new List<String>();
		this.style = '';
		this.styleClass = '';
	}
}