package es.vicmonmena.barcamp;

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;
import android.widget.TextView;
import android.widget.Toast;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class BaseActivity extends TabActivity {
		 
	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = HeadquarterActivity.class.getSimpleName();
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		try {			
			setContentView(R.layout.activity_base);
			Resources ressources = getResources(); 
			TabHost tabHost = getTabHost(); 
	 
			// Notice tab
			Intent newIntent = new Intent().setClass(this, NewsListActivity.class);
			TabSpec tabSpecNew = tabHost
			  .newTabSpec("News")
			  .setIndicator("News", ressources.getDrawable(R.drawable.icon_new_config))
			  .setContent(newIntent);
					
			// Meeting tab
			Intent meetingIntent = new Intent().setClass(this, MeetingListActivity.class);
			TabSpec tabSpecMeeting = tabHost
			  .newTabSpec("Meetings")
			  .setIndicator("Meetings", ressources.getDrawable(R.drawable.icon_meeting_config))
			  .setContent(meetingIntent);
	 		
			// Headquarter tab
			Intent headquarterIntent = new Intent().setClass(this, HeadquarterActivity.class);
			TabSpec tabSpecHeadquarter = tabHost
			  .newTabSpec("Headquarter")
			  .setIndicator("Headquarter", ressources.getDrawable(R.drawable.icon_headquarter_config))
			  .setContent(headquarterIntent);
	 		
			// add all tabs 
			tabHost.addTab(tabSpecNew);
			tabHost.addTab(tabSpecMeeting);
			tabHost.addTab(tabSpecHeadquarter);		
	 
			//set Meeting tab as default (zero based)
			tabHost.setCurrentTab(1);
		} catch (Exception e) {
			Log.e(TAG, "An exception was caught loading screen", e);
		}
	}	
	
	protected void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}