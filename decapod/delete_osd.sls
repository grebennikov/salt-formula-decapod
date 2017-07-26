{% set osd_ips = [] %}
{% set mon_ips = [] %}

{%- for node_name, node_grains in salt['mine.get'](pillar['decapod']['mon_nodes_wildcard'], 'grains.items').iteritems() %}
    {%- do mon_ips.append(node_grains['decapod_mgmt_ip']) %}
{%- endfor %}
{%- for node_name, node_grains in salt['mine.get'](pillar['decapod']['osd_nodes_wildcard'], 'grains.items').iteritems() %}
  {%- if node_grains['localhost'] in pillar['decapod_lcm']['del_osd'] %}
    {%- do osd_ips.append(node_grains['decapod_mgmt_ip']) %}
  {%- endif %}
{%- endfor %}

configure cluster:
  module.run:
    - name: decapod.configure_cluster
    - decapod_ip: {{ pillar['decapod']['decapod_ip'] }}
    - decapod_user: {{ pillar['decapod']['decapod_user'] }}
    - decapod_pass: {{ pillar['decapod']['decapod_pass'] }}
    - storage_network: {{ pillar['decapod']['storage_network'] }}
    - frontend_network: {{ pillar['decapod']['frontend_network'] }}
    - osd_ips: {{ osd_ips }}
    - mon_ips: {{ mon_ips }}
    - mode: 'remove_osd'

