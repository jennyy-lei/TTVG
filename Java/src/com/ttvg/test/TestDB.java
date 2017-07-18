package com.ttvg.test;


import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ttvg.shared.engine.database.MyDatabaseFeactory;
import com.ttvg.shared.engine.database.table.Person;

public class TestDB{
  public static void main(String[] args) {
    Session session = null;

    try{
      // This step will read hibernate.cfg.xml and prepare hibernate for use
    	session = MyDatabaseFeactory.getSession();
        Transaction transaction = session.beginTransaction();
        //Create new instance of Person and set values in it by reading them from form object
    	System.out.println("Inserting Record");
    	Person item = new Person();
        //item.setId(3);
        item.setGivenName("Given Name Two");
        item.setLastName("First Name Two");
        item.setMiddleName("middleName");
        session.save(item);
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
