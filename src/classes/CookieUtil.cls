//Cookieクラス(未完成)
public class CookieUtil {
	/*==================================
	 *	private宣言部
	====================================**/

	//請求書検索条件(Cookie用)
	protected final String COOKIE_DATA_INVOICE_SEARCH = 'invoiceSeach';

	//請求書選択担当者ID(Cookie用)
	protected final String COOKIE_DATA_INVOICE_CONTACT = 'invoiceContact';

	//protected Cookie cookieData {get; set;}

	/**
	 *	コンストラクタ
	 */
	public CookieUtil()
	{
		cookieTimeStart();
	}

	/**
	 *	@method	タイムstart
	 **/
	private void cookieTimeStart()
	{
		//タイム情報をCookieに設定
		Datetime timestart = datetime.now();
		Cookie cookieData = null;
		cookieData = new Cookie('Time',String.valueOf(timestart),null,-1,false);
		ApexPages.currentPage().setCookies(new Cookie[]{cookieData});
	}

	/**
	 *	@method	タイム情報の削除
	 **/
	private void cookieTimeDelete()
	{
		//タイム情報の削除
		Cookie cookieData = null;
		cookieData = new Cookie('Time',null,null,0,false);
		ApexPages.currentPage().setCookies(new Cookie[]{cookieData});
	}

	/**
	 *	@method	タイムアウト用データの比較
	 **/
	private Boolean cookieTimeDef()
	{
		Cookie cookie_time;
		cookie_time = ApexPages.currentPage().getCookies().get('Time');
		if(cookie_time==null)
		{
			return true;
		}
		Datetime nowtime = Datetime.now();
		system.debug('##nowtime###'+nowtime);
		string showtime = cookie_time.getValue();
		Datetime dtshowtime = Datetime.valueOf(showtime);

		long gennzai = nowtime.getTime();
		long logintime = dtshowtime.getTime();
		long sabun = gennzai - logintime;
		if(sabun > 3600000)//タイムアウト時間は１時間と設定
		{
			//タイムアウトしているのでログイン情報の削除　※現在はタイムアウト設定なし　吉田
			//cookieLoginedInfoDelete();
			//return false;
		}
		//正常
		return true;
	}

	/**
	 *	@method	Cookieに設定されている情報を返します
	 *	@return
	 **/
	public Cookie GetCookie(String cookieName)
	{
		if(cookieTimeDef()){
			Cookie cookie = null;

			try {
				cookie = ApexPages.currentPage().getCookies().get(cookieName);
			} catch (Exception e) {
				System.debuG(e.getMessage());
			}
			return cookie;
		}
		return null;
	}

	/**
	  *	@method	Cookieから情報の削除
	  **/
	public void cookieDelete(String cookieName)
	{
		//Cookieに登録してあるデータの削除
		Cookie Info;
		Info = new Cookie(cookieName,null,null,0,false);
		ApexPages.currentPage().setCookies(new Cookie[]{Info});
	}

	/**
	  *	@method	Cookieに情報をセット
  	**/
	public void cookieSet(String setName, String setParam) {
		Cookie cookieData = null;
		cookieData = new Cookie(setName,setParam,null,0,false);
		ApexPages.currentPage().setCookies(new Cookie[]{cookieData});
	}
}