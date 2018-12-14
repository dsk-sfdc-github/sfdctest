/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name	: 
 * class name	: ColumnDto.cls
 * remarks		: 
 * version		: 1.0.0
 * create		: [1.0.0] 2011/07/29 Li Lin
 * update
 */
public without sharing class ColumnDto 
{
	public String value { get; set; }
    public Integer rowspan { get; set; }
    public Integer colspan { get; set; }
	public String style { get; set; }
	public String styleClass { get; set; }
   
	public ColumnDto()
	{
		this.value = '';
	    this.rowspan = 1;
	    this.colspan = 1;
    	this.style = '';
    	this.styleClass = '';
	}
	
	public ColumnDto( String value ,String style)
	{
		this.value = value;
	    this.rowspan = 1;
	    this.colspan = 1;
    	this.style = style;
    	this.styleClass = '';
	}
	
	public ColumnDto( String value )
	{
		this.value = value;
	    this.rowspan = 1;
	    this.colspan = 1;
    	this.style = '';
    	this.styleClass = '';
	}
	
	public ColumnDto( String value, Integer rowspan, Integer colspan )
	{
		this.value = value;
	    this.rowspan = rowspan;
	    this.colspan = colspan;
    	this.style = '';
    	this.styleClass = '';
	}
	public ColumnDto( String value, Integer rowspan, Integer colspan,String style )
	{
		this.value = value;
	    this.rowspan = rowspan;
	    this.colspan = colspan;
    	this.style = style;
    	this.styleClass = '';
	}
}