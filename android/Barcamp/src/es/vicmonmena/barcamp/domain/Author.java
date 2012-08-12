package es.vicmonmena.barcamp.domain;

import com.desandroid.framework.ada.Entity;
import com.desandroid.framework.ada.annotations.Table;
import com.desandroid.framework.ada.annotations.TableField;


/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
@Table(name = "tAuthor")
public class Author extends Entity {

	@TableField(name = "name", datatype = Entity.DATATYPE_STRING, required = true)
	private String name;
	
	@TableField(name = "surname", datatype = Entity.DATATYPE_STRING, required = false)
	private String surname;
	
	@TableField(name = "picture", datatype = Entity.DATATYPE_BLOB, required = false)
	private String picture;	
	
	@TableField(name = "email", datatype = Entity.DATATYPE_STRING, required = false)
	private String email;
	
	@TableField(name = "webpage", datatype = Entity.DATATYPE_STRING, required = false)
	private String webpage;	
	
	@TableField(name = "twitter", datatype = Entity.DATATYPE_STRING, required = false)
	private String twitter;
	
	@TableField(name = "facebook", datatype = Entity.DATATYPE_STRING, required = false)
	private String facebook;
	
	@TableField(name = "linkedin", datatype = Entity.DATATYPE_STRING, required = false)
	private String linkedin;
	
	@TableField(name = "about", datatype = Entity.DATATYPE_STRING, required = false)
	private String about;
	
	/**
	 * Default constructor.
	 */
	public Author() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the surname
	 */
	public String getSurname() {
		return surname;
	}

	/**
	 * @param surname the surname to set
	 */
	public void setSurname(String surname) {
		this.surname = surname;
	}

	/**
	 * @return the picture
	 */
	public String getPicture() {
		return picture;
	}

	/**
	 * @param picture the picture to set
	 */
	public void setPicture(String picture) {
		this.picture = picture;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return the webpage
	 */
	public String getWebpage() {
		return webpage;
	}

	/**
	 * @param webpage the webpage to set
	 */
	public void setWebpage(String webpage) {
		this.webpage = webpage;
	}

	/**
	 * @return the twitter
	 */
	public String getTwitter() {
		return twitter;
	}

	/**
	 * @param twitter the twitter to set
	 */
	public void setTwitter(String twitter) {
		this.twitter = twitter;
	}

	/**
	 * @return the facebook
	 */
	public String getFacebook() {
		return facebook;
	}

	/**
	 * @param facebook the facebook to set
	 */
	public void setFacebook(String facebook) {
		this.facebook = facebook;
	}

	/**
	 * @return the linkedin
	 */
	public String getLinkedin() {
		return linkedin;
	}

	/**
	 * @param linkedin the linkedin to set
	 */
	public void setLinkedin(String linkedin) {
		this.linkedin = linkedin;
	}

	/**
	 * @return the about
	 */
	public String getAbout() {
		return about;
	}

	/**
	 * @param about the about to set
	 */
	public void setAbout(String about) {
		this.about = about;
	}	
}