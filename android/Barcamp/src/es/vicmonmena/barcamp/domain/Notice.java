package es.vicmonmena.barcamp.domain;

import java.util.Calendar;

import com.desandroid.framework.ada.Entity;
import com.desandroid.framework.ada.annotations.Table;
import com.desandroid.framework.ada.annotations.TableField;


/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
@Table(name = "tNotice")
public class Notice extends Entity {

	/**
	 * Notice title.
	 */
	@TableField(name = "time", datatype = Entity.DATATYPE_STRING, required = true)
	private String title;
	
	/**
	 * Notice subtitle.
	 */
	@TableField(name = "subtime", datatype = Entity.DATATYPE_STRING, required = true)
	private String subtitle;
	
	/**
	 * Notice datetime.
	 */
	@TableField(name = "time", datatype = Entity.DATATYPE_DATE, required = true)
	private Calendar dateTime;
	
	/**
	 * Notice content.
	 */
	@TableField(name = "time", datatype = Entity.DATATYPE_STRING, required = true)
	private String text;
	
	/**
	 * Default constructor.
	 */
	public Notice() {
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
	 * @return the subtitle
	 */
	public String getSubtitle() {
		return subtitle;
	}

	/**
	 * @param subtitle the subtitle to set
	 */
	public void setSubtitle(String subtitle) {
		this.subtitle = subtitle;
	}

	/**
	 * @return the dateTime
	 */
	public Calendar getDateTime() {
		return dateTime;
	}

	/**
	 * @param dateTime the dateTime to set
	 */
	public void setDateTime(Calendar dateTime) {
		this.dateTime = dateTime;
	}

	/**
	 * @return the text
	 */
	public String getText() {
		return text;
	}

	/**
	 * @param text the text to set
	 */
	public void setText(String text) {
		this.text = text;
	}
}