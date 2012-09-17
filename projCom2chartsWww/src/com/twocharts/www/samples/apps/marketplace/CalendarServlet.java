/*******************************************************************************
 * Copyright 2011 Google Inc. All Rights Reserved.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package com.twocharts.www.samples.apps.marketplace;

import com.google.gdata.client.Query;
import com.google.gdata.client.authn.oauth.GoogleOAuthParameters;
import com.google.gdata.client.authn.oauth.OAuthException;
import com.google.gdata.client.authn.oauth.OAuthHmacSha1Signer;
import com.google.gdata.client.calendar.CalendarQuery;
import com.google.gdata.client.calendar.CalendarService;
import com.google.gdata.data.DateTime;
import com.google.gdata.data.calendar.CalendarEventEntry;
import com.google.gdata.data.calendar.CalendarEventFeed;
import com.google.gdata.util.ServiceException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URL;
import java.util.List;

/**
 * Very simple example of using the Google Data APIs with 2-legged OAuth.  This fetches the
 * current user's next calendar event and displays it.
 */
public class CalendarServlet extends HttpServlet {

    CalendarService calendarService;
    String initError;

    /**
     * Initializes the calendar service using OAuth client key & secret from web.xml.  Please note
     * that in production applications the consumer secret should be treated the same as sensitive
     * data that should be protected from casual browsing, as would any password or encryption key.
     *
     * @param config Servlet config
     * @throws ServletException if unable to initialize
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        String consumerKey = getInitParameter("consumer_key");
        String consumerSecret = getInitParameter("consumer_secret");

        GoogleOAuthParameters oauthParameters = new GoogleOAuthParameters();
        oauthParameters.setOAuthConsumerKey(consumerKey);
        oauthParameters.setOAuthConsumerSecret(consumerSecret);

        initError = "";
        calendarService = new CalendarService("marketplace-nextmeeting");
        try {
            calendarService.setOAuthCredentials(oauthParameters, new OAuthHmacSha1Signer());
        } catch (OAuthException e) {
            initError = "Unable to initialize calendar service: " + e.getMessage();
        }
    }

    /**
     * Fetches the next calendar event and renders JSP if the user is logged in.
     *
     * @param req Current servlet request
     * @param resp Current servlet response
     * @throws ServletException if unable to process request
     * @throws IOException
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserInfo user = (UserInfo) req.getSession().getAttribute("user");
        if (user == null ) {
            resp.sendRedirect("?errorString=Invalid user information.");
        } else if (!initError.isEmpty()) {
            resp.sendRedirect("?errorString=" + initError);
        } else {
            try {
                List<CalendarEventEntry> entry = nextEvent(user);
                req.setAttribute("nextEvents", entry);
            } catch (Exception e) {
                resp.sendRedirect("?errorString=Unable to fetch next calendar event: " + e.getMessage());
            }
            req.getRequestDispatcher("/WEB-INF/jsp/meeting.jsp").forward(req, resp);
        }
    }

    /**
     * Handles the actual query for the Google Calendar API.  This is a simple query
     * that checks the user's default calendar for the next event (limit 1, sort by start
     * time).  It also uses 2-legged OAuth (xoauth_requestor_id) to impersonate the user
     * rather than using an individual access token.
     *
     * @param user User to request data for
     * @return Next calendar event, null if none found
     * @throws IOException If error retrieving data
     * @throws ServiceException If error retrieving data
     */
    private List<CalendarEventEntry> nextEvent(UserInfo user) throws IOException, ServiceException {
        URL feedUrl = new URL("https://www.google.com/calendar/feeds/default/private/full");
        CalendarQuery query = new CalendarQuery(feedUrl);
        query.setMinimumStartTime(DateTime.now());
        query.setMaxResults(5);
        query.addCustomParameter(new Query.CustomParameter("orderby", "starttime"));
        query.addCustomParameter(new Query.CustomParameter("sortorder","a"));
        query.addCustomParameter(new Query.CustomParameter("singleevents","true"));
        query.addCustomParameter(new Query.CustomParameter("xoauth_requestor_id", user.getEmail()));

        CalendarEventFeed results = calendarService.query(query, CalendarEventFeed.class);
        if (!results.getEntries().isEmpty()) {
            return results.getEntries();
        } else {
            return null;
        }
    }
}
