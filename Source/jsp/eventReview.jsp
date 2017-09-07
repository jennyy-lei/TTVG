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
	List<Object> childrenList = null;
	
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
	if ( user != null ){
%>
			<div class="forum-item-container">
				<table border="1">
					<tr>
						<th><%=p.getProperty("eventReview.title")%></th>
						<th><%=p.getProperty("eventReview.type")%></th>
						<th><%=p.getProperty("eventReview.category")%></th>
						<th><%=p.getProperty("eventReview.sn")%></th>
						<th><%=p.getProperty("eventReview.gn")%></th>
						<th><%=p.getProperty("eventReview.cn")%></th>
					</tr>
<%
		for ( Event item : user.getEvents() ){
%>
					<tr>
						<td>
							<a href="eventRegister.jsp?eventId=<%=item.getId()%>&from=eventReview.jsp&btnLanguage=<%=newLocaleStr%>"><%=item.getTitle()%></a>
						</td>
						<td><%=item.getType()%></td>
						<td><%=item.getCategory()%></td>
						<td><%=user.getGivenName()%></td>
						<td><%=user.getLastName()%></td>
						<td><%=user.getChineseName()%></td>
					</tr>
<%
		}
%>
<%
		for ( Object obj : childrenList ){
			Person person = ((Person)obj);
			for ( Event item : person.getEvents() ){
%>
					<tr>
						<td>
							<a href="eventRegister.jsp?eventId=<%=item.getId()%>&from=eventReview.jsp&btnLanguage=<%=newLocaleStr%>"><%=item.getTitle()%></a>
						</td>
						<td><%=item.getType()%></td>
						<td><%=item.getCategory()%></td>
						<td><%=person.getGivenName()%></td>
						<td><%=person.getLastName()%></td>
						<td><%=person.getChineseName()%></td>
					</tr>
<%
			}
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