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
public with sharing class pageDto {
	
	public List<List<string>> rowList { get; set; }
	public Account accInfo { get; set; }
	public Contact ConInfo { get; set; }
	public String pageBreakInfo { get; set; }
	public String campMemoLabel { get; set; }
	public String campMemoInfo { get; set; }
	
	public pageDto(Account acc, Contact Con, String PBInfo)
	{
		this.rowList = new List<List<string>>();
		this.accInfo = acc;
		this.ConInfo = Con;
		this.pageBreakInfo = PBInfo;
	}
}