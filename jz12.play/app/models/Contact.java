package models;

import play.db.ebean.*;
import javax.persistence.*;

@Entity
public class Contact extends Model {
    @Id
    public Long id;
    public String firstName;
    public String lastName;
    public String email;

    public static Finder<Long,Contact> find = new Finder(
            Long.class, Contact.class
    );

    public static final Contact[] testData = new Contact[]{
            new Contact() {{
                id = 1L;
                firstName = "Anders";
                lastName = "Norås";
                email = "mail@andersnoras.com";
            }},
            new Contact() {{
                id = 2L;
                firstName = "Donald";
                lastName = "Duck";
            }}
    };
}
