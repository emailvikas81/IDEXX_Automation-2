'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:IDEX_Automation
'Action Name: Login
'Function/Sub Name:Login
'Description:To Login to IDEXX application
'Argument List: URL,Username,Password,BrowserName
'Return Value: 1 on Successful login, 0 on Failure;TaskResponse
'Author: Vikas Joshi
'Creation Date:  15 Nov 2013      
'Calling Functions:Start_Execution
'Called Functions:Login,ReadDataTable
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:IDEXX QA Order
'Comments: Cross-browser compatible . Tested for IE,Firefox
'Copyrights:Marlabs Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----


'Initialize variables with test data
Call ReadDataTable("Global")
URL=Values(4)
Username=Values(5)
Password=values(6)
BrowserName=values(7)

'Call Login Function
Call Login(URL,Username,Password)
 

 Function Login(URL,Username,Password)
 
 	'Clean Start : Close open browsers
 	SystemUtil.CloseProcessByName "IEXPLORE.EXE"
 	SystemUtil.CloseProcessByName "Firefox.EXE" 

 	'Based on user-preference launch browser
 	Select Case BrowserName
 		Case "IE" 		 	  
 			SystemUtil.Run "iexplore.exe" 	
 			Report.LogReport micDone, " Browser : IE selected",""
 		
 		Case "Firefox" 			 
			SystemUtil.Run "Firefox.exe" 			
 			Report.LogReport micDone, " Browser : Firefox selected",""
 		
 		Case Else
 			Report.LogReport micWarning, " Browser value not selected properly in TestData sheet. Selecting IE as default",""
 			SystemUtil.Run "iexplore.exe"
 	End Select
	
	'Open URL
	Browser("Name:=.*").Navigate URL
	
	'If page not displayed	
	If Browser("name:=.*").Page("title:=IDEXX.*").WebEdit("name:=i_lg_gv_userid").Exist(30) <> True Then
		Report.LogReport micFail, "Page not displayed after 30 sec","URL:" & URL
		TaskResponse ="Fail"
		ExitTest	'End Test
	End If
	
	'Enter Login Credentials
	'Browser("name:=.*").Page("title:=IDEXX.*").WebEdit("name:=i_lg_gv_userid").Set Username	'Browser("name:=.*").Page("title:=IDEXX.*").WebEdit("name:=i_lg_gv_pwd").SetSecure Password @@ hightlight id_;_Browser("MSN").Page("IDEXX Online Orders").WebEdit("i lg gv pwd")_;_script infofile_;_ZIP::ssf3.xml_;_
	For i  = 5 To 6 Step 1
		Call SetText(oDescription(i),Values(i),"")
	Next 	
	
	Browser("name:=.*").Page("title:=IDEXX.*").WebButton("type:=submit").Click @@ hightlight id_;_Browser("MSN").Page("IDEXX Online Orders").WebButton("Log In")_;_script infofile_;_ZIP::ssf4.xml_;_
	
	'Verify Successful Login ' Image needs an id
	If Browser("name:=.*").Page("title:=IDEXX.*").WebElement("class:=boxbody-left","html id:=menuleft_user").Exist(15) Then 'Link("html id:=zzwelcome_doclink_neworder").Exist(15) Then 'Image("xpath:=//div[@id='zzwelcome_img']/a/img").Exist(15) Then 'Link("name:=New Order","html id:=zzwelcome_doclink").Exist(5) Or Browser("name:=.*").Page("title:=IDEXX.*").Link("name:=Neue Bestellung","html id:=zzwelcome_doclink").Exist(5) Or Browser("name:=.*").Page("title:=IDEXX.*").Link("name:=Pedido Nuevo","html id:=zzwelcome_doclink").Exist(5) Then 'New order won't be same for all languages
		TaskResponse ="Completed"
		Report.LogReport micPass, "Login Successful",""
		Login=1
	Else
		TaskResponse ="Fail"
		Report.LogReport micFail, "Login Unsuccessful",""
		Login=0
		ExitTest	'End Test
	End If
 End Function
 