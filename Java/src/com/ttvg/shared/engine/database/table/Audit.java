package com.ttvg.shared.engine.database.table;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

import com.ttvg.shared.engine.base.Auditable;


@Entity
@Table(name = "action_audit")
public class Audit extends Auditable{
	public Audit() {
		super();
	}
	
	@Id
	@GenericGenerator(name="Audit" , strategy="increment")
	@GeneratedValue(generator="Audit")
	@Column(name = "id")
	protected int id;
	public int getId() {
		return id;
	}
	public void setId( int id ) {
		this.id = id;
	}
	 
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinColumn(name = "AccountId")
    protected Account account;
    public Account getAccount() {
        return account;
    }
	public void setAccount( Account account ) {
		this.account = account;
	}

	@Column(name = "Target")
	protected String target;
	public String getTarget() {
		return target;
	}
	public void setTarget( String target ) {
		this.target = target;
	}

	@Column(name = "Content")
	protected String content;
	public String getContent() {
		return content;
	}
	public void setContent( String content ) {
		this.content = content;
	}

	@Column(name = "Action")
	protected String action;
	public String getAction() {
		return action;
	}
	public void setAction( String action ) {
		this.action = action;
	}

	@Override
	public Audit getAudit(Account account, String action) throws Exception {
		return null;
	}
}
