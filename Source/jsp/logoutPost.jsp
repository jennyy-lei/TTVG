<!DOCTYPE html>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%
    try{
 		session.removeAttribute("person");
       
    }catch(Exception e){
		System.out.println(e.getMessage());
    }finally{
	}
%>

<html>
	<body>
		<div id = "html-content">
			<h1><%=p.getProperty("logout.success")%></h1>
		</div>
	</body>
</html>