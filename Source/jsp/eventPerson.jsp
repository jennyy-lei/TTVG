<%@page import="java.util.List" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
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
	String op = null;
	String eventId = null;
	Event event = null;
	String errorMsg = null;
	
    try{
       
		//Get Post data
		op = request.getParameter("op");
		eventId = request.getParameter("eventId");
		
		if ( eventId != null && eventId.length() > 0 ) {
			event = TableRecordOperation.getRecord(Integer.parseInt(eventId), Event.class);
		}
        
    }catch(Exception e){
		errorMsg = e.getMessage();
		System.out.println(e.getMessage());
    }finally{
	}
%>

<html>
	<body>
<!--p><%=event!=null?event.getPersons().size():0%>/eventId=<%=eventId%>/errorMsg=<%=errorMsg%> </p-->
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
<%
	//If the current event item is not empty
	if ( event != null ){
%>
		<div id = "page-title">
			<div class="forum-item-container">
				<div class="title">
					<span><%=event.getTitle()%></span>
				</div>
				<div class="forum-text">
					<p><%=event.getContent()%> 
					</p>
				</div>
			</div>
		
			<table border="1">
				<tr>
					<th><%=p.getProperty("event.type")%></th>
					<th><%=p.getProperty("event.category")%></th>
					<th><%=p.getProperty("event.date.from")%></th>
					<th><%=p.getProperty("event.date.to")%></th>
					<th><%=p.getProperty("event.time.from")%></th>
					<th><%=p.getProperty("event.time.to")%></th>
				</tr>
				<tr>
					<td><%=event.getType()%></td>
					<td><%=event.getCategory()%></td>
					<td><%=event.getFromDate()%></td>
					<td><%=event.getToDate()%></td>
					<td><%=event.getFromTime()%></td>
					<td><%=event.getToTime()%></td>
				</tr>
			</table>
		</div>
<%
	}
%>
<%
	//Display the current person list from an event
	if ( event != null ){
%>
		<div id = "html-content">
			<div class="forum-item-container">
				<div class="title">
					<a href="eventManage.jsp?btnLanguage=<%=newLocaleStr%>&btnLanguage=<%=newLocaleStr%>"><%=p.getProperty("button.back")%></a>
				</div>
				<table border="1">
					<tr>
						<th><%=p.getProperty("eventList.gn")%></th>
						<th><%=p.getProperty("eventList.sn")%></th>
						<th><%=p.getProperty("eventList.cn")%></th>
						<th><%=p.getProperty("eventList.tel")%></th>
					</tr>
<%
		for ( Person item : event.getPersons() ){
%>
					<tr>
						<td><%=item.getGivenName()%></td>
						<td><%=item.getLastName()%></td>
						<td><%=item.getChineseName()%></td>
						<td><%=item.getPhone()%></td>
					</tr>
<%
		}
%>
				</table>
			</div>
		</div>
		<hr/>
<%
	}
%>
	</body>
</html>