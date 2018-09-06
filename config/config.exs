use Mix.Config

config :ex_gram, token: "here-put-the-token"

config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O1cq7mKv5Ord7CoCUVG7HvCt8WiQew+xooQ5XmRmzkVUDPpO5qkPujzp1uzMG/V0",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chatter.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

import_config "#{Mix.env}.exs"
