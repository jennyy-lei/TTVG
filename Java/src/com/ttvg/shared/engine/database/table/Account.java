package com.ttvg.shared.engine.database.table;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

import com.ttvg.shared.engine.base.Auditable;


@Entity
@Table(name = "account")
public class Account extends Auditable{
	public Account() {
		super();
	}
	
	@Id
	@GenericGenerator(name="Account" , strategy="increment")
	@GeneratedValue(generator="Account")
	@Column(name = "id")
	protected int id;
	public int getId() {
		return id;
	}
	public void setId( int id ) {
		this.id = id;
	}
	 
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinColumn(name = "PersonId")
    protected Person person;
    public Person getPerson() {
        return person;
    }
	public void setPerson( Person person ) {
		this.person = person;
	}

	@Column(name = "Role")
	protected String role;
	public String getRole() {
		return role;
	}
	public void setRole( String role ) {
		this.role = role;
	}

	@Column(name = "Email")
	protected String email;
	public String getEmail() {
		return email;
	}
	public void setEmail( String email ) {
		this.email = email;
	}

	@Column(name = "Password")
	protected String password;
	public String getPassword() {
		return password;
	}
	public void setPassword( String password ) {
		this.password = password;
	}

	@Column(name = "Disabled")
	protected Boolean disabled;
	public Boolean getDisabled() {
		return disabled;
	}
	public Boolean isDisabled() {
		return disabled;
	}
	public void setDisabled( Boolean disabled ) {
		this.disabled = disabled;
	}

	@Override
	public Audit getAudit(Account account, String action) throws Exception {
		Audit audit = super.getAudit(account, action);
		
		audit.setTarget("Account");
		audit.setContent(this.getEmail());
		
		return audit;		
	}
}
