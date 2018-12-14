<html>
<head>
	<title>タスク一括編集</title>
	<base target="_self" />

	<script type="text/javascript">
		var seq = 0;										// フレーム識別用のID
		function initPage() {
			var frm = document.createElement("form");		// POST用のフォームを生成
			//frm.action = "https://c.na7.visual.force.com/apex/AccounTestPage";
			frm.action = "https://c.na7.visual.force.com/apex/paramDummy";
			frm.method = "POST";
			frm.target = "pfr" + seq;

			var hiddenField = document.createElement("input");
			hiddenField.setAttribute("type", "hidden");
			hiddenField.setAttribute("name", "ids");
			var objIds = window.dialogArguments;
			hiddenField.setAttribute("value", objIds);
			frm.appendChild(hiddenField);

			document.body.appendChild(frm);

			var pfr = document.createElement("iframe");		// formのtargetとなるiframeを生成
			pfr.name = "pfr" + (seq++);

			pfr.frameBorder="0";
			pfr.width="100%";
			pfr.height="100%";

			pfr.src = "about:blank";						// 直後はabout:blankを表示する
			var cnt = 0;									// 下のクロージャ内で使うカウンタ
			var onload = pfr.onload = function(){
				if (cnt++ == 0)
					setTimeout(function(){ frm.submit(); }, 0);		// iframeが準備できたらフォームを送信
				else {
					//frm.parentNode.removeChild(frm);		// フォーム受信後、form,iframeを削除
					//pfr.parentNode.removeChild(pfr);
				}
			};

			if (document.all) pfr.onreadystatechange = function(){	/* for IE */
				if (this.readyState == "complete") {		// onloadが動作しないので代用
					pfr.contentWindow.name = pfr.name;		// こちらに名前をsetしないとtargetが動作しない
					onload();
				}
			};
			document.body.appendChild(pfr);
		}
	</script>
</head>
<body onLoad="initPage()">
</body>
<!--<iframe src="https://c.cs6.visual.force.com/apex/Page_TaskBulkUpdate" width="90%" security="restricted" />-->
<!--<iframe src="https://c.cs6.visual.force.com/apex/Page_TaskBulkUpdate" width="90%" height="90%" sandbox="allow-same-origin allow-top-navigation allow-forms allow-scripts" />-->
</html>