package es.vicmonmena.barcamp;

import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;

import nl.matshofman.saxrssreader.RssFeed;
import nl.matshofman.saxrssreader.RssItem;
import nl.matshofman.saxrssreader.RssReader;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.Toast;
import es.vicmonmena.barcamp.domain.New;
import es.vicmonmena.barcamp.networking.rss.BarcampRssReader;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView;
import es.vicmonmena.barcamp.ui.components.PullToRefreshListView.OnRefreshListener;
import es.vicmonmena.barcamp.util.Ctes;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class NewsListActivity extends Activity implements OnRefreshListener, OnItemClickListener {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = NewsListActivity.class.getSimpleName();

	/**
     * Item list
     */
    private LinkedList<New> mListItems;
    
    /**
     * Current New list showed.
     */
    private PullToRefreshListView currentList;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        try {
	        setContentView(R.layout.activity_list_new);	        
	        mListItems = new LinkedList<New>();
	        ArrayAdapter<New> adapter = new ArrayAdapter<New>(
	        		this,
	                android.R.layout.simple_list_item_1, 
	                mListItems);        	   
	        
	        currentList = (PullToRefreshListView) findViewById(R.id.new_list);	      
	        currentList.setOnRefreshListener(this);	        
	        currentList.setAdapter(adapter);
	        currentList.setOnItemClickListener(this);
	        
	        new GetDataTask().execute();
	        
        } catch(Exception e) {
        	Log.e(TAG, "An exception was caught loading view", e);
        }
    }    
    
    // ---------------------------------------------------------
    
    private class GetDataTask extends AsyncTask<Void, Void, List> {

        @Override
        protected List<New> doInBackground(Void... params) {   
        	List<New> news = null;
        	try {
        		news = BarcampRssReader.getRssNews(getString(R.string.feed_uri));
        	} catch(Exception e) {
            	Log.e(TAG, "An exception was caught loading view", e);
            }
            return news;
        }

        @Override
        protected void onPostExecute(List result) {
            // mListItems.addFirst("New " + numItemRefreshed);
        	if(result != null && !result.isEmpty()) {
	        	mListItems.clear();
	        	mListItems.addAll(result);
	            currentList.onRefreshComplete();
        	} else {
        		showMessage(getString(R.string.msg_load_news_error));
        	}
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
 		if(adapter.getItemAtPosition(position) instanceof New) {
 			New selectedNew = (New)adapter.getItemAtPosition(position); 			
	 		Intent intent = new Intent(this, NewActivity.class);		
	 		intent.putExtra(Ctes.PARCELABLE_NEW_KEY, selectedNew);
	 		startActivity(intent);
 		} else {
 			showMessage("Error al seleccionar noticia");
 		}
 	}
 	
	// ---------- TO DELETE -----------
    
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
