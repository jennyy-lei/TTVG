<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.base.Security" %>
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
	Transaction transaction = null;
	List<Object> eventList = null;
	String op = null;
	String eventId = null;
	String title = null;
	String content = null;
	Event event = null;
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		request.setCharacterEncoding("UTF-8");
		op = request.getParameter("op");
		eventId = request.getParameter("eventId");
		title = request.getParameter("title");
		content = request.getParameter("content");
		String eventType = request.getParameter("eventType");
		String eventCategory = request.getParameter("eventCategory");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		if ( op == null || op.length() == 0 )
			op = "Add";
		if ( title != null && title.length() > 0 )
			title = new String(title.getBytes("ISO8859_1"), "UTF-8");
		if ( content != null && content.length() > 0 )
			content = new String(content.getBytes("ISO8859_1"), "UTF-8");
		
		if ( eventId != null && eventId.length() > 0 ) {
			event = TableRecordOperation.getRecord(Integer.parseInt(eventId), Event.class);
		}
		
		//Save the posted event item if not empty
		if ( (event != null) || (title != null && title.length() > 0) ) {
			transaction = dbSession.beginTransaction();
			if ( event == null && "add".equalsIgnoreCase(op) && (title != null && title.length() > 0) ){
				event = new Event();
				event.setDateTime(new Date());
				event.setTitle(title);
				event.setContent(content);
				event.setType(eventType);
				event.setCategory(eventCategory);
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if ( fromDate != null && fromDate.length() > 0 )
					event.setFromDate(sdf.parse(fromDate));
				if ( toDate != null && toDate.length() > 0 )
					event.setToDate(sdf.parse(toDate));
				
				dbSession.save(event);			
			} else if ( "remove".equalsIgnoreCase(op) && event != null ){
				dbSession.delete(event);		
			}         
			
			//Log the audit
			if ( event != null )
				dbSession.save(event.getAudit(account, op));
			
			transaction.commit();
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
		
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
		
		//Search for current list of event items
        eventList = TableRecordOperation.findAllRecord("from Event order by DateTime desc");
        
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
<%
	//If the current user is login
	if ( user != null ){
%>
<%
		//If the current user is login
		if ( Security.CheckPrivilege("Event", "Remove", account) ){
%>
						<th><%=p.getProperty("event.remove")%></th>
<%
		}
%>
						<th><%=p.getProperty("event.register")%></th>
<%
	}
%>
					</tr>
<%
		for ( Object obj : eventList ){
			Event item = ((Event)obj);
%>
					<tr>
						<td><%=item.getTitle()%></td>
						<td><%=item.getType()%></td>
						<td><%=item.getCategory()%></td>
						<td><%=item.getFromDate()%></td>
						<td><%=item.getToDate()%></td>
						<td><%=item.getFromTime()%></td>
						<td><%=item.getToTime()%></td>
<%
	//If the current user is login
	if ( user != null ){
%>
<%
		//If the current user is login
		if ( Security.CheckPrivilege("Event", "Remove", account) ){
%>
						<td><a href="event.jsp?eventId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>&op=Remove"><%=p.getProperty("event.remove")%></a></td>
<%
		}
%>
						<td>
							<a href="eventRegister.jsp?eventId=<%=item.getId()%>"><%=user.hasEvent(item) ? p.getProperty("event.unregister") : p.getProperty("event.register")%></a>
						</td>
<%
	}
%>
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
<%
	//If the current user is login
	if ( user != null ){
%>
		<hr/>
		<div id = "page-form">
			<fieldset>
				<form action="event.jsp" method="POST">
					<input type="hidden" name="btnLanguage" value="<%=newLocaleStr%>">
					<input type="hidden" name="op" value="Add">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("event.type")%>:</td>
							<td>
								<select id="mySelect" name="eventType">
									<option value="<%=p.getProperty("event.type.children.value")%>"><%=p.getProperty("event.type.children.text")%></option>
									<option value="<%=p.getProperty("event.type.adult.value")%>"><%=p.getProperty("event.type.adult.text")%></option>
									<option value="<%=p.getProperty("event.type.senior.value")%>"><%=p.getProperty("event.type.senior.text")%></option>
								</select>
							</td>
						</tr>
						<tr><td align="right"><%=p.getProperty("event.category")%>:</td>
							<td>
								<select id="mySelect" name="eventCategory">
									<option value="<%=p.getProperty("event.category.badminton.value")%>"><%=p.getProperty("event.category.badminton.text")%></option>
									<option value="<%=p.getProperty("event.category.basketball.value")%>"><%=p.getProperty("event.category.basketball.text")%></option>
									<option value="<%=p.getProperty("event.category.volleyball.value")%>"><%=p.getProperty("event.category.volleyball.text")%></option>
									<option value="<%=p.getProperty("event.category.dancing.value")%>"><%=p.getProperty("event.category.dancing.text")%></option>
									<option value="<%=p.getProperty("event.category.drawing.value")%>"><%=p.getProperty("event.category.drawing.text")%></option>
									<option value="<%=p.getProperty("event.category.chess.value")%>"><%=p.getProperty("event.category.chess.text")%></option>
								</select>
							</td>
						</tr>
						<tr><td align="right"><%=p.getProperty("event.title")%>:</td><td><input type="text" name="title"></td></tr>
						<tr><td align="right"><%=p.getProperty("event.content")%>:</td><td><textarea cols="60" rows="5" name="content"></textarea></td></tr>
						<tr><td align="right"><%=p.getProperty("event.date.from")%>:</td><td><input type="date" name="fromDate"></td></tr>
						<tr><td align="right"><%=p.getProperty("event.date.to")%>:</td><td><input type="date" name="toDate"></td></tr>
						<tr><td align="right"><%=p.getProperty("event.time.from")%>:</td><td><input type="time" name="fromTime"></td></tr>
						<tr><td align="right"><%=p.getProperty("event.time.to")%>:</td><td><input type="time" name="toTime"></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("event.button.submit")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	}
%>
	</body>
</html>