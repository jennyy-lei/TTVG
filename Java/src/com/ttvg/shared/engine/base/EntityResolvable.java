package com.ttvg.shared.engine.base;

import com.ttvg.shared.engine.api.EntityResolver;

public abstract class EntityResolvable extends Auditable implements EntityResolver {

	@Override
	public void resolve() throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void resolve(int limit) throws Exception {
		// TODO Auto-generated method stub
		resolve();
	}

}
