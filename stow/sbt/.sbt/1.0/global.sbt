// See: https://github.com/Duhemm/sbt-errors-summary#configuration
import sbt.errorssummary.Plugin.autoImport._

reporterConfig := reporterConfig.value.withReverseOrder(true)

