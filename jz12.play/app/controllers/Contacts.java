package controllers;

import models.Contact;
import org.codehaus.jackson.JsonNode;
import play.libs.Json;
import play.mvc.Controller;
import play.mvc.Result;
import play.mvc.WebSocket;

public class Contacts extends Controller {
    public static Result index() {
        return ok(Json.toJson(Contact.find.all()));
    }

    public static Result create() {
        Contact contact = Json.fromJson(request().body().asJson(), Contact.class);
        System.out.println(Json.toJson(contact).toString());
        contact.save();
        return ok(Json.toJson(contact));
    }

    public static Result update(Long id) {
        return ok();
    }

    public static Result show(Long id) {
        return ok(Json.toJson(Contact.find.ref(id)));
    }

    public static Result delete(Long id) {
        Contact.find.ref(id).delete();
        return ok();
    }
}
