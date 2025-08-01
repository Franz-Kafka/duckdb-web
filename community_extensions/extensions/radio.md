---
warning: DO NOT CHANGE THIS MANUALLY, THIS IS GENERATED BY https://github/duckdb/community-extensions repository, check README there
title: radio
excerpt: |
  DuckDB Community Extensions
  Allow interaction with event buses like Websocket and Redis publish/subscribe servers.

docs:
  extended_description: |
    For more information regarding usage, see the [documentation](https://query.farm/duckdb_extension_radio.html).
extension:
  build: cmake
  description: Allow interaction with event buses like Websocket and Redis publish/subscribe servers.
  excluded_platforms: wasm_mvp;wasm_eh;wasm_threads;windows_amd64;windows_amd64_mingw;windows_amd64_rtools
  language: C++
  license: MIT
  maintainers:
    - rustyconover
  name: radio
  version: 1.0.0
repo:
  github: query-farm/radio
  ref: 766f92777d3935e9c25e113f3257b305c313e7c1

extension_star_count: 26
extension_star_count_pretty: 26
extension_download_count: null
extension_download_count_pretty: n/a
image: '/images/community_extensions/social_preview/preview_community_extension_radio.png'
layout: community_extension_doc
---

### Installing and Loading
```sql
INSTALL {{ page.extension.name }} FROM community;
LOAD {{ page.extension.name }};
```

{% if page.docs.hello_world %}
### Example
```sql
{{ page.docs.hello_world }}```
{% endif %}

{% if page.docs.extended_description %}
### About {{ page.extension.name }}
{{ page.docs.extended_description }}
{% endif %}

### Added Functions

<div class="extension_functions_table"></div>

|                    function_name                     | function_type | description | comment | examples |
|------------------------------------------------------|---------------|-------------|---------|----------|
| radio_flush                                          | table         | NULL        | NULL    |          |
| radio_listen                                         | table         | NULL        | NULL    |          |
| radio_received_messages                              | table         | NULL        | NULL    |          |
| radio_sleep                                          | table         | NULL        | NULL    |          |
| radio_subscribe                                      | table         | NULL        | NULL    |          |
| radio_subscription_received_message_add              | table         | NULL        | NULL    |          |
| radio_subscription_received_messages                 | table         | NULL        | NULL    |          |
| radio_subscription_transmit_message_delete           | table         | NULL        | NULL    |          |
| radio_subscription_transmit_messages                 | table         | NULL        | NULL    |          |
| radio_subscription_transmit_messages_delete_finished | table         | NULL        | NULL    |          |
| radio_subscriptions                                  | table         | NULL        | NULL    |          |
| radio_transmit_message                               | table         | NULL        | NULL    |          |
| radio_unsubscribe                                    | table         | NULL        | NULL    |          |
| radio_version                                        | scalar        | NULL        | NULL    |          |


