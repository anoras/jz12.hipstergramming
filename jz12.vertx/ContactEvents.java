import org.vertx.java.core.Handler;
import org.vertx.java.core.http.HttpServer;
import org.vertx.java.core.http.HttpServerRequest;
import org.vertx.java.core.json.JsonArray;
import org.vertx.java.core.json.JsonObject;
import org.vertx.java.core.sockjs.SockJSServer;
import org.vertx.java.deploy.Verticle;

public class ContactEvents extends Verticle {
  public void start() throws Exception {
    HttpServer server = vertx.createHttpServer();
    JsonArray permitted = new JsonArray();
    permitted.add(new JsonObject()); // Let everything through
    SockJSServer sockJSServer = vertx.createSockJSServer(server);
    sockJSServer.bridge(new JsonObject().putString("prefix", "/eventbus"), permitted, permitted);
    server.listen(8080);
  }
}