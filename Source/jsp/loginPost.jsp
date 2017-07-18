<%@page import="org.hibernate.Session" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>
<%@page import="com.ttvg.shared.engine.database.table.Account" %>

<!DOCTYPE html>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%
    Session dbSession = null;
	Account account = null;

    try{
 		session.removeAttribute("person");

		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
        Object obj = TableRecordOperation.findRecord("from Account where Email='" + request.getParameter("email") + "'");
		
		if ( obj instanceof Account)
			account = (Account)obj;
       
    }catch(Exception e){
		System.out.println(e.getMessage());
    }finally{
      // Close the session after work
    	if (dbSession != null) {
    		dbSession.flush();
    		dbSession.close();
    	}
	}
%>

<html>
	<body>
		<div id = "html-content">
<%
	if ( account != null ){
		Person person = account.getPerson();
		session.setAttribute("person",  person);
%>
			<h1><%=p.getProperty("login.success")%> - <%=person.getLastName()%>, <%=person.getGivenName()%></h1>
<%
	} else {
%>
			<h1><%=p.getProperty("login.fail")%></h1>
<%
	}
%>
		</div>
	</body>
</html>