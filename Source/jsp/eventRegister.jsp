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
	Transaction transaction = null;
	String op = null;
	String userId = null;
	String eventId = null;
	Event event = null;
	Person toUser = user;
	List<Object> childrenList = null;
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for event
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		op = request.getParameter("op");
		userId = request.getParameter("userId");
		eventId = request.getParameter("eventId");
		
		if ( userId != null && userId.length() > 0 && !userId.equalsIgnoreCase("" + user.getId()) ) {
			toUser = TableRecordOperation.getRecord(Integer.parseInt(userId), Person.class);
		}
		
		if ( eventId != null && eventId.length() > 0 ) {
			event = TableRecordOperation.getRecord(Integer.parseInt(eventId), Event.class);
		}
		
		//Save the posted event item if not empty
		if ( op != null && op.length() > 0 && toUser != null && event != null ) {
			transaction = dbSession.beginTransaction();

			if ( toUser.hasEvent(event) ) {
				if ( "Unregister".equalsIgnoreCase(op) )	
					toUser.removeEvent(event);
			} else if ( "Register".equalsIgnoreCase(op) ) {
				toUser.getEvents().add(event);
			}			
			
			dbSession.update(toUser);			
			
			//Log the audit
			if ( event != null )
				dbSession.save(event.getAudit(account, op));
			
			dbSession.flush();
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
		
		if ( user != null ) {
			//Search for current list of children
			childrenList = TableRecordOperation.findAllRecord("from Person where mother='" + user.getId() + "' Or father='" + user.getId() + "' Or guardian='" + user.getId() + "' order by givenName");
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
<!--<p>op=<%=op%>/userId=<%=userId%>/toUser.getEvents()=<%=toUser!=null?toUser.getEvents().size():0%>/eventId=<%=eventId%> </p>-->
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
<%
	//Display the current event list
	if ( user != null ){
%>
		<div id = "html-content">
			<div class="forum-item-container">
				<div class="title">
					<a href="event.jsp?btnLanguage=<%=newLocaleStr%>"><%=p.getProperty("button.back")%></a>
				</div>
				<table border="1">
					<tr>
						<th><%=p.getProperty("addDependent.gn")%></th>
						<th><%=p.getProperty("addDependent.sn")%></th>
						<th><%=p.getProperty("addDependent.cn")%></th>
						<th><%=p.getProperty("addDependent.relation")%></th>
						<th><%=p.getProperty("event.register")%></th>
					</tr>
					<tr>
						<td><%=user.getGivenName()%></td>
						<td><%=user.getLastName()%></td>
						<td><%=user.getChineseName()%></td>
						<td></td>
						<td>
							<a href="eventRegister.jsp?eventId=<%=event.getId()%>&userId=<%=user.getId()%>&btnLanguage=<%=newLocaleStr%>&op=<%=user.hasEvent(event) ? "Unregister" : "Register"%>"><%=user.hasEvent(event) ? p.getProperty("event.unregister") : p.getProperty("event.register")%></a>
						</td>
					</tr>
<%
		for ( Object obj : childrenList ){
			Person item = ((Person)obj);
%>
					<tr>
						<td><%=item.getGivenName()%></td>
						<td><%=item.getLastName()%></td>
						<td><%=item.getChineseName()%></td>
						<td>
<%
			if ( item.getMother() != null ){
%>
							<%=p.getProperty("addDependent.relation.mother.text")%>
<%
			} else if ( item.getFather() != null ){
%>
							<%=p.getProperty("addDependent.relation.father.text")%>
<%
			} else{
%>
							<%=p.getProperty("addDependent.relation.guardian.text")%>
<%
			}
%>
						</td>
						<td>
							<a href="eventRegister.jsp?eventId=<%=event.getId()%>&userId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>&op=<%=item.hasEvent(event) ? "Unregister" : "Register"%>"><%=item.hasEvent(event) ? p.getProperty("event.unregister") : p.getProperty("event.register")%></a>
						</td>
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
	</body>
</html>