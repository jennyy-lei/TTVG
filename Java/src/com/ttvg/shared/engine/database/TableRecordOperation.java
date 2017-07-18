package com.ttvg.shared.engine.database;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.proxy.HibernateProxy;

import com.ttvg.shared.engine.api.EntityResolver;

public class TableRecordOperation {
	
	/**
	 * Fetch the get a record from DB by the Hibernate SQL
	 * 
	 * @param id A Hibernate entry ID
	 * @return 
	 * @return A record, null if not found
	 */
	public static synchronized <T> T getRecord(int id, Class<T> cls) throws Exception {
		
		T ret = null;
		
		Session session = null;
		
		try{ 
			session = MyDatabaseFeactory.getSession();

			ret =  session.load(cls, id);
            Hibernate.initialize(ret);

            if ( ret instanceof EntityResolver )
            	((EntityResolver)ret).resolve();
            
	    }catch(Exception e){
	    	throw e;
	    }finally{
	      // Actual contact insertion will happen at this step
	    	if (session != null) {
	    		session.close();
	    	}
	    }
	    
	    return ret;
		
	}
		
	/**
	 * Fetch the first met record from DB by the Hibernate SQL
	 * 
	 * @param h_sql A Hibernate SQL statement
	 * @return A record, null if not found
	 */
	public static synchronized Object findRecord(String h_sql) throws Exception {
		
		Object ret = null;
		
		Session session = null;
		
		try{ 
			session = MyDatabaseFeactory.getSession();

			Query query = session.createQuery(h_sql);
			Iterator it = query.iterate();
	        if (it.hasNext()){
	        	ret = it.next();
	    		if ( ret instanceof HibernateProxy )
	    			((HibernateProxy)ret).getHibernateLazyInitializer().initialize();

	            if ( ret instanceof EntityResolver )
	            	((EntityResolver)ret).resolve();
	        }

	    }catch(Exception e){
	    	throw e;
	    }finally{
	      // Actual contact insertion will happen at this step
	    	if (session != null) {
	    		session.close();
	    	}
	    }
	    
	    return ret;
		
	}
	
	/**
	 * Fetch all records from DB by the Hibernate SQL
	 * 
	 * @param h_sql A Hibernate SQL statement
	 * @return Collection of records
	 */
	public static synchronized List<Object> findAllRecord(String h_sql) throws Exception {
		List<Object> ret = new ArrayList<Object>();
		
		Session session = null;
		
		try{ 
			session = MyDatabaseFeactory.getSession();
			
			Query query = session.createQuery(h_sql);
			for ( Iterator it = query.iterate(); it.hasNext();) {
	    		Object obj = it.next();
	    		if ( obj instanceof HibernateProxy )
	    			((HibernateProxy)obj).getHibernateLazyInitializer().initialize();

	            if ( obj instanceof EntityResolver )
	            	((EntityResolver)obj).resolve();
	            
				ret.add(obj);
			}
	    }catch(Exception e){
	    	throw e;
	    }finally{
	      // Actual contact insertion will happen at this step
	    	if (session != null) {
	    		session.close();
	    	}
	    }
	    
	    return ret;
		
	}
	
	/**
	 * Insert the changed record to DB by the Hibernate SQL
	 * 
	 * @param obj A Hibernate object
	 * @return Success or not
	 */
	public static synchronized boolean insertRecord(Object obj) throws Exception {
		
		boolean ret = false;
		
		if (obj == null) return ret;
			
		Session session = null;
		
		try{ 
			session = MyDatabaseFeactory.getSession();
			
			session.save(obj);
	    }catch(Exception e){
	    	throw e;
	    }finally{
	      // Actual contact insertion will happen at this step
	    	if (session != null) {
	    		session.flush();
	    		session.close();
	    	}
	    }
	    
	    return ret;
		
	}
	
	/**
	 * Update the changed record to DB by the Hibernate SQL
	 * 
	 * @param obj A Hibernate object
	 * @return Success or not
	 */
	public static synchronized boolean updateRecord(Object obj) throws Exception {
		
		boolean ret = false;
		
		if (obj == null) return ret;
			
		Session session = null;
		
		try{ 
			session = MyDatabaseFeactory.getSession();
			
			session.update(obj);
	    }catch(Exception e){
	    	throw e;
	    }finally{
	      // Actual contact insertion will happen at this step
	    	if (session != null) {
	    		session.flush();
	    		session.close();
	    	}
	    }
	    
	    return ret;
		
	}
	
	/**
	 * Delete the record to DB by the Hibernate SQL
	 * 
	 * @param obj A Hibernate object
	 * @return Nil
	 */
	public static synchronized void deleteRecord(Object obj) throws Exception {
			
		Session session = null;
		
		try{ 
			session = MyDatabaseFeactory.getSession();
			
			session.delete(obj);
	    }catch(Exception e){
	    	throw e;
	    }finally{
	      // Actual contact insertion will happen at this step
	    	if (session != null) {
	    		session.flush();
	    		session.close();
	    	}
	    }
		
	}

}
