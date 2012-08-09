package es.vicmonmena.barcamp.domain;

import java.util.Calendar;

import com.desandroid.framework.ada.Entity;
import com.desandroid.framework.ada.annotations.Table;
import com.desandroid.framework.ada.annotations.TableField;


/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
@Table(name = "tMeeting")
public class Meeting extends Entity {

	/**
	 * Title
	 */
	@TableField(name = "title", datatype = Entity.DATATYPE_STRING, required = true)
	private String title;	
	
	/**
	 * Description
	 */
	@TableField(name = "description", datatype = Entity.DATATYPE_STRING, required = false)
	private String description;
	
	/**
	 * Time
	 */
	@TableField(name = "time", datatype = Entity.DATATYPE_DATE, required = true)
	private Calendar time;
	
	/**
	 * Author related
	 */
	@TableField(name = "author", datatype = Entity.DATATYPE_ENTITY_REFERENCE, required = true)
	private Author author;
	
	/**
	 * Track related
	 */
	@TableField(name = "track", datatype = Entity.DATATYPE_STRING, required = true)
	private String track;
	
	/**
	 * Default constructor.
	 */
	public Meeting() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the time
	 */
	public Calendar getTime() {
		return time;
	}

	/**
	 * @param time the time to set
	 */
	public void setTime(Calendar time) {
		this.time = time;
	}

	/**
	 * @return the author
	 */
	public Author getAuthor() {
		return author;
	}

	/**
	 * @param author the author to set
	 */
	public void setAuthor(Author author) {
		this.author = author;
	}

	/**
	 * @return the track
	 */
	public String getTrack() {
		return track;
	}

	/**
	 * @param track the track to set
	 */
	public void setTrack(String track) {
		this.track = track;
	}
	
}
