package es.vicmonmena.barcamp;

import java.util.Arrays;
import java.util.LinkedList;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Toast;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView.OnRefreshListener;
import es.vicmonmena.barcamp.util.Ctes;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class NoticesListActivity extends Activity implements OnRefreshListener, OnItemClickListener {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = NoticesListActivity.class.getSimpleName();

	/**
     * Item list
     */
    private LinkedList<String> mListItems;
    
    /**
     * Current Notice list showed.
     */
    private PullToRefreshListView currentList;
        
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        try {
	        setContentView(R.layout.activity_list_notice);	               
        	        	    	
	    	// Set a listener to be invoked when the list should be refreshed.
	        currentList = (PullToRefreshListView) findViewById(R.id.notice_list);
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
	        
        } catch(Exception e) {
        	Log.e(TAG, "An exception was caught loading view", e);
        }
    }
    
    /**
     * Load list Notices based on current screen showed.
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
            mListItems.addFirst("Notice " + numItemRefreshed);
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

    // ---------- List Listener -----------
	
 	@Override
 	public void onItemClick(AdapterView<?> adapter, View view, int position, long id) {		
 		Intent intent = new Intent(this, NoticeActivity.class);		
         intent.putExtra(Ctes.PARCELABLE_NOTICE_KEY, (String)adapter.getItemAtPosition(position));
 		startActivity(intent);
 	}
 	
	// ---------- TO DELETE -----------

    private int numItemRefreshed = 1;
        
    private String[] mStrings = { "Notice 1", "Notice 2", "Notice 3", "Notice 4", "Notice 5", "Notice 6", "Notice 7", "Notice 8", "Notice 9", "Notice 10"};
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
