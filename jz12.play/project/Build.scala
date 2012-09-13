import sbt._
import Keys._
import PlayProject._
import Process._

object ApplicationBuild extends Build {

    val appName         = "JavaZonePlay"
    val appVersion      = "1.0-SNAPSHOT"

    val appDependencies = Seq(

    )

    val main = PlayProject(appName, appVersion, appDependencies, mainLang = JAVA).settings(
      // Add your own project settings here
    )
  "handlebars app/templates/ -f public/javascripts/templates.js" !
}
