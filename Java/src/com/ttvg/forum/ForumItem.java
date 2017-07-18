package com.ttvg.forum;

import java.util.ArrayList;
import java.util.List;

public class ForumItem {
	protected String id;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}

	protected String parent;
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
	}

	protected String user;
	public void setUser(String str){ user = str; }
	public String getUser(){ return user; }

	protected String alias;
	public void setAlias(String str){ alias = str; }
	public String getAlias(){ return alias; }

	protected String photo;
	
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}

	protected String title;
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}

	protected String content;
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}

	protected String time;
	public void setTime(String str){ time = str; }
	public String getTime(){ return time; }

	protected List<ForumItem> children = new ArrayList<ForumItem>();
	public void addChild(ForumItem item){ children.add(item); };
	public List<ForumItem> getChildren(){ return children; };

}
