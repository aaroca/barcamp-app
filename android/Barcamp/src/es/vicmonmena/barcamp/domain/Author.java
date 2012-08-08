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

	@TableField(name = "name", datatype = Entity.DATATYPE_DATE, required = true)
	private String name;
	
	@TableField(name = "description", datatype = Entity.DATATYPE_DATE, required = false)
	private String description;
	
	@TableField(name = "twitteraccount", datatype = Entity.DATATYPE_DATE, required = false)
	private String twitterAccount;
	
	@TableField(name = "siteuri", datatype = Entity.DATATYPE_DATE, required = false)
	private String siteURI;
	
	@TableField(name = "image", datatype = Entity.DATATYPE_BLOB, required = false)
	private String image;
	
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
	 * @return the twitterAccount
	 */
	public String getTwitterAccount() {
		return twitterAccount;
	}

	/**
	 * @param twitterAccount the twitterAccount to set
	 */
	public void setTwitterAccount(String twitterAccount) {
		this.twitterAccount = twitterAccount;
	}

	/**
	 * @return the siteURI
	 */
	public String getSiteURI() {
		return siteURI;
	}

	/**
	 * @param siteURI the siteURI to set
	 */
	public void setSiteURI(String siteURI) {
		this.siteURI = siteURI;
	}

	/**
	 * @return the image
	 */
	public String getImage() {
		return image;
	}

	/**
	 * @param image the image to set
	 */
	public void setImage(String image) {
		this.image = image;
	}
	
}
