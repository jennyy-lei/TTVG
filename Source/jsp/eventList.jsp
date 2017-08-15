<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Set" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.base.Security" %>
<%@page import="com.ttvg.shared.engine.base.Constant" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Event" %>
<%@page import="com.ttvg.shared.engine.database.table.Account" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>

<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%@include file="../includes/account.jsp" %>

<%
    Session dbSession = null;
	Set<Person> personList = null;
	String eventId = null;
		
    try{
		//Get Post data
		eventId = request.getParameter("eventId");

		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();

		if ( eventId != null && eventId.length() > 0 ) {
			Event event = TableRecordOperation.getRecord(Integer.parseInt(eventId), Event.class);
			
			if ( event != null )
				personList = event.getPersons();
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
%>

<html>
	<body>
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
		<div class="title">
			<a href="eventReview.jsp?btnLanguage=<%=newLocaleStr%>"><%=p.getProperty("button.back")%></a>
		</div>
		<div id = "page-content">
<%
	//Display the current list of registered persons
	if ( personList != null ){
%>
			<div class="forum-item-container">
				<table border="1">
					<tr>
						<th><%=p.getProperty("eventList.gn")%></th>
						<th><%=p.getProperty("eventList.sn")%></th>
						<th><%=p.getProperty("eventList.cn")%></th>
						<th><%=p.getProperty("eventList.tel")%></th>
						<th><%=p.getProperty("eventList.mobile")%></th>
						<th><%=p.getProperty("eventList.address")%></th>
					</tr>
<%
		for ( Person person : personList ){
%>
					<tr>
						<td><%=person.getGivenName()%></td>
						<td><%=person.getLastName()%></td>
						<td><%=person.getChineseName()%></td>
						<td><%=person.getPhone()%></td>
						<td><%=person.getMobile()%></td>
						<td><%=person.getAddress()%></td>
					</tr>
<%
		}
%>
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