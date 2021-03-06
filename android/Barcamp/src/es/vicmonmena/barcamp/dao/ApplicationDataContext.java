package es.vicmonmena.barcamp.dao;

import android.content.Context;

import com.desandroid.framework.ada.ObjectContext;
import com.desandroid.framework.ada.ObjectSet;

import es.vicmonmena.barcamp.domain.Author;
import es.vicmonmena.barcamp.domain.Meeting;
import es.vicmonmena.barcamp.domain.New;


/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class ApplicationDataContext extends ObjectContext {

	/**
     * Database version
     */
    public static final int DATABASE_VERSION = 1;
    /**
     * Database file name.
     */
    public static final String DATABASE_NAME = "barcamp.db";    
    
    /**
     * Author container for management.
     */
    private ObjectSet<Author> authorDAO;
    
    /**
     * Meeting container for management.
     */
    private ObjectSet<Meeting> meetingDAO;
    
    /**
     * Notice container for management.
     */
    private ObjectSet<New> noticeDAO;
	
    /**
	 * Database manager.
	 * 
	 * @param context
	 */
	public ApplicationDataContext(Context context) {
		super(context, DATABASE_NAME, DATABASE_VERSION);
	}	

	/**
	 * @return the authorDAO
	 */
	public ObjectSet<Author> getAuthorDAO() {
		return authorDAO;
	}

	/**
	 * @return the meetingDAO
	 */
	public ObjectSet<Meeting> getMeetingDAO() {
		return meetingDAO;
	}

	/**
	 * @return the noticeDAO
	 */
	public ObjectSet<New> getNoticeDAO() {
		return noticeDAO;
	}
}