
'Initialize variables with test data
Call ReadDataTable("Global")
FilterBy=Values(4)
OrderID=Values(5)

Browser("name:=.*").Page("title:=IDEXX.*").Link("html id:=zzwelcome_doclink_orderhstry","name:=Order History / Track Shipments").Click @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders").Link("Order History / Track")_;_script infofile_;_ZIP::ssf1.xml_;_
 @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders 2").WebEdit("m do ds LS S-CHARS")_;_script infofile_;_ZIP::ssf2.xml_;_
Browser("name:=.*").Page("title:=IDEXX.*").WebList("name:=m_do_ds_LS_S-CHARA").Select FilterBy @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders 2").WebList("m do ds LS S-CHARA")_;_script infofile_;_ZIP::ssf10.xml_;_
Browser("name:=.*").Page("title:=IDEXX.*").WebEdit("name:=m_do_ds_LS_S-CHARS").Set OrderID
'For i  = 4 To 5 Step 1
'	Call SetText(oDescription(i),Values(i),"WebList")
'Next 
Browser("name:=.*").Page("title:=IDEXX.*").WebButton("html id:=zzdoc1search_searchdoc","name:=Search").Click @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders 2").WebButton("Search")_;_script infofile_;_ZIP::ssf11.xml_;_
'Browser("IDEXX Online Orders").Page("IDEXX Online Orders_2").WebElement("https://qaorder.idexx.com/zzb2").Check CheckPoint("SearchOrder") @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders 2").WebElement("https://qaorder.idexx.com/zzb2")_;_script infofile_;_ZIP::ssf12.xml_;_
'Value="1455924793"
	'Verify Successful Login ' Image needs an id
	If Browser("name:=.*").Page("title:=IDEXX.*").WebElement("outertext:=" & OrderID ).Exist(15) Then 'Image("xpath:=//div[@id='zzwelcome_img']/a/img").Exist(15) Then 'Link("name:=New Order","html id:=zzwelcome_doclink").Exist(5) Or Browser("name:=.*").Page("title:=IDEXX.*").Link("name:=Neue Bestellung","html id:=zzwelcome_doclink").Exist(5) Or Browser("name:=.*").Page("title:=IDEXX.*").Link("name:=Pedido Nuevo","html id:=zzwelcome_doclink").Exist(5) Then 'New order won't be same for all languages
		TaskResponse ="Completed"
		Report.LogReport micPass, "Search Successful","Order ID=" & OrderID
	Else
		TaskResponse ="Fail"
		Report.LogReport micFail, "Search Unsuccessful","Order ID=" & OrderID
		ExitTest	'End Test
	End If