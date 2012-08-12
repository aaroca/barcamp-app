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
	 * Track title.
	 */
	@TableField(name = "title", datatype = Entity.DATATYPE_STRING, required = true)
	private String title;	
	
	/**
	 * Track description.
	 */
	@TableField(name = "description", datatype = Entity.DATATYPE_STRING, required = false)
	private String description;
	
	/**
	 * Track datetime.
	 */
	@TableField(name = "date", datatype = Entity.DATATYPE_DATE, required = true)
	private Calendar date;
	
	/**
	 * Author related.
	 */
	@TableField(name = "author", datatype = Entity.DATATYPE_ENTITY_REFERENCE, required = true)
	private Author author;
	
	/**
	 * Track related.
	 */
	@TableField(name = "track", datatype = Entity.DATATYPE_STRING, required = true)
	private String track;
	
	/**
	 * Track location.
	 */
	@TableField(name = "location", datatype = Entity.DATATYPE_STRING, required = true)
	private String location;
	
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
	 * @return the date
	 */
	public Calendar getDate() {
		return date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(Calendar date) {
		this.date = date;
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

	/**
	 * @return the location
	 */
	public String getLocation() {
		return location;
	}

	/**
	 * @param location the location to set
	 */
	public void setLocation(String location) {
		this.location = location;
	}	
}
