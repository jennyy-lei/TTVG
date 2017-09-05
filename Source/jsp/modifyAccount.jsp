<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.base.Constant" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Account" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>

<!DOCTYPE html>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%@include file="../includes/account.jsp" %>

<%
	String errorMessage = "";

    Session dbSession = null;
	Transaction transaction = null;
	String op = null;
	String firstName = null;
	String lastName = null;
	String chineseName = null;
	String phone = null;
	String mobile = null;
	String email = null;
	String address = null;
	String password = null;
	String confirmPassword = null;
	
	boolean isSuccess = false;
	
    try{
		op = request.getParameter("op");
		if ( user != null && Constant.PARAM_ACTION_MODIFY.equalsIgnoreCase(op) ) {
			// This step will read hibernate.cfg.xml and prepare hibernate for use
			dbSession = MyDatabaseFeactory.getSession();
			
			//Reload the account into a new session
			account = TableRecordOperation.getRecord(dbSession, account.getId(),Account.class);
			user = account.getPerson();
			
			//Get Post data
			request.setCharacterEncoding("UTF-8");
			firstName = request.getParameter("firstName");
			lastName = request.getParameter("lastName");
			chineseName = request.getParameter("chineseName");
			phone = request.getParameter("phone");
			mobile = request.getParameter("mobile");
			email = request.getParameter("email");
			address = request.getParameter("address");
			password = request.getParameter("password");
			confirmPassword = request.getParameter("confirmPassword");
			
			//Save the posted account item if not empty
			if ( (firstName != null && firstName.length() > 0) && (lastName != null && lastName.length() > 0) ) {
				transaction = dbSession.beginTransaction();

				if ( email != null && email.length() > 0)
					account.setEmail(email);
					
				if ( password != null && password.length() > 0 && password.equals(confirmPassword))
					account.setPassword(password);
				
				if ( firstName != null && firstName.length() > 0)
					user.setGivenName(firstName);
					
				if ( lastName != null && lastName.length() > 0)
					user.setLastName(lastName);
					
				if ( chineseName != null && chineseName.length() > 0 )
					user.setChineseName(new String(chineseName.getBytes("ISO8859_1"), "UTF-8"));
					
				if ( phone != null && phone.length() > 0)
					user.setPhone(phone);
					
				if ( mobile != null && mobile.length() > 0)
					user.setMobile(mobile);
					
				if ( address != null && address.length() > 0)
					user.setAddress(address);
				
				dbSession.update(account);		

				//Log the audit
				dbSession.save(account.getAudit(account, op));
				
				transaction.commit();
				
				isSuccess = true;

				session.setAttribute("account",  account);
			}
        }
    }catch(Exception e){
		if ( transaction != null ) transaction.rollback();
		System.out.println(e.getMessage());
		errorMessage = e.getMessage();
    }finally{
      // Close the session after work
    	if (dbSession != null) {
		    try{
				dbSession.flush();
				dbSession.close();
			}catch(Exception ex1){
				errorMessage = ex1.getMessage();
			}				
    	}
	}
%>

<html>
	<head>
		<script src="../html/inputValidation.js"></script>
	</head>
	<body>
<%=errorMessage%>
		<div id = "html-content">
<%
	if ( user != null  ) {
		if ( !Constant.PARAM_ACTION_MODIFY.equalsIgnoreCase(op) ) {
%>
			<h1><%=p.getProperty("modifyAccount.title")%></h1>
			<fieldset>
				<form action="modifyAccount.jsp" method="POST">
					<input type="hidden" name="op" value="Modify">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("modifyAccount.sn")%>:</td><td><input type="text" name="firstName"  value="<%=user.getGivenName()%>" onchange="validateText(this);"></td></tr>
						<tr><td align="right"><%=p.getProperty("modifyAccount.gn")%>:</td><td><input type="text" name="lastName" value="<%=user.getLastName()%>" onchange="validateText(this);"></td></tr>
						<tr><td align="right"><%=p.getProperty("modifyAccount.cn")%>:</td><td><input type="text" name="chineseName" value="<%=user.getChineseName()%>"></td></tr>
						<tr><td align="right"><%=p.getProperty("modifyAccount.tel")%>:</td><td><input type="text" name="phone" value="<%=user.getPhone()%>" onchange="validatePhone(this);"></td></tr>
						<!--tr><td align="right"><%=p.getProperty("modifyAccount.mobile")%>:</td><td><input type="text" name="mobile" value="<%=user.getMobile()%>" onchange="validatePhone(this);"></td></tr-->
						<tr><td align="right"><%=p.getProperty("modifyAccount.email")%>:</td><td><input type="email" name="email" value="<%=account.getEmail()%>"></td></tr>
						<!--tr><td align="right"><%=p.getProperty("modifyAccount.address")%>:</td><td><input type="text" name="address" value="<%=user.getAddress()%>"></td></tr-->
						<!--tr><td align="right"><%=p.getProperty("modifyAccount.pwd")%>:</td><td><input type="password" name="password" onchange="validatePassword(this);"></td></tr-->
						<!--tr><td align="right"><%=p.getProperty("modifyAccount.pwd2")%>:</td><td><input type="password" name="confirmPassword" onchange="validatePassword(this);"></td></tr-->
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("modifyAccount.button.submit")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
<%
		} else{
%>
			<%=isSuccess ? p.getProperty("modifyAccount.success") : p.getProperty("modifyAccount.fail")%>
<%
		}
	}
%>
		</div>
	</body>
</html>