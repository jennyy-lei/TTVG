/**
 * 
 */
package com.ttvg.shared.engine.database;

import java.io.File;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * Manager of the DB session factory
 * 
 */
public class MyDatabaseFeactory {

	/**
	 * The default configuration file for DB.
	 */
	public static String m_default_db_config_file	= "config/hibernate.cfg.xml";
	
	/**
	 * Store the session factory for the Hibernate database session connection
	 */
	private static SessionFactory m_sessionFactory 	= null;

	/**
	 * Default Constructor
	 */
	public MyDatabaseFeactory() {
	}

	  /**
	   * Get the session factory to DB from a configuration file
	   *
	   * @param config_file Configuration file
	   * @return Session factory
	   * @throws Exception If error happens
	   * 
	   */
	public static SessionFactory getSessionFactory(String config_file) throws Exception{

    	// This step will read hibernate.cfg.xml and prepare hibernate for use
		if ( m_sessionFactory == null ) {
	    	Configuration config = new Configuration().configure(new File(config_file));
	    	m_sessionFactory = config.buildSessionFactory();
		}
		
	    return m_sessionFactory;
	}

	  /**
	   * Explicitly get the session to DB from a configuration file
	   *
	   * @param config_file Configuration file
	   * @return Session
	   * @throws Exception If error happens
	   * 
	   */
	public static Session getSession(String config_file) throws Exception{
	    Session session = null;

    	// This step will read hibernate.cfg.xml and prepare hibernate for use
	    if ( m_sessionFactory == null ){
	    	getSessionFactory(config_file);
	    }
	    
	    if ( m_sessionFactory != null ){
	    	session = m_sessionFactory.openSession(); 
	    } else
	    	throw new Exception();
	    
	    return session;
	}

	  /**
	   * Get the session from current session factory or default to DB
	   *
	   * @return Session
	   * @throws Exception If error happens
	   * 
	   */
	public static Session getSession() throws Exception{
	    
		return getSession(getPath());
		
	}

	public static String getPath() {
		return MyDatabaseFeactory.class.getProtectionDomain().getCodeSource().getLocation().getPath() + m_default_db_config_file;
	}

}
