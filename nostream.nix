{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "nostream";
  version = "1.25.2";

  src = ./.;

  nativeBuildInputs = with pkgs; [ 
    nodejs
    npm
    typescript
  ];

  environment = {
    SECRET = "your-secret";
    RELAY_PORT = "8008";
    # Master
    NOSTR_CONFIG_DIR = "/home/node/.nostr";
    DB_HOST = "nostream-db";
    DB_PORT = "5432";
    DB_USER = "nostr_ts_relay";
    DB_PASSWORD = "nostr_ts_relay";
    DB_NAME = "nostr_ts_relay";
    DB_MIN_POOL_SIZE = "16";
    DB_MAX_POOL_SIZE = "64";
    DB_ACQUIRE_CONNECTION_TIMEOUT = "60000";
    # Read Replica
    READ_REPLICAS = "2";
    READ_REPLICA_ENABLED = "false";
    # Read Replica No. 1
    RR0_DB_HOST = "db";
    RR0_DB_PORT = "5432";
    RR0_DB_USER = "nostr_ts_relay";
    RR0_DB_PASSWORD = "nostr_ts_relay";
    RR0_DB_NAME = "nostr_ts_relay";
    RR0_DB_MIN_POOL_SIZE = "16";
    RR0_DB_MAX_POOL_SIZE = "64";
    RR0_DB_ACQUIRE_CONNECTION_TIMEOUT = "10000";
    # Read Replica No. 2
    RR1_DB_HOST = "db";
    RR1_DB_PORT = "5432";
    RR1_DB_USER = "nostr_ts_relay";
    RR1_DB_PASSWORD = "nostr_ts_relay";
    RR1_DB_NAME = "nostr_ts_relay";
    RR1_DB_MIN_POOL_SIZE = "16";
    RR1_DB_MAX_POOL_SIZE = "64";
    RR1_DB_ACQUIRE_CONNECTION_TIMEOUT = "10000";
    # Add RR2, RR3, etc. to configure more read replicas
    # Redis
    REDIS_HOST = "nostream-cache";
    REDIS_PORT = "6379";
    REDIS_USER = "default";
    REDIS_PASSWORD = "nostr_ts_relay";
    TOR_HOST = "tor_proxy";
    TOR_CONTROL_PORT = "9051";
    TOR_PASSWORD = "nostr_ts_relay";
    HIDDEN_SERVICE_PORT = "80";
    # Payments Processors
    ZEBEDEE_API_KEY = "your-zebedee-api-key";
    NODELESS_API_KEY = "your-nodeless-api-key";
    NODELESS_WEBHOOK_SECRET = "your-nodeless-webhook-secret";
    OPENNODE_API_KEY = "your-opennode-api-key";
    LNBITS_API_KEY = "your-lnbits-api-key";
    # Enable DEBUG for troubleshooting. Examples:
    # DEBUG: "primary:*"
    # DEBUG: "worker:*"
    # DEBUG: "knex:query"
  };

  buildPhase = ''
    npm install
    npm run build
  '';

  checkPhase = ''
    npm run test:unit
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/* $out/
  '';

  meta = with pkgs.lib; {
    description = "A Nostr relay written in Typescript";
    homepage = "https://github.com/Cameri/nostream";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
