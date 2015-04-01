include:
  - pkgs.system.python-pip


{#- Ubuntu Lucid has way too old pip package, we'll need to upgrade "by hand", salt can't do it for us #}
{% if grains['os'] == 'Ubuntu' and grains['osrelease'].startswith('10.') %}
pip-cmd:
  cmd.run:
    - name: pip install --upgrade pip --install-option="--prefix=/usr"
    - reload_modules: true
    - require:
      - pkg: python-pip
      - order: 1

uninstall-system-python-pip:
  pkg.removed:
    - name: python-pip
    - order: 2
{% endif %}

pip:
  pip.installed:
    {%- if salt['config.get']('virtualenv_name', None) %}
    - bin_env: /srv/virtualenvs/{{ salt['config.get']('virtualenv_name') }}
    {%- endif %}
    - index_url: https://pypi-jenkins.saltstack.com/jenkins/develop
    - extra_index_url: https://pypi.python.org/simple
    - upgrade: true
    - reload_modules: true
    - order: last
