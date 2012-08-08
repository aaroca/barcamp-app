package es.vicmonmena.barcamp;

import java.util.Arrays;
import java.util.LinkedList;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Toast;
import es.vicmonmena.barcamp.ui.components.HorizontalPagerWithPageControl;
import es.vicmonmena.barcamp.ui.components.HorizontalPagerWithPageControl.OnScreenSwitchListener;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView.OnRefreshListener;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class NoticeActivity extends Activity  {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = NoticeActivity.class.getSimpleName();

	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        try {
	        setContentView(R.layout.activity_notice);
	        	                
        } catch(Exception e) {
        	Log.e(TAG, "An exception was caught loading view", e);
        }
    }
            
    /**
     * @param text
     */
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
