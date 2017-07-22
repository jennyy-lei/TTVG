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
	String id = null;
	String topic = null;
	String title = null;
	String content = null;
	
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
		id = request.getParameter("id");
		topic = request.getParameter("topic");
		title = request.getParameter("title");
		content = request.getParameter("content");
		if ( title != null && title.length() > 0 )
			title = new String(title.getBytes("ISO8859_1"), "UTF-8");
		if ( content != null && content.length() > 0 )
			content = new String(content.getBytes("ISO8859_1"), "UTF-8");
		
		//Save the posted forum item if not empty
		if ( (title != null && title.length() > 0) && (topic != null && topic.length() > 0) ) {
			transaction = dbSession.beginTransaction();
			Forum item = new Forum();
			item.setDateTime(new Date());
			item.setTopic(topic);
			item.setTitle(title);
			item.setContent(content);
			if ( user != null )
				item.setPerson(user);
			
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
		if ( topic != null && topic.length() > 0 ) {
			forumList = TableRecordOperation.findAllRecord("from Forum where Topic='" + topic + "' order by DateTime desc");
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
	<body>
		<link rel = "stylesheet" type = "text/css" href = "../html/forum.css">
<%
	//If the current forum item is not empty
	if ( id != null && id.length() > 0 ){
		String[] parts = id.split("-");
		StringBuffer tmp = new StringBuffer();
		for(String part : parts)
		{
			if ( tmp.length() > 0 )
				tmp.append("->");
			tmp.append(part+"/");
			tmp.append(p.getProperty(part+".title"));
		}
%>
		<div id = "page-title">
			<div class="title">
				<p><%=tmp.toString()%> 
				</p>
			</div>
		</div>
		<hr/>
<%
	}
%>
		<div id = "page-content">
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
				<form action="topic.jsp" method="POST">
<%
		if ( topic != null && topic.length() > 0 ) {
%>
					<input type="hidden" name="topic" value="<%=topic%>">
<%
		}
%>
					<input type="hidden" name="btnLanguage" value="<%=newLocaleStr%>">
					<table style="width:100%">
						<tr><td align="right"><%=p.getProperty("forum.title")%>:</td><td><input type="text" name="title"></td></tr>
						<tr><td align="right"><%=p.getProperty("forum.content")%>:</td><td><textarea cols="60" rows="5" name="content"></textarea></td></tr>
						<tr><td colspan="2" align="center"><input type="submit" value="<%=p.getProperty("forum.topic")%>"></td></tr>
					</table> 
				</form>
			</fieldset>
		</div>
<%
	}
%>
	</body>
</html>