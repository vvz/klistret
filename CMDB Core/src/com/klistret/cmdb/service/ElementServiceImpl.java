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

package com.klistret.cmdb.service;

import java.util.Collection;

import com.klistret.cmdb.pojo.Element;
import com.klistret.cmdb.dao.ElementDAO;
import com.klistret.cmdb.pojo.PropertyCriteria;
import com.klistret.cmdb.utility.annotations.Timer;

public class ElementServiceImpl implements ElementService {

	private ElementDAO elementDAO;

	public void setElementDAO(ElementDAO elementDAO) {
		this.elementDAO = elementDAO;
	}

	public Integer countByCriteria(PropertyCriteria criteria) {
		return elementDAO.countByCriteria(criteria);
	}

	public Collection<Element> findByCriteria(PropertyCriteria criteria) {
		return elementDAO.findByCriteria(criteria);
	}

	public Element getById(Long id) {
		Element elementProxy = elementDAO.getById(id);

		Element element = new Element();
		element.setId(elementProxy.getId());
		element.setName(elementProxy.getName());
		element.setType(elementProxy.getType());
		element.setFromTimeStamp(elementProxy.getFromTimeStamp());
		element.setToTimeStamp(elementProxy.getToTimeStamp());
		element.setCreateId(elementProxy.getCreateId());
		element.setCreateTimeStamp(elementProxy.getCreateTimeStamp());
		element.setUpdateTimeStamp(elementProxy.getUpdateTimeStamp());
		element.setConfiguration(elementProxy.getConfiguration());

		return element;
	}

	@Timer
	public Element set(Element element) {
		return elementDAO.set(element);
	}
}
