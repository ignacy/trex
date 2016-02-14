use Mix.Config

import_config "../apps/*/config/config.exs"
import_config "../apps/*/config/#{Mix.env}.exs"
