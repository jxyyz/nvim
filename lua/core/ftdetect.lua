vim.filetype.add({
  pattern = {
    ['.*/ansible/.*%.ya?ml'] = 'ansible',
    ['.*/inventory/.*%.ya?ml'] = 'ansible',
    ['.*/inventories/.*%.ya?ml'] = 'ansible',
    ['.*inventory%.ya?ml'] = 'ansible',
    ['.*playbook.*%.ya?ml'] = 'ansible',
    ['.*site%.ya?ml'] = 'ansible',
    ['.*/playbooks/.*%.ya?ml'] = 'ansible',
    ['.*/molecule/.*%.ya?ml'] = 'ansible',
  },

  extension = {
    ansible = 'ansible',
  },

  filename = {
    ['requirements.yml'] = 'ansible',
    ['galaxy.yml'] = 'ansible',
  },
})
