package com.ttvg.shared.engine.base;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.ttvg.shared.engine.database.table.Account;
import com.ttvg.shared.engine.database.table.Audit;

@MappedSuperclass
public abstract class Auditable {
	public Auditable() {
//		created = new Date();
	}
	
	@Column(name = "Created")
    @Temporal(TemporalType.TIMESTAMP)
    protected Date created = new Date();
    public Date getCreatedDateTime() {
        return created;
    }
    public void setCreatedDateTime(Date dateTime) {
        this.created = dateTime;
    }


	public Audit getAudit(Account account, String action) throws Exception {
		Audit audit = new Audit();
		
		audit.setAccount(account);
		audit.setAction(action);
		
		return audit;
		
	}
}
