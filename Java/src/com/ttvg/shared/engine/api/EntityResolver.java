package com.ttvg.shared.engine.api;

public interface EntityResolver {

	public void resolve() throws Exception;
	public void resolve(int limit) throws Exception;
	
}
