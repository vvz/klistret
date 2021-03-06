/**
 ** This file is part of Klistret. Klistret is free software: you can
 ** redistribute it and/or modify it under the terms of the GNU General
 ** Public License as published by the Free Software Foundation, either
 ** version 3 of the License, or (at your option) any later version.

 ** Klistret is distributed in the hope that it will be useful, but
 ** WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 ** General Public License for more details. You should have received a
 ** copy of the GNU General Public License along with Klistret. If not,
 ** see <http://www.gnu.org/licenses/>
 */

package com.klistret.cmdb.utility.saxon;

import javax.xml.namespace.QName;

import net.sf.saxon.Configuration;
import net.sf.saxon.expr.RootExpression;

/**
 * Root is the first node of the XPath tree void of a QName
 * 
 * @author Matthew Young
 * 
 */
public class RootExpr extends Step {

	protected RootExpr(RootExpression expression, Configuration configuration) {
		super(expression, configuration);
	}

	public String getXPath() {
		return RootExpr.getXPath("/");
	}

	public String getXPath(boolean maskLiteral) {
		return getXPath();
	}

	public static String getXPath(String value) {
		return value;
	}

	public Type getType() {
		return Type.Root;
	}

	public QName getQName() {
		return null;
	}
}
