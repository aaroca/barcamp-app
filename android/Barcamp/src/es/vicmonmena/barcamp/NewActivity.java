package es.vicmonmena.barcamp;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.format.DateFormat;
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
	private New currentNew;
	
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
		Bundle bundle = getIntent().getExtras();
        if (bundle != null && bundle.containsKey(Ctes.PARCELABLE_NEW_KEY)) {
        	currentNew = bundle.getParcelable(Ctes.PARCELABLE_NEW_KEY);
        	
        	// Load meeting title
            ((TextView) findViewById(R.id.new_title)).setText(currentNew.getTitle());            
            ((TextView) findViewById(R.id.new_date)).setText(DateFormat.format("dd MM, yyyy - h:mm aa", currentNew.getDate()));
            ((TextView) findViewById(R.id.new_body)).setText(Html.fromHtml(currentNew.getBody()));
        }
	}
	
    /**
     * @param text
     */
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
