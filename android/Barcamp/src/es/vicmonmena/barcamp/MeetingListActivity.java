package es.vicmonmena.barcamp;

import java.util.Arrays;
import java.util.LinkedList;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.Toast;
import es.vicmonmena.barcamp.ui.components.HorizontalPagerWithPageControl;
import es.vicmonmena.barcamp.ui.components.HorizontalPagerWithPageControl.OnScreenSwitchListener;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView.OnRefreshListener;
import es.vicmonmena.barcamp.util.Ctes;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class MeetingListActivity extends Activity implements OnRefreshListener, OnScreenSwitchListener, OnItemClickListener {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = MeetingListActivity.class.getSimpleName();

	/**
     * Item list
     */
    private LinkedList<String> mListItems;
    
    /**
     * Current meeting list showed.
     */
    private PullToRefreshListView currentList;
    
    /**
     * Pager for horizontal view scroll.
     */
    private HorizontalPagerWithPageControl mPager;    
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        try {        	
        	setContentView(R.layout.activity_list_meeting);        	
	        mPager = (HorizontalPagerWithPageControl) findViewById(R.id.horizontal_pager);
	        mPager.addPagerControl();
	        mPager.setOnScreenSwitchListener(this);
	        
	        loadList(R.id.meeting_list_1, mStrings1);
        
        } catch(Exception e) {
        	Log.e(TAG, "An exception was caught loading view", e);
        }
    }
    
    /**
     * Load list meetings based on current screen showed.
     * @param listID
     * @param screenID
     * @param data
     */
    private void loadList(int listID, String[] data) {
    	
    	mStrings = data;
    	
    	// Set a listener to be invoked when the list should be refreshed.
        currentList = (PullToRefreshListView) findViewById(listID);
        currentList.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh() {
                // Do work to refresh the list here.
                new GetDataTask().execute();
            }
        });
        
        // Loading list items
        mListItems = new LinkedList<String>();
        mListItems.addAll(Arrays.asList(mStrings));
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
                android.R.layout.simple_list_item_1, mListItems);
        currentList.setAdapter(adapter);
        currentList.setOnItemClickListener(this);
    }
    
    // ---------------------------------------------------------
    
    private class GetDataTask extends AsyncTask<Void, Void, String[]> {

        @Override
        protected String[] doInBackground(Void... params) {
            // Simulates a background job.
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                
            }
            return mStrings;
        }

        @Override
        protected void onPostExecute(String[] result) {
            mListItems.addFirst("Meeting " + numItemRefreshed);
            numItemRefreshed++;
            currentList.onRefreshComplete();
	        super.onPostExecute(result);
        }
    }

    // ---------- OnRefreshListener methods ----------

    @Override
    public void onRefresh() {
        new GetDataTask().execute();
    }
    
    // ---------- OnScreenSwitched methods ----------
    
	@Override
	public void onScreenSwitched(int screen) {
		switch (screen) {
		case 0:
			loadList(R.id.meeting_list_1, mStrings1);
			break;
		case 1:
			loadList(R.id.meeting_list_2, mStrings2);
			break;
		case 2:
			loadList(R.id.meeting_list_3, mStrings3);
			break;
		default:
			showMessage("Error!");
			break;
		}
	}

	// ---------- List Listener -----------
	
	@Override
	public void onItemClick(AdapterView<?> adapter, View view, int position, long id) {		
		Intent intent = new Intent(this, MeetingActivity.class);		
        intent.putExtra(Ctes.PARCELABLE_MEETING_KEY, (String)adapter.getItemAtPosition(position));
		startActivity(intent);
	}
	
	// ---------- TO DELETE -----------

    private int numItemRefreshed = 1;
    
    private String[] mStrings = null;
    private String[] mStrings1 = { "Meeting 1", "Meeting 2", "Meeting 3", "Meeting 4", "Meeting 5"};
    private String[] mStrings2 = { "Meeting 6", "Meeting 7", "Meeting 8", "Meeting 9", "Meeting 10"};
    private String[] mStrings3 = { "Meeting 11", "Meeting 12", "Meeting 13", "Meeting 14", "Meeting 15"};
    
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }	
}
