<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
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
	List<Object> eventList = null;
			
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
		
		//Search for current list of event items
        eventList = TableRecordOperation.findAllRecord("from Event where deadLine > current_date() order by DateTime desc");
        
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
		<div id = "page-content">
<%
	//Display the current event list
	if ( eventList != null ){
%>
			<div class="forum-item-container">
				<table border="1">
					<tr>
						<th><%=p.getProperty("event.title")%></th>
						<th><%=p.getProperty("event.type")%></th>
						<th><%=p.getProperty("event.category")%></th>
						<th><%=p.getProperty("event.date.from")%></th>
						<th><%=p.getProperty("event.date.to")%></th>
						<th><%=p.getProperty("event.time.from")%></th>
						<th><%=p.getProperty("event.time.to")%></th>
						<th><%=p.getProperty("event.deadline")%></th>
						<th><%=p.getProperty("event.available")%></th>
					</tr>
<%
		for ( Object obj : eventList ){
			Event item = ((Event)obj);
			int available = item.getCapacity() - item.getPersons().size();
%>
					<tr>
						<td>
<%
	if ( user != null && available > 0 ){
%>
							<a href="eventRegister.jsp?eventId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>"><%=item.getTitle()%></a>
<%
	} else {
%>
							<%=item.getTitle()%>
<%
	}
%>
						</td>
						<td><%=item.getType()%></td>
						<td><%=item.getCategory()%></td>
						<td><%=item.getFromDate()%></td>
						<td><%=item.getToDate()%></td>
						<td><%=item.getFromTime()%></td>
						<td><%=item.getToTime()%></td>
						<td><%=item.getDeadLine()%></td>
						<td><%=available%></td>
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