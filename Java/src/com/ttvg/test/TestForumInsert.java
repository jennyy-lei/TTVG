package com.ttvg.test;


import java.util.Date;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ttvg.shared.engine.database.MyDatabaseFeactory;
import com.ttvg.shared.engine.database.TableRecordOperation;
import com.ttvg.shared.engine.database.table.Account;
import com.ttvg.shared.engine.database.table.Audit;
import com.ttvg.shared.engine.database.table.Event;
import com.ttvg.shared.engine.database.table.Forum;
import com.ttvg.shared.engine.database.table.Person;

public class TestForumInsert{
  public static void main(String[] args) {
    Session session = null;

    try{
      // This step will read hibernate.cfg.xml and prepare hibernate for use
    	session = MyDatabaseFeactory.getSession();
        Transaction transaction = session.beginTransaction();
        
        Account account = TableRecordOperation.getRecord(1, Account.class);
        Person person = account.getPerson();
        
        System.out.println("Found Person: GivenName: " + person.getGivenName());
        Set<Event> events = person.getEvents();
        if ( events.size() > 0 ){
        	System.out.println("Found Person Events: " + person.getEvents().size());
        	for (Event event : events)
        		System.out.println("Found Person Event title: " + event.getTitle());
        }

        //Create new instance of Person and set values in it by reading them from form object
    	System.out.println("Inserting Records");
    	Forum item = new Forum();
        item.setPerson(person);
        item.setDateTime(new Date());
        item.setTitle("My New forum");
        item.setContent("Some New thing");
        session.save(item);
/*    	
        Forum item1 = new Forum();
        item1.setPerson(person);
        item1.setForum(item);
        item1.setDateTime(new Date());
        item1.setTitle("My following forum");
        item1.setContent("Some thing More");
        
        item.getFollowingForums().add(item1);
        session.save(item1);
*/        

        
        //Log the audit
        session.save(item.getAudit(account, "Add"));
        
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
