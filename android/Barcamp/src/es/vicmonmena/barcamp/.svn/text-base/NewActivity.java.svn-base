package es.vicmonmena.barcamp;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.format.DateFormat;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.view.View;
import android.view.Window;
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
	        requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
	        setContentView(R.layout.activity_new);
			getWindow().setFeatureInt(Window.FEATURE_CUSTOM_TITLE, R.layout.titlebar);
			
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
            ((TextView) findViewById(R.id.new_date)).setText(DateFormat.format("EEEE, dd MMMM yyyy - hh:mm", currentNew.getDate()));
            ((TextView) findViewById(R.id.new_body)).setText(Html.fromHtml(currentNew.getBody()));
            ((TextView) findViewById(R.id.new_body)).setMovementMethod(LinkMovementMethod.getInstance());
        }
	}
	
	/**
	 * To share the new in social networks when sher button is clicked.
	 * 
	 * @param view - view item clicked.
	 */
	public void shareNew(View view) {
		
		// prepare the alert box
        AlertDialog.Builder alertbox = new AlertDialog.Builder(this);

        alertbox.setTitle(getString(R.string.share_new_confirm));
        alertbox.setIcon(R.drawable.share_this_icon_selected);
        alertbox.setMessage(currentNew.getTitle());

        // set a positive/yes button and create a listener
        alertbox.setPositiveButton(R.string.yes, new DialogInterface.OnClickListener() {

            // do something when the button is clicked
            public void onClick(DialogInterface dialog, int id) {
            	dialog.cancel();
            	StringBuilder text = new StringBuilder();
        		text.append("@barcampes: ");
        		text.append(currentNew.getTitle()); 
        		text.append(" - #barcampes");	
            	Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
        		shareIntent.putExtra(Intent.EXTRA_TEXT, text.toString());
        		shareIntent.setType("text/plain");
                startActivity(Intent.createChooser(shareIntent, "Send mail..."));            	
            }
        });        

        // set a negative/no button and create a listener
        alertbox.setNegativeButton(R.string.no, new DialogInterface.OnClickListener() {

            // do something when the button is clicked
            public void onClick(DialogInterface arg0, int arg1) {
            	// do nothing
            }
        });
                
        // show it
        alertbox.show();  		
	}
	
    /**
     * @param text
     */
    public void showMessage(final String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}
