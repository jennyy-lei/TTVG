package com.ttvg.test;


import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ttvg.shared.engine.database.MyDatabaseFeactory;
import com.ttvg.shared.engine.database.TableRecordOperation;
import com.ttvg.shared.engine.database.table.Forum;

public class TestForumSearch{
  public static void main(String[] args) {
    Session session = null;

    try{
      // This step will read hibernate.cfg.xml and prepare hibernate for use
    	session = MyDatabaseFeactory.getSession();
        Transaction transaction = session.beginTransaction();
        
        //Create new instance of Person and set values in it by reading them from form object
    	System.out.println("Searching Records");
        
        List<Object> forumList = TableRecordOperation.findAllRecord("from Forum where ForumId is null order by DateTime desc");

        for ( Object obj : forumList ){
            System.out.println("Content: " + ((Forum)obj).getContent() + "/Date: " + ((Forum)obj).getDateTime());
        }
        
        transaction.commit();
        System.out.println("Done");
    }catch(Exception e){
      System.out.println(e.getMessage());
    }finally{
        // Close the session after work
    	if (session != null) {
    		session.flush();
    		session.close();
    	}
    }
    
  }
} 
