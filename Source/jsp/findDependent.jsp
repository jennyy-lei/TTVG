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
	List<Object> childrenList = null;
	String op = null;
	String personId = null;
	String firstName = null;
	String lastName = null;
	String sqlString = null;
	String relation = null;
	
	Person child = null;

	boolean isSuccess = false;
	
    try{
		if ( user != null ) {
			op = request.getParameter("op");
			if ( Constant.PARAM_ACTION_MODIFY.equalsIgnoreCase(op) ) {
				// This step will read hibernate.cfg.xml and prepare hibernate for use
				dbSession = MyDatabaseFeactory.getSession();
				transaction = dbSession.beginTransaction();
				
				//Get data
				personId = request.getParameter("personId");
				relation = request.getParameter("relation");
				if ( personId != null && personId.length() > 0 ) {
					//Locate the current child
					child = TableRecordOperation.getRecord(Integer.parseInt(personId), Person.class);
					if ( child != null ) {

						if ( Constant.PARAM_RELATION_MOTHER.equalsIgnoreCase(relation) )
							child.setMother(user);
						else if ( Constant.PARAM_RELATION_FATHER.equalsIgnoreCase(relation) )
							child.setFather(user);
						else if ( Constant.PARAM_RELATION_GUARDIAN.equalsIgnoreCase(relation) )
							child.setGuardian(user);
						
						dbSession.update(child);
			
						//Log the audit
						if ( child != null )
							dbSession.save(child.getAudit(account, op));
						
						isSuccess = true;
					}
				}
					
				transaction.commit();
			}
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
		
	if ( user != null && "Search".equalsIgnoreCase(op) ) {
		try{
			// This step will read hibernate.cfg.xml and prepare hibernate for use
			dbSession = MyDatabaseFeactory.getSession();

			firstName = request.getParameter("firstName");
			lastName = request.getParameter("lastName");
			relation = request.getParameter("relation");

			if ( (firstName != null && firstName.length() > 0) && (lastName != null && lastName.length() > 0) && (relation != null && relation.length() > 0) ) {
				sqlString = "";
				
				if ( Constant.PARAM_RELATION_MOTHER.equalsIgnoreCase(relation) )
					sqlString = " And mother is NULL";
				else if ( Constant.PARAM_RELATION_FATHER.equalsIgnoreCase(relation) )
					sqlString = " And father is NULL";
				else if ( Constant.PARAM_RELATION_GUARDIAN.equalsIgnoreCase(relation) )
					sqlString = " And guardian is NULL";
				
				//Search for current list of event items
				childrenList = TableRecordOperation.findAllRecord("from Person where givenName='" + firstName + "' And lastName='" + lastName + "'" + sqlString);
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
	}
%>

<html>
	<body>
<!--	<%=op%>/<%=child != null ? child.getGivenName() : "Not know" %>/<%=lastName%>-->
<%
	//Display the current event list
	if ( childrenList != null ){
%>
		<div id = "html-content">
			<div class="forum-item-container">
				<table border="1">
					<tr>
						<th><%=p.getProperty("findDependent.gn")%></th>
						<th><%=p.getProperty("findDependent.sn")%></th>
						<th><%=p.getProperty("findDependent.cn")%></th>
						<th><%=p.getProperty("findDependent.relation")%></th>
						<th><%=p.getProperty("findDependent.button.add")%></th>
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
							<%=p.getProperty("findDependent.relation.mother.text")%>
<%
			} else if ( item.getFather() != null ){
%>
							<%=p.getProperty("findDependent.relation.father.text")%>
<%
			} else{
%>
							<%=p.getProperty("findDependent.relation.guardian.text")%>
<%
			}
%>
						</td>
						<td>
							<a href="findDependent.jsp?personId=<%=item.getId()%>&op=Modify&relation=<%=relation%>"><%=p.getProperty("findDependent.button.add")%></a>
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
	} else {
%>
<%="Search".equalsIgnoreCase(op) ? p.getProperty("search.noresult") : ""%>
<%
	}
%>
<%
	if ( user == null ) {
%>
		<%=p.getProperty("login.not")%>
<%
	} else if ( child == null ) {
%>
		<div id = "page-form">
			<h1><%=p.getProperty("findDependent.title")%></h1>
			<fieldset>
				<form action="findDependent.jsp" method="POST">
					<input type="hidden" name="op" value="Search">
					<input type="hidden" name="personId" value="<%=user.getId()%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("findDependent.sn")%><font color="red">*</font>:</td><td><input type="text" name="firstName" value="<%=child != null ? child.getGivenName() : ""%>" required></td></tr>
						<tr><td align="right"><%=p.getProperty("findDependent.gn")%><font color="red">*</font>:</td><td><input type="text" name="lastName" value="<%=child != null ? child.getLastName() : ""%>" required></td></tr>
						<tr><td align="right"><%=p.getProperty("findDependent.relation")%><font color="red">*</font>:</td>
							<td>
								<select id="mySelect" name="relation">
									<option value="<%=p.getProperty("findDependent.relation.mother.value")%>" <%=child == null || child.getMother() != null ? "selected" : ""%>><%=p.getProperty("findDependent.relation.mother.text")%></option>
									<option value="<%=p.getProperty("findDependent.relation.father.value")%>" <%=child != null && child.getFather() != null ? "selected" : ""%>><%=p.getProperty("findDependent.relation.father.text")%></option>
									<option value="<%=p.getProperty("findDependent.relation.guardian.value")%>" <%=child != null && child.getGuardian() != null ? "selected" : ""%>><%=p.getProperty("findDependent.relation.guardian.text")%></option>
								</select>
							</td>
						</tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("findDependent.button.submit")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	} else{
%>
		<%=isSuccess ? p.getProperty("findDependent.success") : p.getProperty("findDependent.fail")%>
<%
	}
%>
	</body>
</html>