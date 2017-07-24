<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Audit" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>

<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%@include file="../includes/account.jsp" %>

<%
    Session dbSession = null;
	Transaction transaction = null;
	List<Object> auditList = null;
	String target = null;
	String action = null;
	String fromDate = null;
	String toDate = null;
	StringBuffer condition = new StringBuffer();
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		target = request.getParameter("target");
		action = request.getParameter("action");
		fromDate = request.getParameter("fromDate");
		toDate = request.getParameter("toDate");
		
		if ( target != null && target.length() > 0 ){
			if ( condition.length() > 0 )
				condition.append(" And ");
			condition.append("Target='" + target + "'");
		}
		if ( action != null && action.length() > 0 ){
			if ( condition.length() > 0 )
				condition.append(" And ");
			condition.append("Action='" + action + "'");
		}
		
		if ( condition.length() > 0 )
			condition.insert(0, " where ");
		
		//Search for current list of audit items
        auditList = TableRecordOperation.findAllRecord("from Audit" + condition.toString() + " order by Created desc");
        
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
		<div id = "page-form">
			<h1><%=p.getProperty("audit.title")%></h1>
				<form action="audit.jsp" method="POST">
					<table style="width:100%" border="1">
						<tr>
							<th><%=p.getProperty("audit.target")%></th>
							<th><%=p.getProperty("audit.action")%></th>
							<th><%=p.getProperty("audit.date.from")%></th>
							<th><%=p.getProperty("audit.date.to")%></th>
						</tr>
						<tr><td>
								<select id="mySelectTarget" name="target">
									<option value="">All</option>
									<option value="User">User</option>
									<option value="Forum">Forum</option>
									<option value="Event">Event</option>
								</select>
							</td>
							<td>
								<select id="mySelectAction" name="action">
									<option value="">All</option>
									<option value="Add">Add</option>
									<option value="Modify">Modify</option>
									<option value="Remove">Remove</option>
								</select>
							</td>
							<td><input type="date" name="fromDate"></td>
							<td><input type="date" name="toDate"></td>
						</tr>
					</table> 
					<input type="submit" value="<%=p.getProperty("audit.button.submit")%>">
				</form>
		<div id = "page-content">
		</div>
<%
	//Display the current audit list
	if ( auditList != null ){
%>
			<div class="audit-item-container">
				<table style="width:100%" border="1">
					<tr>
						<th><%=p.getProperty("audit.target")%></th>
						<th><%=p.getProperty("audit.content")%></th>
						<th><%=p.getProperty("audit.action")%></th>
						<th><%=p.getProperty("audit.date")%></th>
						<th><%=p.getProperty("audit.operator")%></th>
					</tr>
<%
		for ( Object obj : auditList ){
			Audit item = ((Audit)obj);
%>
					<tr>
						<td><%=item.getTarget()%></td>
						<td><%=item.getContent()%></td>
						<td><%=item.getAction()%></td>
						<td><%=item.getCreatedDateTime()%></td>
						<td><%=item.getAccount().getPerson().getGivenName() + " " + item.getAccount().getPerson().getLastName()%></td>
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