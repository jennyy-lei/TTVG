<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.base.Security" %>
<%@page import="com.ttvg.shared.engine.database.MyDatabaseFeactory" %>
<%@page import="com.ttvg.shared.engine.database.TableRecordOperation" %>
<%@page import="com.ttvg.shared.engine.database.table.Forum" %>
<%@page import="com.ttvg.shared.engine.database.table.Account" %>
<%@page import="com.ttvg.shared.engine.database.table.Person" %>

<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@include file="../includes/resources.jsp" %>

<%@include file="../includes/account.jsp" %>

<%
    Session dbSession = null;
	Transaction transaction = null;
	List<Object> forumList = null;
	String op = null;
	String id = null;
	String forumId = null;
	String title = null;
	String content = null;
	Forum forum = null;
	Forum cuForum = null;
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		request.setCharacterEncoding("UTF-8");
		op = request.getParameter("op");
		id = request.getParameter("id");
		forumId = request.getParameter("forumId");
		title = request.getParameter("title");
		content = request.getParameter("content");
		if ( op == null || op.length() == 0 )
			op = "Add";
		if ( title != null && title.length() > 0 )
			title = new String(title.getBytes("ISO8859_1"), "UTF-8");
		if ( content != null && content.length() > 0 )
			content = new String(content.getBytes("ISO8859_1"), "UTF-8");
		
		if ( forumId != null && forumId.length() > 0 ) {
			forum = TableRecordOperation.getRecord(Integer.parseInt(forumId), Forum.class);
		}
		
		if ( id != null && id.length() > 0 ) {
			cuForum = TableRecordOperation.getRecord(Integer.parseInt(id), Forum.class);
		}
		
		//Save the posted forum item if not empty
		if ( (cuForum != null) || (title != null && title.length() > 0) ) {
			transaction = dbSession.beginTransaction();
			if ( cuForum == null && "add".equalsIgnoreCase(op) && (title != null && title.length() > 0) ){
				cuForum = new Forum();
				cuForum.setDateTime(new Date());
				cuForum.setTitle(title);
				cuForum.setContent(content);
				if ( user != null )
					cuForum.setPerson(user);
				if ( forum != null ){
					cuForum.setForum(forum);
				}
				
				dbSession.save(cuForum);
			} else if ( "remove".equalsIgnoreCase(op) && cuForum != null ){
				dbSession.delete(cuForum);		
			}         
			
			//Log the audit
			if ( cuForum != null )
				dbSession.save(cuForum.getAudit(account, op));
			
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
<%
		//If the current forum item is not empty
		Forum paraForum = forum.getForum();
		if ( paraForum != null ){
%>
				<div class="title">
					<a href="forum.jsp?forumId=<%=paraForum.getId()%>&btnLanguage=<%=newLocaleStr%>"><%=p.getProperty("button.back")%></a>
				</div>
<%
		}
%>
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
				<p><center><%=p.getProperty("forum.followup.all")%></center></p>
			</div>
<%
	//Display the current forum list
	if ( forumList != null && forumList.size() > 0 ){
		for ( Object obj : forumList ){
			Forum item = ((Forum)obj);
			Person person = item.getPerson();
			String itemContent = item.getContent();
			int size = itemContent != null ? itemContent.length() : 0;
%>
			<div class="forum-item-container">
				<div class="title">
					<img src="../images/<%=person.getImage()%>" class="user-photo">
<%
			//If the current user is login
			if ( Security.CheckPrivilege("Forum", "Remove", account) ){
%>
					<a href="forum.jsp?forumId=<%=forumId%>&id=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>&op=Remove"><%=p.getProperty("forum.followup.remove")%></a>
<%
			}
%>
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
					<p class="comment-count"><a href="forum.jsp?forumId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>"><%=item.getFollowingForums().size()%> <%=p.getProperty("forum.followup.title")%></a></p>
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
	if ( user != null && forumId != null && forumId.length() > 0 ){
%>
		<hr/>
		<div id = "page-form">
			<fieldset>
				<form action="forum.jsp" method="POST">
					<input type="hidden" name="forumId" value="<%=forumId%>">
					<input type="hidden" name="op" value="Add">
					<input type="hidden" name="btnLanguage" value="<%=newLocaleStr%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("forum.title")%>:</td><td><input type="text" name="title"></td></tr>
						<tr><td align="right"><%=p.getProperty("forum.content")%>:</td><td><textarea cols="60" rows="5" name="content"></textarea></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("forum.followup.add")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	}
%>
	</body>
</html>