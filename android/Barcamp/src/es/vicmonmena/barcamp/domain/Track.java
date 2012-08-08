package es.vicmonmena.barcamp.domain;

import com.desandroid.framework.ada.Entity;
import com.desandroid.framework.ada.annotations.Table;
import com.desandroid.framework.ada.annotations.TableField;


/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
@Table(name = "tTrack")
public class Track extends Entity {

	/**
	 * track title
	 */
	@TableField(name = "title", datatype = Entity.DATATYPE_STRING, required = true)
	private String title;
	
	/**
	 * Default constructor.
	 */
	public Track() {
		// TODO Auto-generated constructor stub
	}
	
	/**
	 * Constructor with parameters.
	 * @param title - track title.
	 */
	public Track(String title) {
		this.title = title;
	}
	
	/**
	 * @return track title
	 */
	public String getTitle() {
		return title;
	}
	
	/**
	 * @param title - track title
	 */
	public void setTitle(String title) {
		this.title = title;
	}
}
