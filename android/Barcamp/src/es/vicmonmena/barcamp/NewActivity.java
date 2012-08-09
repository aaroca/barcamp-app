package es.vicmonmena.barcamp;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;
import es.vicmonmena.barcamp.domain.New;
import es.vicmonmena.barcamp.util.Ctes;

/**
 * @author Vicente Montaño Mena
 * @since 04/08/2012
 */
public class NewActivity extends Activity  {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = NewActivity.class.getSimpleName();

	/**
	 * Contains new information to show in that view.
	 */
	private New breakingNew;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);        
        try {
	        setContentView(R.layout.activity_new);
	        makeView();
        } catch(Exception e) {
        	Log.e(TAG, "An exception was caught loading view", e);
        }
    }
            
    /**
	 * Make this view and load information.
	 */
	private void makeView() {		
		// Load meeting clicked
		Bundle b = getIntent().getExtras();
        if (b != null && b.containsKey(Ctes.PARCELABLE_NEW_KEY)) {
        	// Load meeting title
            ((TextView) findViewById(R.id.new_title)).setText(
            		b.getString(Ctes.PARCELABLE_NEW_KEY));            
        }
	}
	
    /**
     * @param text
     */
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
