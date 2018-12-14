/** ページング機能クラス */
public class ApexPagingController {

	/** ページングコントローラ */
	public ApexPages.StandardSetController pageController{get; set;}

	/** 最大ページ数 */
	public Integer maxPageNo  {get; private set;}

	/** 1ページの行数 */
	private Integer maxRow = 20;

	/** コンストラクタ */
	public ApexPagingController(Database.Querylocator locator, Integer rewriteMax) {
		if (rewriteMax != null) {
			this.maxRow = rewriteMax;
		}

		this.pageController = new ApexPages.StandardSetController(locator);

		//最大ページ数を設定
    	if (pageController.getResultSize() > 0 ) {
			// 取得されたデータがある場合はページングの設定を行う
			maxPageNo = pageController.getResultSize() / maxRow ;
			// 割り切れなかった部分がある場合はその分＋１させる
			if (Math.Mod(pageController.getResultSize(), maxRow ) > 0 ) {
				maxPageNo++;
			}
		} else {
			maxPageNo = 1;
		}

		//レコード表示数を設定
		pageController.setPageSize(maxRow);
	}

	/** レコードを返却します。返却先でキャストして下さい。 */
	public List<Sobject> getRecord() {
		return this.pageController.getRecords();
	}

	/** 最初のページへ */
    public List<Sobject> first() {
    	this.pageController.first();
        return this.getRecord();
    }

    /** 前のページへ */
    public List<Sobject> previous() {
        this.pageController.previous();
        return this.getRecord();
    }

    /** 次のページへ */
    public List<Sobject> next() {
        this.pageController.next();
        return this.getRecord();
    }

    /** 最後のページへ */
    public List<Sobject> last() {
        this.pageController.last();
        return this.getRecord();
    }

	/** 次のレコードが存在するかどうか */
    public Boolean getHasNext() {
    	return this.pageController.getHasNext();
    }

	/** 前のレコードが存在するかどうか */
    public Boolean getHasPrevious() {
    	return this.pageController.getHasPrevious();
    }

    public Integer getPageNumber() {
    	return this.pageController.getPageNumber();
    }
}