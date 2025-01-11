'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:IDEX_Automation
'Action Name: New_Order
'Function/Sub Name:NewOrderEn,NewOrderEs,NewOrderCh
'Description:To create a new Order
'Argument List: Product IDs (5),Product Quantity (5),Expected Total,Expected Order Submission Message
'Return Value:TaskResponse
'Author: Vikas Joshi
'Creation Date:   15 Nov 2013      
'Calling Functions:Start_Execution
'Called Functions:ReadDataTable,ClickCheckBox,GetText,WriteToOutputSheet
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:IDEXX QA Order
'Comments: Cross-browser compatible . Tested for IE,Firefox
'Copyrights:Marlabs Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----

'Initialize variables with test data
Call ReadDataTable("Global")
ProductID1=Values(4)
ProdQuant1=Values(5)
ProductID2=Values(6)
ProdQuant2=Values(7)
ProductID3=Values(8)
ProdQuant3=Values(9)
ProductID4=Values(10)
ProdQuant4=Values(11)
ProductID5=Values(12)
ProdQuant5=Values(13)
ExpectedTotal=Values(14)
ExpectedOrderMsg=Values(15)

		'UPDATE ALL THE XPATHS WITH HTML IDS
Browser("name:=.*").Page("title:=IDEXX.*").Link("html id:=zzwelcome_doclink_neworder").Click 'New Order

'Populate Product Data
For i  = 4 To 12 Step 1
	Call SetText(oDescription(i),Values(i),"")
Next 

Browser("name:=.*").Page("title:=IDEXX.*").WebButton("html id:=zzbas1salesorder_next").Click'xpath:=//td[2]/p/input[2]").Click 'Next

'Get Total amount & validate with the expected Total amount
Total= Browser("name:=.*").Page("title:=IDEXX.*").WebElement("xpath:=//td/table/tbody/tr[2]/td/p").GetROProperty("innertext")'WebElement("xpath:=//td/table/tbody/tr[2]/td/p").GetROProperty("innertext")
If ExpectedTotal=Total Then				
	Report.LogReport micPass,"Total Amount match" ,"Expected Total= " & ExpectedTotal & ",Actual total= " & total
Else
	Report.LogReport micFail,"Total Amount doesn't match" ,"Expected Total= " & ExpectedTotal & ",Actual total= " & total
End If
Call ClickCheckBox("m_ba_bd_LS_H-ZZACCTRM","ON") 'accept terms & conditions @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders 2").WebElement("Error")_;_script infofile_;_ZIP::ssf11.xml_;_
Browser("name:=.*").Page("title:=IDEXX.*").WebButton("html id:=zz.*step1_s.*").Click'WebButton("xpath:=//p[3]/input[2]").Click 'Submit Order
OrderSubmit= GetText("zzbasket_shippingcosts")'Order Submit message

If Browser("name:=IDEXX.*").page("title:=IDEXX.*").WebElement("innertext:=Order Number:.*","html tag:=P").Exist(3) Then'WebElement("innertext:=Order Number:.*","html tag:=P").Exist(3) Then
	OrderNumber=Browser("name:=IDEXX.*").page("title:=IDEXX.*").WebElement("innertext:=Order Number:.*","html tag:=P").GetROProperty("innertext")'WebElement("innertext:=Order Number:.*","html tag:=P").GetROProperty("innertext")
	OrderNumber=Trim(Mid(OrderNumber,14,len(OrderNumber)))
ElseIf Browser("name:=IDEXX.*").page("title:=IDEXX.*").WebElement("innertext:=Auftragsnummer:.*","html tag:=P").Exist(3) Then'WebElement("innertext:=Auftragsnummer:.*","html tag:=P").Exist(3) Then
	OrderNumber=Browser("name:=IDEXX.*").page("title:=IDEXX.*").WebElement("innertext:=Auftragsnummer:.*","html tag:=P").GetROProperty("innertext")'WebElement("innertext:=Auftragsnummer:.*","html tag:=P").GetROProperty("innertext")
	OrderNumber=Trim(Mid(OrderNumber,16,len(OrderNumber)))
ElseIf Browser("name:=IDEXX.*").page("title:=IDEXX.*").WebElement("innertext:=Número de pedido:.*","html tag:=P").Exist(3) Then'WebElement("innertext:=Número de pedido:.*","html tag:=P").Exist(3) Then
	OrderNumber=Browser("name:=IDEXX.*").page("title:=IDEXX.*").WebElement("innertext:=Número de pedido:.*","html tag:=P").GetROProperty("innertext")'WebElement("innertext:=Número de pedido:.*","html tag:=P").GetROProperty("innertext")
	OrderNumber=Trim(Mid(OrderNumber,18,len(OrderNumber)))
End If @@ hightlight id_;_Browser("IDEXX Online Orders").Page("IDEXX Online Orders").WebButton("Submit Order")_;_script infofile_;_ZIP::ssf9.xml_;_

'Validate Order Submission message appeared as expected, if yes store Order Number in Test Data file
If Instr(1,OrderSubmit,ExpectedOrderMsg)>0 Then				
	Call WriteToOutputSheet(OrderNumber)
	TaskResponse ="Completed"
	Report.LogReport micPass,"Order submitted successfully.-" & OrderNumber,OrderSubmit
Else
	Report.LogReport micFail,"Order Not submitted successfully",""
	TaskResponse ="Fail"
End If

Browser("name:=.*").Page("title:=IDEXX.*").WebButton("html id:=zzbas2step_close").Click'WebButton("xpath:=//p[4]/input[2]").Click 'Close