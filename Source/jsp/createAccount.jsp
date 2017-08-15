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

<%
    Session dbSession = null;
	Transaction transaction = null;
	String firstName = null;
	String lastName = null;
	String chineseName = null;
	String phone = null;
	String mobile = null;
	String email = null;
	String address = null;
	String password = null;
	String confirmPassword = null;
	
	Account acc = null;
	Person person = null;
	
	boolean isSuccess = false;
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
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
		if ( chineseName != null && chineseName.length() > 0 )
			chineseName = new String(chineseName.getBytes("ISO8859_1"), "UTF-8");
		
		//Save the posted account item if not empty
		if ( (firstName != null && firstName.length() > 0) && (lastName != null && lastName.length() > 0) && password.equals(confirmPassword) ) {
			transaction = dbSession.beginTransaction();
			acc = new Account();
			acc.setRole(Constant.PARAM_ROLE_USER);
			acc.setEmail(email);
			acc.setPassword(password);
			
			person = new Person();
			person.setGivenName(firstName);
			person.setLastName(lastName);
			person.setChineseName(chineseName);
			person.setPhone(phone);
			person.setMobile(mobile);
			person.setAddress(address);
			
			acc.setPerson(person);
			
			dbSession.save(acc);			
			transaction.commit();
			
			isSuccess = true;
		}
        
    }catch(Exception e){
		if ( transaction != null ) transaction.rollback();
		System.out.println(e.getMessage());
    }finally{
      // Close the session after work
    	if (dbSession != null) {
		    try{
				dbSession.flush();
				dbSession.close();
			}catch(Exception ex1){
			}				
    	}
	}
%>

<html>
	<head>
		<script src="../html/inputValidation.js"></script>
	</head>
	<body>
		<div id = "html-content">
<%
	if ( person == null ) {
%>
			<h1><%=p.getProperty("createAccount.title")%></h1>
			<fieldset>
				<form action="createAccount.jsp" method="POST">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("createAccount.sn")%><font color="red">*</font>:</td><td><input type="text" name="firstName" onchange="validateText(this);" required></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.gn")%><font color="red">*</font>:</td><td><input type="text" name="lastName" onchange="validateText(this);" required></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.cn")%>:</td><td><input type="text" name="chineseName"></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.tel")%>:</td><td><input type="tel" name="phone" onchange="validatePhone(this);"></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.mobile")%>:</td><td><input type="tel" name="mobile" onchange="validatePhone(this);"></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.email")%><font color="red">*</font>:</td><td><input type="email" name="email" required></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.address")%>:</td><td><input type="text" name="address"></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.pwd")%><font color="red">*</font>:</td><td><input type="password" name="password" onchange="validatePassword(this);" required></td></tr>
						<tr><td align="right"><%=p.getProperty("createAccount.pwd2")%><font color="red">*</font>:</td><td><input type="password" name="confirmPassword" required></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("createAccount.button.submit")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
<%
	} else{
%>
		<%=isSuccess ? p.getProperty("createAccount.success") : p.getProperty("createAccount.fail")%>
<%
	}
%>
		</div>
	</body>
</html>