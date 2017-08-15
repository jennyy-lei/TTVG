<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
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
    Session dbSession = null;
	Transaction transaction = null;
	List<Object> accountList = null;
	String op = null;
	String firstName = null;
	String lastName = null;
	String personId = null;
	String condition = "";
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		op = request.getParameter("op");
		personId = request.getParameter("personId");
		firstName = request.getParameter("firstName");
		lastName = request.getParameter("lastName");
		
		if ( op != null && op.length() > 0 && personId != null && personId.length() > 0 ){
			transaction = dbSession.beginTransaction();
			Account accTemp = TableRecordOperation.getRecord(Integer.parseInt(personId), Account.class);
				
			if ( "Status".equalsIgnoreCase(op) ) {
				accTemp.setDisabled(!accTemp.isDisabled());
			} if ( "Role".equalsIgnoreCase(op) ) {
				accTemp.setRole(Constant.PARAM_ROLE_USER.equalsIgnoreCase(accTemp.getRole()) ? Constant.PARAM_ROLE_TOPIC : Constant.PARAM_ROLE_USER);
			}
				
			dbSession.update(accTemp);		

			//Log the audit
			dbSession.save(accTemp.getAudit(account, Constant.PARAM_ACTION_MODIFY));
				
			transaction.commit();
		}
    }catch(Exception e){
		System.out.println(e.getMessage());
    }finally{
      // Close the session after work
    	if (dbSession != null) {
    		dbSession.flush();
    		dbSession.close();
    	}
	}
		
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
		
		if ( firstName != null && firstName.length() > 0){
			condition = "person.givenName='" + firstName + "'";
		}
			
		if ( lastName != null && lastName.length() > 0){
			if ( condition.length() > 0 ) condition = condition + " AND ";
			condition = condition + "person.lastName='" + lastName + "'";
		}
			
		if ( condition.length() > 0 ){
			//Search for current list of account
			accountList = TableRecordOperation.findAllRecord("from Account where " + condition);
		}
	}catch(Exception e){
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
	<body>
<!--<%=condition%>/<%=firstName%>/<%=lastName%>-->
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
		<div id = "page-form">
			<h1><%=p.getProperty("role.title")%></h1>
				<form action="role.jsp" method="POST">
					<table style="width:100%" border="1">
						<tr>
							<th><%=p.getProperty("role.sn")%></th>
							<th><%=p.getProperty("role.gn")%></th>
						</tr>
						<tr><td><input type="text" name="firstName" value="<%=firstName!=null?firstName:""%>"></td>
							<td><input type="text" name="lastName" value="<%=lastName!=null?lastName:""%>"></td>
						</tr>
					</table> 
					<input type="submit" value="<%=p.getProperty("role.button.submit")%>">
				</form>
		<div id = "page-content">
		</div>
<%
	//Display the current account list
	if ( accountList != null ){
%>
			<div class="role-item-container">
				<table style="width:100%" border="1">
					<tr>
						<th><%=p.getProperty("role.sn")%></th>
						<th><%=p.getProperty("role.gn")%></th>
						<th><%=p.getProperty("role.cn")%></th>
						<th><%=p.getProperty("role.email")%></th>
						<th><%=p.getProperty("role.status")%></th>
						<th><%=p.getProperty("role.role")%></th>
					</tr>
<%
		for ( Object obj : accountList ){
			Account acc = ((Account)obj);
			Person person= acc.getPerson();
%>
					<tr>
						<td><%=person.getGivenName()%></td>
						<td><%=person.getLastName()%></td>
						<td><%=person.getChineseName()%></td>
						<td><%=acc.getEmail()%></td>
						<td>
							<a href="role.jsp?personId=<%=acc.getId()%>&btnLanguage=<%=newLocaleStr%>&op=Status&firstName=<%=firstName%>&lastName=<%=lastName%>"><%=acc.isDisabled() ? p.getProperty("role.status.enable") : p.getProperty("role.status.disable")%></a>
						</td>
						<td>
							<a href="role.jsp?personId=<%=acc.getId()%>&btnLanguage=<%=newLocaleStr%>&op=Role&firstName=<%=firstName%>&lastName=<%=lastName%>"><%="User".equalsIgnoreCase(acc.getRole()) ? p.getProperty("role.role.toadmin") : p.getProperty("role.role.fromadmin")%></a>
						</td>
<%
		}
%>
					</tr>
				</table>
			</div>
<%
	} else {
%>
<%=p.getProperty("search.noresult")%>
<%
	}
%>
		</div>
	</body>
</html>