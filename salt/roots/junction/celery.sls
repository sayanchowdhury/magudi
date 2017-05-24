{% set name = pillar['service']['name'] %}

broker:
  pkg.installed:
    - names:
      - redis-server

/etc/init/{{name}}_celery.conf:
  file.managed:
    - source: salt://junction/files/celery.conf.j2
    - template: jinja
    - defaults:
        name: "{{name}}"
    - user: app

{{name}}_celery:
  service.running:
    - enable: True
    - require:
      - pkg: broker
      - file: /etc/init/{{name}}_celery.conf
      - cmd: migrate_{{name}}
    - watch:
      - file: /etc/init/{{name}}_celery.conf
      - file: /opt/{{name}}/settings/prod.py
      - git: {{name}}_code
