package es.vicmonmena.barcamp.networking.rss;

import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import nl.matshofman.saxrssreader.RssFeed;
import nl.matshofman.saxrssreader.RssItem;
import nl.matshofman.saxrssreader.RssReader;
import es.vicmonmena.barcamp.domain.New;

/**
 * @author Vicente Montaño Mena
 * @since 11/08/2012
 */
public class BarcampRssReader {
	
	/**
	 * Default constructor
	 */
	public BarcampRssReader() {
		
	}		
	
	/**
	 * Read news from feedURL.
     * @return List<New>
	 * @throws Exception  
     */
    public static List<New> getRssNews(String feedURL) throws Exception {		
    	// Simulates a background job.
    	List<New> news = new ArrayList<New>();        
    	URL url = new URL(feedURL);
		RssFeed feed = RssReader.read(url);

		ArrayList<RssItem> rssItems = feed.getRssItems();
		for(RssItem rssItem : rssItems) {
		    New aNew = new New();
		    aNew.setTitle(rssItem.getTitle());
		    aNew.setBody(rssItem.getContent());
		    Calendar pubDate = Calendar.getInstance();
		    pubDate.setTime(rssItem.getPubDate());
		    aNew.setDate(pubDate);
		    aNew.setUrl(rssItem.getLink());
		    news.add(aNew);
		}            	       
        return news;
	}
}
