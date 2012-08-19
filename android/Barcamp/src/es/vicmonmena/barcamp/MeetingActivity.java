package es.vicmonmena.barcamp;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.widget.TextView;
import es.vicmonmena.barcamp.domain.Meeting;
import es.vicmonmena.barcamp.util.Ctes;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class MeetingActivity extends Activity {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = MeetingListActivity.class.getSimpleName();
	
	private Meeting meeting;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		try {
			
			requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
			setContentView(R.layout.activity_meeting);
			getWindow().setFeatureInt(Window.FEATURE_CUSTOM_TITLE, R.layout.titlebar);
		
			makeView();
		} catch (Exception e) {
			Log.e(TAG, "An exception was caught loading screen", e);
		}
	}
	
	/**
	 * Make this view and load information.
	 */
	private void makeView() {
		
		// Load meeting clicked
		Bundle b = getIntent().getExtras();
        if (b != null && b.containsKey(Ctes.PARCELABLE_MEETING_KEY)) {
        	// Load meeting title
            ((TextView)findViewById(R.id.meeting_title)).setText(
            		b.getString(Ctes.PARCELABLE_MEETING_KEY));            
        }
	}
}
