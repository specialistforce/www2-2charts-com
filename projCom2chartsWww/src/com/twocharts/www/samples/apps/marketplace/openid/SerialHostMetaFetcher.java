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

import com.google.step2.discovery.HostMeta;
import com.google.step2.discovery.HostMetaException;
import com.google.step2.discovery.HostMetaFetcher;

/**
 * Simple fetcher to serially try different host-meta fetching strategies, returning the
 * first one to find data.
 */
public class SerialHostMetaFetcher implements com.google.step2.discovery.HostMetaFetcher {
    HostMetaFetcher[] fetchers;

    public SerialHostMetaFetcher(HostMetaFetcher ...fetchers) {
        this.fetchers = fetchers;
    }

    public HostMeta getHostMeta(String domain) throws HostMetaException {
        for (int i = 0; i < fetchers.length; ++i) {
            HostMeta info = fetchers[i].getHostMeta(domain);
            if (isValidHostMeta(info)) {
                return info;
            }
        }
        return null;
    }

    protected boolean isValidHostMeta(HostMeta info) {
        if (info != null && !info.getLinks().isEmpty()) {
            return true;
        } else {
            return false;
        }
    }
}
