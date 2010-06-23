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

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.Consumes;
import javax.ws.rs.core.MediaType;

import com.klistret.cmdb.ci.pojo.Element;
import com.klistret.cmdb.ci.pojo.QueryResponse;
import com.klistret.cmdb.pojo.QueryRequest;

@Path("/resteasy")
public interface ElementService {

	@GET
	@Path("/element/get/{id}")
	@Produces( { MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	Element getById(@PathParam("id")
	Long id);

	List<Element> findByExpressions(String[] expressions, Integer start,
			Integer limit);

	@POST
	@Path("/element/find")
	@Consumes( { MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	QueryResponse findByExpressions(QueryRequest queryRequest);

	@POST
	@Path("/element/set")
	@Consumes( { MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	Element set(Element element);
}
