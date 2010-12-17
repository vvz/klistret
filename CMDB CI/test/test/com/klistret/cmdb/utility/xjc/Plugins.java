package test.com.klistret.cmdb.utility.xjc;

import org.junit.Before;
import org.junit.Test;

import com.sun.tools.xjc.XJCFacade;

public class Plugins {

	@Before
	public void setUp() throws Exception {

	}

	@Test
	public void execute() throws Throwable {
		String[] args = {
				"-extension",
				"-d",
				"C:/temp",
				"-b",
				"C:/workshop/klistret/CMDB CI/configuration/build/jaxb.binding.xml",
				"C:/workshop/klistret/CMDB CI/src/xsd/pojo.xsd",
				"C:/workshop/klistret/CMDB CI/src/xsd/commons.xsd",
				"C:/workshop/klistret/CMDB CI/src/xsd/xmlschemaNamespace.xsd",
				"C:/workshop/klistret/CMDB CI/src/xsd/element",
				"C:/workshop/klistret/CMDB CI/src/xsd/relation",
				"-Xcollection-setter-injector",
				"-Xinject-code",
				"-Xci"};

		XJCFacade.main(args);

	}
}