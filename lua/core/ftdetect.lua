vim.filetype.add({
  pattern = {
    ['.*/ansible/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/inventory/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/inventories/.*%.ya?ml'] = 'yaml.ansible',
    ['.*inventory%.ya?ml'] = 'yaml.ansible',
    ['.*playbook.*%.ya?ml'] = 'yaml.ansible',
    ['.*site%.ya?ml'] = 'yaml.ansible',
    ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/molecule/.*%.ya?ml'] = 'yaml.ansible',
  },

  extension = {
    ansible = 'yaml.ansible',
  },

  filename = {
    ['requirements.yml'] = 'yaml.ansible',
    ['galaxy.yml'] = 'yaml.ansible',
  },
})
