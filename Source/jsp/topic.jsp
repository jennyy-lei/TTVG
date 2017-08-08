<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="org.hibernate.Session" %>
<%@page import="org.hibernate.Transaction" %>
<%@page import="com.ttvg.shared.engine.base.Constant" %>
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
	String topic = null;
	String title = null;
	String content = null;
	Forum forum = null;
	
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
        
		//Get Post data
		request.setCharacterEncoding("UTF-8");
		op = request.getParameter("op");
		id = request.getParameter("id");
		forumId = request.getParameter("forumId");
		topic = request.getParameter("topic");
		title = request.getParameter("title");
		content = request.getParameter("content");
		if ( op == null || op.length() == 0 )
			op = Constant.PARAM_ACTION_ADD;
		if ( title != null && title.length() > 0 )
			title = new String(title.getBytes("ISO8859_1"), "UTF-8");
		if ( content != null && content.length() > 0 )
			content = new String(content.getBytes("ISO8859_1"), "UTF-8");
		
		if ( forumId != null && forumId.length() > 0 ) {
			forum = TableRecordOperation.getRecord(Integer.parseInt(forumId), Forum.class);
		}
		
		//Save the posted forum item if not empty
		if ( ((forum != null) || (title != null && title.length() > 0)) && (topic != null && topic.length() > 0) ) {
			transaction = dbSession.beginTransaction();
			if ( forum == null && Constant.PARAM_ACTION_ADD.equalsIgnoreCase(op) && (title != null && title.length() > 0) ){
				forum = new Forum();
				forum.setDateTime(new Date());
				forum.setTopic(topic);
				forum.setTitle(title);
				forum.setContent(content);
				if ( user != null )
					forum.setPerson(user);
				
				dbSession.save(forum);			
			} else if ( "remove".equalsIgnoreCase(op) && forum != null ){
				dbSession.delete(forum);		
			}         
			
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
			
		//Log the audit
		if ( forum != null )
			dbSession.save(forum.getAudit(account, op));
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
		
    try{
		// This step will read hibernate.cfg.xml and prepare hibernate for use
    	dbSession = MyDatabaseFeactory.getSession();
		
		//Search for current list of forum items
		if ( topic != null && topic.length() > 0 ) {
			forumList = TableRecordOperation.findAllRecord("from Forum where Topic LIKE'" + topic + "%' order by DateTime desc");
        }
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
	<head>
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
	</head>
	<body>
<%
	//If the current forum item is not empty
	if ( id != null && id.length() > 0 ){
		String[] parts = id.split("-");
		StringBuffer tmp = new StringBuffer();
		for(String part : parts)
		{
			if ( tmp.length() > 0 )
				tmp.append("->");
//			tmp.append(part+"/");
			tmp.append(p.getProperty(part+".title"));
		}
%>
		<div id = "page-title">
			<div class="title">
				<p><%=tmp.toString()%></p>
			</div>
		</div>
		<hr width = "100%" color = "lightgrey" size = "1px" noshade/>
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
				<p><center><%=p.getProperty("forum.topic.all")%></center></p>
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
			if ( Security.CheckPrivilege("Topic", Constant.PARAM_ACTION_REMOVE, account) ){
%>
					<a href="topic.jsp?topic=<%=topic%>&forumId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>&op=Remove"><%=p.getProperty("forum.topic.remove")%></a>
<%
			}
%>
					<span><a href="forum.jsp?forumId=<%=item.getId()%>&btnLanguage=<%=newLocaleStr%>"><%=item.getTitle()%></a>&nbsp;&nbsp;<small>(<%=size%> <%=p.getProperty("forum.bytes")%>)&nbsp;&nbsp;<em>--<%=person.getLastName()%>, <%=person.getGivenName()%>--</em>&nbsp;&nbsp;<%=item.getDateTime()%></small></span>
				</div>
				<div class="forum-text">
					<p>
<%
			if ( size < 200 ) {
%>
						<%=itemContent%> 
<%
			} else {
%>
						<%=itemContent.substring(0, 200)%>...... 
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
	if ( topic != null && topic.length() > 0 && Security.CheckPrivilege("Topic", Constant.PARAM_ACTION_ADD, account) ){
%>
		<hr/>
		<div id = "page-form">
			<fieldset>
				<form action="topic.jsp" method="POST">
					<input type="hidden" name="topic" value="<%=topic%>">
					<input type="hidden" name="op" value="Add">
					<input type="hidden" name="btnLanguage" value="<%=newLocaleStr%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("forum.title")%>:</td><td><input type="text" name="title"></td></tr>
						<tr><td align="right"><%=p.getProperty("forum.content")%>:</td><td><textarea cols="60" rows="5" name="content"></textarea></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("forum.topic.add")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	}
%>
	</body>
</html>