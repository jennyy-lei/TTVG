
<%
	String errorMessage = null;

    try{
		Object obj = session.getAttribute("errorMessage");
		if ( obj != null ){
			String temp = obj.toString();
			if (temp.startsWith("#")) {
				errorMessage = p.getProperty(temp.substring(1));
			} else {
				errorMessage = temp;
			}
			
			session.removeAttribute("errorMessage");
		}
        
    }catch(Exception e){
    }finally{
	}
%>

<%
	if ( errorMessage != null && errorMessage.length() > 0 ) {
%>
		<div id = "error-message">
			<font size="3" color="red"><i><%=errorMessage%></i></font>
		</div>
		<hr/>
<%
	}
%>
