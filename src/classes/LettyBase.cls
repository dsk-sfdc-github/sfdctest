/*
 * Copyright(C) Letty Co.Ltd. 2011 All Rights Reserved.
 *
 * system name  : Interbrains
 * class name	  : LettyBase.cls
 * remarks		  : Base class for Apex code development
 * version		  : 1.0.0
 * create		    : [1.0.0] 2011/08/29 Toshiaki Hamano
 * update       :
 */
public virtual class LettyBase {

	/*==================================
	 *	private宣言部
	====================================**/
	//Cookieクラス
	protected CookieUtil cookieUtil;

	/**
	 *	コンストラクタ
	 */
	public LettyBase()
	{
		cookieUtil = new CookieUtil();
	}
}