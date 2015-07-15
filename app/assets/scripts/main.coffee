navToggled = false
modalShown = false
body = document.getElementsByTagName('body')[0]
sidebarDropdowns = document.getElementsByClassName('crs-sidebar__option--has-dropdown')
trigger = document.getElementById('mobileTrigger')
showModal = document.getElementById('modalTrigger')
modalBg = document.getElementById('modalBg')
modalCancel = document.getElementById('modalCancel')
modalConfirm = document.getElementById('modalConfirm')
modal1 = document.getElementById('modal1')
notifyContainer = document.getElementById('notifyContainer')
notifyPassword = document.getElementById('notifyPassword')
notifyError = document.getElementById('notifyError')
notifyTrigger = document.getElementById('notifyTrigger')

# mobile nav

trigger.onclick = ->
  navToggled = !navToggled
  if navToggled == true
    body.className = 'crs-topbar--sticky crs-mobile--show'
  else
    body.className = 'crs-topbar--sticky'

showModal.onclick = ->
  modal1.classList.add('crs-modal--show')

modalBg.onclick = ->
  closeModal()

modalCancel.onclick = ->
  closeModal()

modalConfirm.onclick = ->
  closeModal()
  openNotifyPassword()

notifyTrigger.onclick = ->
  openNotifyError()

notifyPassword.onclick = ->
  notifyPassword.classList.remove('crs-notify--show')

notifyError.onclick = ->
  notifyError.classList.remove('crs-notify--show')

openNotifyError = ->
  notifyError.classList.add('crs-notify--show')

openNotifyPassword = ->
  notifyPassword.classList.add('crs-notify--show')

closeModal = ->
  modal1.classList.remove('crs-modal--show')

# sidebar

for dropdown in sidebarDropdowns
  dropdown.onclick = ->
    if this.className == 'crs-sidebar__option crs-sidebar__option--has-dropdown'
      this.className = 'crs-sidebar__option crs-sidebar__option--has-dropdown crs-sidebar__option--active'
    else if this.className == 'crs-sidebar__option crs-sidebar__option--has-dropdown crs-sidebar__option--active'
      this.className = 'crs-sidebar__option crs-sidebar__option--has-dropdown'
