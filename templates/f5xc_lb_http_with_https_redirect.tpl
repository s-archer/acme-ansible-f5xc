{
  "metadata": {
    "name": "{{ f5xc_object_prefix }}-http",
    "disable": false
  },
  "spec": {
    "domains": [
      "{{ inventory_hostname }}"
    ],
    "http": {
      "dns_volterra_managed": false,
      "port": 80
    },
    "advertise_on_public_default_vip": {},
    "routes": [
      {
        "redirect_route": {
          "http_method": "ANY",
          "path": {
            "prefix": "/"
          },
          "incoming_port": {
            "no_port_match": {}
          },
          "route_redirect": {
            "proto_redirect": "https",
            "host_redirect": "{{ inventory_hostname }}",
            "response_code": 301,
            "retain_all_params": {},
            "port_redirect": 0
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