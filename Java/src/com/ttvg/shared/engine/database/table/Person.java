package com.ttvg.shared.engine.database.table;

import java.util.Set;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

import com.ttvg.shared.engine.base.EntityResolvable;


@Entity
@Table(name = "person")
public class Person extends EntityResolvable {
	public Person() {
		super();
	}
	
	@Id
	@GenericGenerator(name="Person" , strategy="increment")
	@GeneratedValue(generator="Person")
	@Column(name = "id")
	protected int id;
	public int getId() {
		return id;
	}
	public void setId( int id ) {
		this.id = id;
	}
	 
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.REFRESH)
    @JoinColumn(name = "FatherId")
    protected Person father;
    public Person getFather() {
        return father;
    }
	public void setFather( Person father ) {
		this.father = father;
	}
	 
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.REFRESH)
    @JoinColumn(name = "MotherId")
    protected Person mother;
    public Person getMother() {
        return mother;
    }
	public void setMother( Person mother ) {
		this.mother = mother;
	}
	 
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.REFRESH)
    @JoinColumn(name = "GuardianId")
    protected Person guardian;
    public Person getGuardian() {
        return guardian;
    }
	public void setGuardian( Person guardian ) {
		this.guardian = guardian;
	}
	 
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.PERSIST)
    @JoinTable(
            name = "person_event_link",
            joinColumns = @JoinColumn(name = "PersonId"),
            inverseJoinColumns = @JoinColumn(name = "EventId")
    )
    protected Set<Event> events;
	public Set<Event> getEvents() {
		return events;
	}
	public void setEvents(Set<Event> events) {
		this.events = events;
	}
	
	public boolean hasEvent(Event event) {
		return event != null && hasEvent(event.getId());
	}
	public boolean hasEvent(int eventId) {
		boolean ret = false;
		
		for ( Event item : events ){
			ret = item.getId() == eventId;
			if (ret) break; 
		}
		
		return ret;
	}

	public void removeEvent(Event event) {
		
		if ( event != null )
			removeEvent(event.getId());
		
	}
	public void removeEvent(int eventId) {
		
		for ( Event item : events ){
			if ( item.getId() == eventId ){
				events.remove(item);
				break;
			}
		}
		
	}
	
	@Column(name = "GivenName")
	protected String givenName;
	public String getGivenName() {
		return givenName;
	}
	public void setGivenName( String givenName ) {
		this.givenName = givenName;
	}

	@Column(name = "LastName")
	protected String lastName;
	public String getLastName() {
		return lastName;
	}
	public void setLastName( String lastName ) {
		this.lastName = lastName;
	}

	@Column(name = "MiddleName")
	protected String middleName;
	public String getMiddleName() {
		return middleName;
	}
	public void setMiddleName( String middleName ) {
		this.middleName = middleName;
	}

	@Column(name = "ChineseName")
	protected String chineseName;
	public String getChineseName() {
		return chineseName;
	}
	public void setChineseName( String chineseName ) {
		this.chineseName = chineseName;
	}

	@Column(name = "Image")
	protected String image;
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}

	@Column(name = "Phone")
	protected String phone;
	public String getPhone() {
		return phone;
	}
	public void setPhone( String phone ) {
		this.phone = phone;
	}

	@Column(name = "Mobile")
	protected String mobile;
	public String getMobile() {
		return mobile;
	}
	public void setMobile( String mobile ) {
		this.mobile = mobile;
	}

	@Column(name = "Address")
	protected String address;
	public String getAddress() {
		return address;
	}
	public void setAddress( String address ) {
		this.address = address;
	}
	
	@Override
	public void resolve() throws Exception {
		// TODO Auto-generated method stub
		events.size();
	}

	@Override
	public Audit getAudit(Account account, String action) throws Exception {
		Audit audit = super.getAudit(account, action);
		
		audit.setTarget("Person");
		audit.setContent(this.lastName + ", " + this.givenName);
		
		return audit;		
	}
}
