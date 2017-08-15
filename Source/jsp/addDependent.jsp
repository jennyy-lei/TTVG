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
	String chineseName = null;
	String phone = null;
	String mobile = null;
	String relation = null;
	
	Person child = null;
	
	boolean isEdit = false;
	boolean isSuccess = false;
	
    try{
		if ( user != null ) {
			op = request.getParameter("op");
			if ( op != null && op.length() > 0 ) {
				// This step will read hibernate.cfg.xml and prepare hibernate for use
				dbSession = MyDatabaseFeactory.getSession();
				transaction = dbSession.beginTransaction();
				
				//Get data
				personId = request.getParameter("personId");
				if ( personId != null && personId.length() > 0 ) {
					//Locate the current child
					child = TableRecordOperation.getRecord(Integer.parseInt(personId), Person.class);
				}
				if ( Constant.PARAM_ACTION_REMOVE.equalsIgnoreCase(op) ) {
				
					child = TableRecordOperation.getRecord(Integer.parseInt(personId), Person.class);
					if ( child != null ) {
						dbSession.delete(child);
						isSuccess = true;
					}
				
				} else if ( "Edit".equalsIgnoreCase(op) ){
					isEdit = true;
				} else {
					//Get Post data
					request.setCharacterEncoding("UTF-8");
					firstName = request.getParameter("firstName");
					lastName = request.getParameter("lastName");
					chineseName = request.getParameter("chineseName");
					phone = request.getParameter("phone");
					mobile = request.getParameter("mobile");
					relation = request.getParameter("relation");
					if ( chineseName != null && chineseName.length() > 0 )
						chineseName = new String(chineseName.getBytes("ISO8859_1"), "UTF-8");
					
					//Save the posted account item if not empty
					if ( (firstName != null && firstName.length() > 0) && (lastName != null && lastName.length() > 0) ) {
						transaction = dbSession.beginTransaction();
						if ( child == null)
							child = new Person();
						else {
							child.setMother(null);
							child.setFather(null);
							child.setGuardian(null);
						}
						child.setGivenName(firstName);
						child.setLastName(lastName);
						child.setChineseName(chineseName);
						child.setPhone(phone);
						child.setMobile(mobile);
						if ( Constant.PARAM_RELATION_MOTHER.equalsIgnoreCase(relation) )
							child.setMother(user);
						else if ( Constant.PARAM_RELATION_FATHER.equalsIgnoreCase(relation) )
							child.setFather(user);
						else if ( Constant.PARAM_RELATION_GUARDIAN.equalsIgnoreCase(relation) )
							child.setGuardian(user);
						
						if ( Constant.PARAM_ACTION_ADD.equalsIgnoreCase(op) ){
							dbSession.save(child);
						} else {
							dbSession.update(child);
						}
						
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
		
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
			
		//Log the audit
		if ( child != null )
			dbSession.save(child.getAudit(account, op));
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
		
	if ( user != null ) {
		try{
			// This step will read hibernate.cfg.xml and prepare hibernate for use
			dbSession = MyDatabaseFeactory.getSession();
			
			//Search for current list of event items
			childrenList = TableRecordOperation.findAllRecord("from Person where mother='" + user.getId() + "' Or father='" + user.getId() + "' Or guardian='" + user.getId() + "' order by givenName");
			
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
	<head>
		<script src="../html/inputValidation.js"></script>
	<head>
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
						<th><%=p.getProperty("addDependent.gn")%></th>
						<th><%=p.getProperty("addDependent.sn")%></th>
						<th><%=p.getProperty("addDependent.cn")%></th>
						<th><%=p.getProperty("addDependent.relation")%></th>
						<th><%=p.getProperty("addDependent.button.edit")%></th>
						<th><%=p.getProperty("addDependent.button.remove")%></th>
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
							<a href="addDependent.jsp?personId=<%=item.getId()%>&op=Edit"><%=p.getProperty("addDependent.button.edit")%></a>
						</td>
						<td>
							<a href="addDependent.jsp?personId=<%=item.getId()%>&op=Remove"><%=p.getProperty("addDependent.button.remove")%></a>
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
<%=p.getProperty("search.noresult")%>
<%
	}
%>
<%
	if ( user == null ) {
%>
		<%=p.getProperty("login.not")%>
<%
	} else if ( isEdit || child == null ) {
%>
		<div id = "page-form">
			<h1><%=p.getProperty("addDependent.title")%></h1>
			<fieldset>
				<form action="addDependent.jsp" method="POST">
					<input type="hidden" name="op" value="<%=child != null ? Constant.PARAM_ACTION_MODIFY : Constant.PARAM_ACTION_ADD%>">
					<input type="hidden" name="personId" value="<%=child != null ? child.getId() : ""%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("addDependent.sn")%><font color="red">*</font>:</td><td><input type="text" name="firstName" value="<%=child != null ? child.getGivenName() : ""%>" onchange="validateText(this);" required></td></tr>
						<tr><td align="right"><%=p.getProperty("addDependent.gn")%><font color="red">*</font>:</td><td><input type="text" name="lastName" value="<%=child != null ? child.getLastName() : ""%>" onchange="validateText(this);" required></td></tr>
						<tr><td align="right"><%=p.getProperty("addDependent.cn")%>:</td><td><input type="text" value="<%=child != null ? child.getChineseName() : ""%>" name="chineseName"></td></tr>
						<tr><td align="right"><%=p.getProperty("addDependent.tel")%>:</td><td><input type="text" value="<%=child != null ? child.getPhone() : ""%>" name="phone"></td></tr>
						<tr><td align="right"><%=p.getProperty("addDependent.mobile")%>:</td><td><input type="text" value="<%=child != null ? child.getMobile() : ""%>" name="mobile"></td></tr>
						<tr><td align="right"><%=p.getProperty("addDependent.relation")%><font color="red">*</font>:</td>
							<td>
								<select id="mySelect" name="relation">
									<option value="<%=p.getProperty("addDependent.relation.mother.value")%>" <%=child == null || child.getMother() != null ? "selected" : ""%>><%=p.getProperty("addDependent.relation.mother.text")%></option>
									<option value="<%=p.getProperty("addDependent.relation.father.value")%>" <%=child != null && child.getFather() != null ? "selected" : ""%>><%=p.getProperty("addDependent.relation.father.text")%></option>
									<option value="<%=p.getProperty("addDependent.relation.guardian.value")%>" <%=child != null && child.getGuardian() != null ? "selected" : ""%>><%=p.getProperty("addDependent.relation.guardian.text")%></option>
								</select>
							</td>
						</tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty(child != null ? "addDependent.button.edit" : "addDependent.button.submit")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	} else{
%>
		<%=isSuccess ? p.getProperty("addDependent.success") : p.getProperty("addDependent.fail")%>
<%
	}
%>
	</body>
</html>