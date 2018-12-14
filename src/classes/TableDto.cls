/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: TableDto.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/08/29 Li Lin
 * update
 */
public with sharing class TableDto {
	public List<RowDto> rowList { get; set; }
	public String style { get; set; }
	public String name { get; set; }
	public String styleClass { get; set; }
	public Account accInfo { get; set; }
	public Contact ConInfo { get; set; }
	public String pageBreakInfo { get; set; }
	public String campMemoLabel { get; set; }
	public String campMemoInfo { get; set; }
		
	public TableDto()
	{
		rowList = new List<RowDto>();
		this.style = '';
		this.styleClass = '';
		this.name='';
		this.accInfo = new Account();
		this.ConInfo = new Contact();
	}
	
	public TableDto(Account acc, Contact Con, String PBInfo)
	{
		rowList = new List<RowDto>();
		this.style = '';
		this.styleClass = '';
		this.name='';
		this.accInfo = acc;
		this.ConInfo = Con;
		this.pageBreakInfo = PBInfo;
	}
}