package es.vicmonmena.barcamp.domain;

import java.util.Calendar;

import android.os.Parcel;
import android.os.Parcelable;

import com.desandroid.framework.ada.Entity;
import com.desandroid.framework.ada.annotations.Table;
import com.desandroid.framework.ada.annotations.TableField;


/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
@Table(name = "tNew")
public class New extends Entity implements Parcelable {

	/**
	 * New title.
	 */
	@TableField(name = "title", datatype = Entity.DATATYPE_STRING, required = true)
	private String title;
	
	/**
	 * New body.
	 */
	@TableField(name = "body", datatype = Entity.DATATYPE_STRING, required = true)
	private String body;
	
	/**
	 * New url.
	 */
	@TableField(name = "url", datatype = Entity.DATATYPE_STRING, required = true)
	private String url;
	
	/**
	 * New datetime.
	 */
	@TableField(name = "date", datatype = Entity.DATATYPE_DATE, required = true)
	private Calendar date;
		
	/**
	 * Is readen.
	 */
	@TableField(name = "read", datatype = Entity.DATATYPE_BOOLEAN, required = true)
	private boolean read;
	
	/**
	 * Default constructor.
	 */
	public New() {
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
	 * @return the body
	 */
	public String getBody() {
		return body;
	}

	/**
	 * @param body the body to set
	 */
	public void setBody(String body) {
		this.body = body;
	}

	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * @param url the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
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
	 * @return the read
	 */
	public boolean isRead() {
		return read;
	}

	/**
	 * @param read the read to set
	 */
	public void setRead(boolean read) {
		this.read = read;
	}

	@Override
	public String toString() {
		return title;
	}

	@Override
	public int describeContents() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		dest.writeString(title);
		dest.writeString(body);
		dest.writeLong(date.getTimeInMillis());
		dest.writeString(url);		
	}
	
	/**
	 * Get new information from parcel objetc.
	 */
	public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
		
		public New createFromParcel(Parcel in) {
			New deserializedNew = new New();
			deserializedNew.setTitle(in.readString());
			deserializedNew.setBody(in.readString());			
			Calendar pubDate = Calendar.getInstance();
			pubDate.setTimeInMillis(in.readLong());
			deserializedNew.setDate(pubDate);
			deserializedNew.setUrl(in.readString());
			return deserializedNew;
		}
	
		public New[] newArray(int size) {
			return new New[size];
		}
	};
}