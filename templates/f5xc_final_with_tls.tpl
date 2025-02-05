{
  "metadata": {
    "name": "{{ f5xc_object_prefix }}-https",
    "disable": false
  },
  "spec": {
    "domains": [
      "{{ inventory_hostname }}"
    ],
    "https": {
      "http_redirect": false,
      "add_hsts": true,
      "port": 443,
      "tls_cert_params": {
        "certificates": [
          {
            "namespace": "{{ f5xc_namespace }}",
            "name": "{{ f5xc_object_prefix }}-cert",
          }
        ],
        "no_mtls": {}
      }
    },
    "advertise_on_public_default_vip": {},
    "routes": [
      {
        "direct_response_route": {
          "http_method": "ANY",
          "path": {
            "prefix": "/"
          },       
          "incoming_port": {
            "no_port_match": {}
          },
          "route_direct_response": {
            "response_code": 200,
            "response_body": "<html>\n<head>\n  <title>ACME Demo</title>\n  <style>\n    body { font-family: sans-serif; text-align: center; margin: 20px; }\n    button { padding: 10px; cursor: pointer; }\n  </style>\n</head>\n<body>\n  <h2>Welcome to the ACME Demo</h2>\n  <p id=\"msg\">Click the button!</p>\n  <button onclick=\"document.getElementById('msg').innerText='Hello, World!'\">Click Me</button>\n</body>\n</html>"
          }
        }
      }
    ],
    "disable_waf": {},
    "add_location": true,
    "no_challenge": {},
    "user_id_client_ip": {},
    "disable_rate_limit": {},
    "service_policies_from_namespace": {},
    "round_robin": {},
    "disable_trust_client_ip_headers": {},
    "disable_malicious_user_detection": {},
    "disable_api_discovery": {},
    "disable_bot_defense": {},
    "default_sensitive_data_policy": {},
    "disable_api_definition": {},
    "disable_ip_reputation": {},
    "disable_client_side_defense": {},
    "system_default_timeouts": {},
    "disable_threat_mesh": {},
    "l7_ddos_action_default": {},
    "more_option": {
      "response_headers_to_add": [
        {
          "name": "Content-Type",
          "value": "text/html",
          "append": false
        }
      ],
      "max_request_header_size": 60,
      "idle_timeout": 30000,
      "disable_default_error_pages": false
    }
  }
}