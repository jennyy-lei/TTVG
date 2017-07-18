<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Event" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>

<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%
    Session dbSession = null;
	Event event = null;
	Person user = null;
	String eventId = null;
	
	boolean isSuccess = false;
	
    try{
		//Get current user
		Object obj = session.getAttribute("person");
		if ( obj != null && obj instanceof Person ){
			user = (Person)obj;
		}
		
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		eventId = request.getParameter("eventId");
		
		//Save the posted event item if not empty
		if ( eventId != null && eventId.length() > 0 ) {
			int id = Integer.parseInt(eventId);
			if ( user.hasEvent(id) ) {
				user.removeEvent(id);
			} else {
				event = TableRecordOperation.getRecord(id, Event.class);
				if ( event != null )
					user.getEvents().add(event);
			}			
			dbSession.update(user);			
			
			isSuccess = true;
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
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
		<div id = "page-content">
			<%=isSuccess ? p.getProperty("event.register.success") : p.getProperty("event.register.fail")%>
		</div>
	</body>
</html>