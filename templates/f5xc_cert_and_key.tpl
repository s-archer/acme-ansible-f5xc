{
    "metadata": {
        "name": "{{ f5xc_object_prefix }}-cert",
        "namespace": "{{ f5xc_namespace }}"
    },
    "spec": {
        "certificate_url": "string:///{{ lookup('file', './certificates/' + inventory_hostname + '/' + inventory_hostname + '.pem.fullchain.crt') | b64encode }}",
        "private_key": {
            "clear_secret_info": {
                "url": "string:///{{ lookup('file', './certificates/' + inventory_hostname + '/' + inventory_hostname + '.pem.key') | b64encode }}",
            }
        }
    }
}
