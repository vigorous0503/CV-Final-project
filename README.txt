----------------------------------R-E-A-D-M-E---------------------------------

A > 執行main.m

B > main.m裡的執行程序
	
	1 > 運用source code(sift_mosaic.m)，會得到任意兩張之間sift的match數目、

            RANSEC後的inlier數目。

	2 > 分類 (classification)
	
	    將1>得到的資訊送回main.m裡，矩陣compute會初步的判斷兩張圖片是否可以

            拼接的依據，接下來會將這個矩陣送進我們自行撰寫了兩個副程式
      
            (group.m和check.m)，以達到我們搜尋正確配對的目的。

	    group.m是用來根據矩陣Compute，判斷哪些圖片是一組，且回傳同組的圖片代

            碼出去。

	    check.m的目的是讓電腦自己計算好各組，一次自動跑出來所有結果，其主

	    要是延用第一次使用group.m的結果，檢查是否還有剩下沒被分類到的圖片。

        3 > 排序(sorting)

	    由上面分類好場景的圖片會再此做排序，以便後面做影像拼接(stitching)，

	    由2>得到的結果會送進我們寫的 stitch.m 和 FindTheRef.m裡做排序。

        4 > 影像拼接(stitching)

	    將3>做過排序後的圖片送進source code(MultipleStitch.m)做影像拼接。

C > 結果
	
	分類好且拼接後的場景會儲存於result這個資料夾裡。
          

	
	
	
