network:
  version: 2
  vlans:
{% for vswitch in vswitches %}
    # Configure vSwitch {{ vswitch.name }}
    {{ ansible_default_ipv4.interface }}.{{ vswitch.vlan }}:
      id: {{ vswitch.vlan }}
      link: {{ ansible_default_ipv4.interface }}
      mtu: {{ vswitch.mtu | default(1400) }}
      addresses: {{ vswitch.addresses }}
{% if vswitch.gateway is defined %}
      routes:
{% for subnet in (vswitch.subnets_to_route | default([])) %}
        - to: {{ subnet.subnet }}
          via: {{ vswitch.gateway }}
{% endfor %}
{% endif %}
{% endfor %}
