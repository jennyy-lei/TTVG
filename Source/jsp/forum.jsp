<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Forum" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>

<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%
    Session dbSession = null;
	Transaction transaction = null;
	List<Object> forumList = null;
	Person user = null;
	String forumId = null;
	String title = null;
	String content = null;
	Forum forum = null;
	
    try{
		//Get current user
		Object obj = session.getAttribute("person");
		if ( obj != null && obj instanceof Person ){
			user = (Person)obj;
		}
		
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		request.setCharacterEncoding("UTF-8");
		forumId = request.getParameter("forumId");
		title = request.getParameter("title");
		content = request.getParameter("content");
		if ( title != null && title.length() > 0 )
			title = new String(title.getBytes("ISO8859_1"), "UTF-8");
		if ( content != null && content.length() > 0 )
			content = new String(content.getBytes("ISO8859_1"), "UTF-8");
		
		if ( forumId != null && forumId.length() > 0 ) {
			forum = TableRecordOperation.getRecord(Integer.parseInt(forumId), Forum.class);
		}
		
		//Save the posted forum item if not empty
		if ( (title != null && title.length() > 0) || (content != null && content.length() > 0) ) {
			transaction = dbSession.beginTransaction();
			Forum item = new Forum();
			item.setDateTime(new Date());
			item.setTitle(title);
			item.setContent(content);
			if ( user != null )
				item.setPerson(user);
			if ( forum != null ){
				item.setForum(forum);
			}
			
			dbSession.save(item);			
			transaction.commit();
		}
        
    }catch(Exception e){
		if ( transaction != null ) transaction.rollback();
		System.out.println(e.getMessage());
    }finally{
      // Close the session after work
    	if (dbSession != null) {
    		dbSession.flush();
    		dbSession.close();
    	}
	}
		
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
		
		//Search for current list of forum items
		String condition = forumId != null && forumId.length() > 0 ? "= '" + forumId + "'" : "is null";
        forumList = TableRecordOperation.findAllRecord("from Forum where ForumId " + condition + " order by DateTime desc");
        
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
%>

<html>
	<body>
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
<%
	//If the current forum item is not empty
	if ( forum != null ){
		Person person = forum.getPerson();
%>
		<div id = "page-title">
			<div class="forum-item-container">
				<div class="title">
					<img src="../images/<%=person.getImage()%>" class="user-photo">
					<span><%=forum.getTitle()%>&nbsp;&nbsp;<small>(<%=forum.getContent().length()%> <%=p.getProperty("forum.bytes")%>)&nbsp;&nbsp;<em>--<%=person.getLastName()%>, <%=person.getGivenName()%>--</em>&nbsp;&nbsp;<%=forum.getDateTime()%></small></span>
				</div>
				<div class="forum-text">
					<p><%=forum.getContent()%> 
					</p>
				</div>
			</div>
		</div>
		<hr/>
<%
	}
%>
		<div id = "page-content">
			<div style="border-bottom: solid 1px lightgrey;">
				<div style="float:right; margin-right: 100px;">
					<span class="page-index">1</span>
					<span class="page-index">2</span>
					<span class="page-index">3</span>
				</div>
				<p><center><%=p.getProperty("forum.allfollowup")%></center></p>
			</div>
<%
	//Display the current forum list
	if ( forumList != null ){
		for ( Object obj : forumList ){
			Forum item = ((Forum)obj);
			Person person = item.getPerson();
			String itemContent = item.getContent();
			int size = itemContent != null ? itemContent.length() : 0;
%>
			<div class="forum-item-container">
				<div class="title">
					<img src="../images/<%=person.getImage()%>" class="user-photo">
					<span><a href="forum.jsp?forumId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>"><%=item.getTitle()%></a>&nbsp;&nbsp;<small>(<%=size%> <%=p.getProperty("forum.bytes")%>)&nbsp;&nbsp;<em>--<%=person.getLastName()%>, <%=person.getGivenName()%>--</em>&nbsp;&nbsp;<%=item.getDateTime()%></small></span>
				</div>
				<div class="forum-text">
					<p>
<%
			if ( size < 100 ) {
%>
						<%=itemContent%> 
<%
			} else {
%>
						<%=itemContent.substring(0, 100)%>...... 
<%
			}
%>						
					</p>
					<p class="comment-count"><a href=""><%=item.getFollowingForums().size()%> <%=p.getProperty("forum.comments")%></a></p>
				</div>
			</div>
<%
		}
	} else {
%>
<%=p.getProperty("search.noresult")%>
<%
	}
%>
		</div>
<%
	//If the current user is login
	if ( user != null ){
%>
		<hr/>
		<div id = "page-form">
			<fieldset>
				<form action="forum.jsp" method="POST">
<%
		if ( forumId != null && forumId.length() > 0 ) {
%>
					<input type="hidden" name="forumId" value="<%=forumId%>">
<%
		}
%>
					<input type="hidden" name="btnLanguage" value="<%=newLocaleStr%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("forum.title")%>:</td><td><input type="text" name="title"></td></tr>
						<tr><td align="right"><%=p.getProperty("forum.content")%>:</td><td><textarea cols="60" rows="5" name="content"></textarea></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("forum.followup")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	}
%>
	</body>
</html>