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
package com.twocharts.www.samples.apps.marketplace.openid;


import com.google.inject.Inject;
import com.google.step2.discovery.UrlHostMetaFetcher;
import com.google.step2.http.HttpFetcher;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

/**
 * Fetches host-meta files from a Google-hosted location.
 */
public class GoogleHostedHostMetaFetcher extends UrlHostMetaFetcher {

    private static final String template = "https://www.google.com/accounts/o8/.well-known/host-meta?hd=%s";

    @Inject
    public GoogleHostedHostMetaFetcher(HttpFetcher fetcher) {
        super(fetcher);
    }

    @Override
    protected URI getHostMetaUriForHost(String host) throws URISyntaxException {
        try {
            host = URLEncoder.encode(host, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
        String uri = String.format(template, host);
        return new URI(uri);
    }
}
