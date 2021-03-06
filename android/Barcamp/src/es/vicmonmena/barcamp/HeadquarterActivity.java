package es.vicmonmena.barcamp;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebView;

/**
 * @author Vicente Montaño Mena
 * @since 06/08/2012
 */
public class HeadquarterActivity extends Activity {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = HeadquarterActivity.class.getSimpleName();
	
	/**
	 * To load html content.
	 */
	private WebView  browser;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		try {
			setContentView(R.layout.activity_headquarter);
			browser = (WebView) findViewById(R.id.webview);
			browser.loadUrl("file:///android_asset/html/DondeCuando.html");
		} catch (Exception e) {
			Log.e(TAG, "An exception was caught loading screen", e);
		}
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.menu_headquarter, menu);
	    return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		boolean result = false; 
		switch (item.getItemId()) {
		case R.id.whereandwhen:
			browser.loadUrl("file:///android_asset/html/DondeCuando.html");
			break;
		case R.id.register:
			browser.loadUrl("file:///android_asset/html/Registro.html");
			break;
		case R.id.guilties:
			browser.loadUrl("file:///android_asset/html/Culpables.html");
			break;
		case R.id.logement:
			browser.loadUrl("file:///android_asset/html/Alojamiento.html");
			break;
		default:
			return super.onOptionsItemSelected(item);
		}
		return result;
	}
}