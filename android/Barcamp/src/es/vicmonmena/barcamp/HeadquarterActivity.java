package es.vicmonmena.barcamp;

import android.app.Activity;
import android.os.Bundle;

/**
 * @author Vicente Montaño Mena
 * @since 06/08/2012
 */
public class HeadquarterActivity extends Activity {

	/**
	 * String to locate this Activity messages in catlog console.
	 */
	private final String TAG = HeadquarterActivity.class.getSimpleName();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_headquarter);
	}
}