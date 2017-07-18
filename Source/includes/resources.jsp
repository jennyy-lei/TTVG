<%@page import="java.io.FileInputStream" %>
<%@page import="java.io.File" %>
<%@page import="java.io.InputStreamReader" %>
<%@page import="java.util.Properties" %>
<%@page import="com.ttvg.shared.engine.base.Constant" %>
<%--=getServletContext().getRealPath("/includes/resources_cn.properties")--%>
<%
	////////////Get and Set cookie for the locale.
	String localeStr = Constant.LOCALE_CN;

	Cookie[] cookies = request.getCookies();

	if ( cookies != null ) {
		for(Cookie c : cookies) { 
			if (c.getName().equals("locale")) {
				if ( Constant.LOCALE_CN.equalsIgnoreCase(c.getValue()) || Constant.LOCALE_EN.equalsIgnoreCase(c.getValue()))
					localeStr = c.getValue();
				break;
			}
		}  
	}

	String newLocaleStr = localeStr;
    if(request.getParameter("btnLanguage")!=null)
	{
		newLocaleStr = request.getParameter("btnLanguage");
	}
	
	// Create cookies for locale.      
	Cookie locale = new Cookie("locale", newLocaleStr);

	// Set expiry date after 24 Hrs for the cookies.
	locale.setMaxAge(60*60*24); 
   
	// Add the cookie in the response header.
	response.addCookie( locale );

	////////////Load property file
	String propFile = "/includes/resources_" + newLocaleStr + ".properties";
	FileInputStream fis = new FileInputStream(new File(getServletContext().getRealPath(propFile)));

	Properties p = new Properties();
	p.load(fis);

	fis.close();
%>
<%--=localeStr%>/<%=p.getProperty("title")%>/<%=request.getParameter("btnLanguage")--%>
<%--=propFile--%>