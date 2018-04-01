/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'
import Keychain from '../keychain.vue'
import Lists from '../lists.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('keychain'))
  new Vue({ el, render: h => h(Keychain) })

  const lists = document.getElementById('lists')

  if (lists != null) {
    const props = JSON.parse(lists.getAttribute('data'))
    new Vue({
      el: lists,
      render: h => h(Lists, { props })
    })
  }
})