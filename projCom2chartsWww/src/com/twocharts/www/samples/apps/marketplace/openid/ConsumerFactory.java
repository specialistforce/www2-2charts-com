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

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.step2.ConsumerHelper;
import org.openid4java.consumer.ConsumerAssociationStore;
import org.openid4java.consumer.InMemoryConsumerAssociationStore;

/**
 * Simple wrapper around Guice for applications that use other frameworks/dependency injection
 * methods.  Provides access to a ConsumerHelper instance for implementing an OpenID relying party.
 */
public class ConsumerFactory {

	protected ConsumerHelper helper;

	public ConsumerFactory() {
		this(new InMemoryConsumerAssociationStore());
	}

	public ConsumerFactory(ConsumerAssociationStore store) {
		Injector injector = Guice.createInjector(new GuiceModule(store));
		helper = injector.getInstance(ConsumerHelper.class);
	}

	public ConsumerHelper getConsumerHelper() {
		return helper;
	}
}
