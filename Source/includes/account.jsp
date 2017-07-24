<%@page import="com.ttvg.shared.engine.database.table.Account" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>
<%
	Account account = null;
	Person user = null;

	//Get current user
	Object objAccount = session.getAttribute("account");
	if ( objAccount != null && objAccount instanceof Account ){
		account = ((Account)objAccount);
		user = account.getPerson();
	}
%>
<!--p><%=account!=null?account.getEmail():"Not login"%> </p-->
