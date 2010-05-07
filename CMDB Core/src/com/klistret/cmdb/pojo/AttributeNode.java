package com.klistret.cmdb.pojo;

import javax.xml.namespace.QName;

public class AttributeNode {

	private QName name;

	private QName typeName;

	private boolean isEntity = false;

	/**
	 * Attribute qualified name value
	 * 
	 * @return
	 */
	public QName getName() {
		return name;
	}

	public void setName(QName name) {
		this.name = name;
	}

	/**
	 * A Java type can be mapped to multiple XML types, but one of them is
	 * considered "primary" and used when generating a schema.
	 * 
	 * @return
	 */
	public QName getTypeName() {
		return typeName;
	}

	public void setTypeName(QName typeName) {
		this.typeName = typeName;
	}

	/**
	 * JPA entity
	 * 
	 * @return
	 */
	public boolean isEntity() {
		return isEntity;
	}

	public void setEntity(boolean isEntity) {
		this.isEntity = isEntity;
	}
}
