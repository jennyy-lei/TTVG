
<%
	String errorMessage = null;

    try{
		Object obj = session.getAttribute("errorMessage");
		if ( obj != null ){
			String temp = obj.toString();
			if (temp.startsWith("#") {
				errorMessage = p.getProperty(temp.substring(1));
			} else {
				errorMessage = temp;
			}
		}
        
    }catch(Exception e){
    }finally{
	}
%>

<%
	if ( errorMessage != null && errorMessage.length() > 0 ) {
%>
		<div id = "error-message">
			<h1><%=errorMessage%></h1>
		</div>
<%
	}
%>
