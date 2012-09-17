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
package com.twocharts.www.samples.apps.marketplace.openid.appengine;

import com.google.step2.xmlsimplesign.TrustRootsProvider;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.security.cert.X509Certificate;
import java.util.Collection;

public class AppEngineTrustsRootProvider implements TrustRootsProvider {

  private static final String CERT_FILE = "/cacerts.bin";

  private final Collection<X509Certificate> certs;

  @SuppressWarnings("unchecked")
  public AppEngineTrustsRootProvider() {

    try {
      ObjectInputStream in =
          new ObjectInputStream(AppEngineTrustsRootProvider.class.getResourceAsStream(CERT_FILE));
      certs = (Collection<X509Certificate>) in.readObject();
    } catch (IOException e) {
      throw new RuntimeException(e);
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
  }

  public Collection<X509Certificate> getTrustRoots() {
    return certs;
  }
}
