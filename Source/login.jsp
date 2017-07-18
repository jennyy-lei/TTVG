<!DOCTYPE html>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<html>
	<body>
		<div id = "html-content">
			<h1><%=p.getProperty("login.title")%></h1>
			<fieldset>
				<form action="jsp/loginPost.jsp" method="POST">
					<input type="hidden" name="btnLanguage" value="<%=newLocaleStr%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("login.email")%>:</td><td><input type="email" name="email"></td></tr>
						<tr><td align="right"><%=p.getProperty("login.pwd")%>:</td><td><input type="password" name="password"></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("login.button.submit")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
	</body>
</html>