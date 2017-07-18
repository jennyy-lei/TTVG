<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="includes/resources.jsp" %>

<html>
	<head>
		<link rel = "stylesheet" type = "text/css" href = "html/style.css">
		<script>
			function init_menu(item, status) {
				var div = document.getElementById(item + ".div");
				div.style.display = status;
			}	
			
			function toggle_menu(item) {
				var li = document.getElementById(item + ".li");
				var pos = li.className.lastIndexOf("folder-");
//				alert("" + li.className );

				var div = document.getElementById(item + ".div");
//				alert("" + div.style.display);
				if(div.style.display == "none") {
					div.style.display = "block";
					li.className = li.className.substring(0, pos) + "folder-open";
				} else {
					div.style.display = "none";
					li.className = li.className.substring(0, pos) + "folder-close";
				}
			}	
			
			function load_page(page) {
				document.getElementById("page-content").innerHTML='<object type="text/html" id="page-object" data="' + page + '?btnLanguage=<%=newLocaleStr%>"></object>';
			}
			
			function toggle_language() {
				var btnLanguage = document.getElementById("btnLanguage")

				if (btnLanguage.value == 'cn')
					btnLanguage.value = 'en';
				else
					btnLanguage.value = 'cn';
				
			}
		</script>
		<!-- Chinese character set -->
		<meta charset="utf-8">
	</head>
	<body onload='load_page("html/home.html")'>
		<div id = "header">
			<div id = "site-title">
				<h1>TTVG</h1>
				<p><%=p.getProperty("title")%></p>
			</div>
			<div id = "site-menu">
				<form action="index.jsp" method="POST">
					<button type="submit" id="btnCreate" name="btnCreate" onclick='load_page("jsp/createAccount.jsp"); return false;'><%=p.getProperty("button.createAcc")%></button>
					<button type="submit" id="btnLogIn" name="btnLogIn" onclick='load_page("login.jsp"); return false;'><%=p.getProperty("button.login")%></button>
					<button type="submit" id="btnLogOut" name="btnLogOut" onclick='load_page("jsp/logoutPost.jsp"); return false;'><%=p.getProperty("button.logout")%></button>
					<button type="submit" id="btnLanguage" name="btnLanguage" value="<%=newLocaleStr%>" onclick='toggle_language()'><%=p.getProperty("button.language")%></button>
				</form>
			</div>
		</div>
		<div id="body-container">
			<div id = "sidebar">
				<ul>
<%
    String[] menuList = p.getProperty("menu.submenu").split("\\|");
	for (String menu : menuList){
		String menuName	= "menu." + menu;
		String menuUrl 	= p.getProperty(menuName + ".url");
		String submenu 	= p.getProperty(menuName + ".submenu");
%>
					<a href="">
<%
		String onclickAction = menuUrl != null && menuUrl.length() >= 0 ? "load_page(\"" + menuUrl + "\"); " : "";
		if ( submenu != null && submenu.length() > 0 ){
			onclickAction += "toggle_menu(\"" + menuName + "\"); ";
%>
					<li onclick='<%=onclickAction%>return false;' id="<%=menuName%>.li" class="parent-list folder-close">
<%
		} else {
%>
					<li onclick='<%=onclickAction%>return false;' id="<%=menuName%>.li" class="parent-list link">
<%
		}
%>
					<%=p.getProperty(menuName + ".title")%></li></a>
		
<%
		if ( submenu != null && submenu.length() > 0 ){
%>
						<div id="<%=menuName%>.div">

		<script>
			init_menu("<%=menuName%>", "none");
		</script>
<%
			String[] submenuList = submenu.split("\\|");
			for (String submenuItem : submenuList){
				String submenuName	= menuName + "." + submenuItem;
				String submenuUrl 	= p.getProperty(submenuName + ".url");
				String subsubmenu 	= p.getProperty(submenuName + ".submenu");
%>
						<a href="">
<%
				String onclickAction1 = submenuUrl != null && submenuUrl.length() >= 0 ? "load_page(\"" + submenuUrl + "\"); " : "";
				if ( submenu != null && submenu.length() > 0 ){
					onclickAction1 += "toggle_menu(\"" + submenuName + "\"); ";

%>
							<li onclick='<%=onclickAction1%>return false;' id="<%=submenuName%>.li" class="child-list folder-close">
<%
				} else {
%>
							<li onclick='<%=onclickAction1%>return false;' id="<%=submenuName%>.li" class="child-list link">
<%
				}
%>
							<%=p.getProperty(submenuName + ".title")%></li></a>
		
<%
				if ( subsubmenu != null && subsubmenu.length() > 0 ){
%>
							<div id="<%=submenuName%>.div">
		<script>
			init_menu("<%=submenuName%>", "none");
		</script>

<%
					String[] subsubmenuList = subsubmenu.split("\\|");
					for (String subsubmenuItem : subsubmenuList){
						String subsubmenuName	= submenuName + "." + subsubmenuItem;
						String subsubmenuUrl 	= p.getProperty(subsubmenuName + ".url");
%>
						<a href=""><li onclick='load_page("<%=subsubmenuUrl%>"); return false;' class="child-list indent-2 link">
						<%=p.getProperty(subsubmenuName + ".title")%></li>
						</a>
<%
					}
%>
							</div>
<%
				}
			}
%>
						</div>
<%
		}
	}
%>

				</ul>
			</div>
			<div id = "page-content">
			</div>
		</div>
		<div id="footer">
			<p>&#169;2017 • <%=p.getProperty("copyright")%></p>
		</div>
	</body>
</html>