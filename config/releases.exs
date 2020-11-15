import Config

packages = System.get_env("PACKAGES", "")
|> String.trim()
|> String.split(" ", trim: true)
|> Enum.map(fn package ->
  case String.split(package, "-", trim: true, parts: 2) do
    [package, version] ->
      {package, version}
    [package | _] ->
      {package, nil}
    [] ->
      nil
  end
end)
|> Enum.reject(&is_nil/1)

config :mini_repo,
  port: String.to_integer(System.get_env("PORT", "4000")),
  url: System.get_env("URL", "http://localhost:4000")

config :mini_repo,
  auth_token: nil,
  repositories: [
    hexpm_mirror: [
      store: {MiniRepo.Store.Local, root: "data"},
      upstream_name: "hexpm",
      upstream_url: "https://repo.hex.pm",
      upstream_public_key: """
      -----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApqREcFDt5vV21JVe2QNB
      Edvzk6w36aNFhVGWN5toNJRjRJ6m4hIuG4KaXtDWVLjnvct6MYMfqhC79HAGwyF+
      IqR6Q6a5bbFSsImgBJwz1oadoVKD6ZNetAuCIK84cjMrEFRkELtEIPNHblCzUkkM
      3rS9+DPlnfG8hBvGi6tvQIuZmXGCxF/73hU0/MyGhbmEjIKRtG6b0sJYKelRLTPW
      XgK7s5pESgiwf2YC/2MGDXjAJfpfCd0RpLdvd4eRiXtVlE9qO9bND94E7PgQ/xqZ
      J1i2xWFndWa6nfFnRxZmCStCOZWYYPlaxr+FZceFbpMwzTNs4g3d4tLNUcbKAIH4
      0wIDAQAB
      -----END PUBLIC KEY-----
      """,
      only: packages,
      sync_interval: :timer.hours(24),
      sync_opts: [timeout: :infinity]
    ]
  ]
