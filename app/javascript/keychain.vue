<template>
  <div id='keychain'>
    <div :class="['keychain keychain--open-' + panelState]">
      <a class='keychain__shortcut' v-on:click='panelState = !panelState'>Show keys</a>

      <div :class="['keychain__body keychain__body--visible-' + !fieldState]">
        <b>🗝️ Admin Keychain</b>
        <p>
          Type your MailChimp API key in order to manage subscription lists &rarr; <span title='Change key' :class="['keychain__bullets keychain__bullets--' + bulletsState]" v-on:click='showField'>&bull;&bull;&bull;&bull;&bull;&bull;&bull;</span>
        </p>
      </div>

      <input
        type='text'
        placeholder='Mailchimp API key'
        ref='field'
        :class="['keychain__field keychain__field--visible-' + fieldState]"
        v-model='apiKey'
        v-on:keyup.enter='submitField'
      />
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
  import store from 'store2'

  export default {
    data() {
      return {
        panelState: false,
        fieldState: false,
        bulletsState: 'normal',
        apiKey: store.namespace('global').get('apiKey')
      }
    },
    methods: {
      showField: function() {
        this.fieldState = !this.fieldState
        this.$refs.field.focus()
      },
      submitField: function (event) {
        this.fieldState = false
        this.apiKey = event.target.value
        this.requestApi()
      },
      requestApi: function() {
        axios.get('/api/v1/mailchimp/proxy', {
          params: {
            api_key: this.apiKey
          }
        }).then(response => {
          this.bulletsState = 'success'
          store.namespace('global').set('apiKey', this.apiKey)
        }).catch(error => {
          this.bulletsState = 'error'
        })
      }
    }
  }
</script>

<style lang='scss' scoped>
  $base-color: #209cee;

  .keychain {
    position: fixed;
    top: 0;
    right: 0;
    width: 69px;
    height: 69px;
    overflow: hidden;
    background: $base-color;
    color: white;
    transition: width 0.5s;

    &--open-true {
      width: 100%;
    }

    &__shortcut {
      display: block;
      width: 69px;
      height: 69px;
      position: absolute;
      z-index: 7;
      top: 0;
      right: 0;
      background-color: darken($base-color, 10%);
      background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAs1JREFUWAntVs1rE0EUf+9tIlpsTZNVFIUKUlERBb1LNW38rIgXr6WpgSrqRVH0kv9AUVBMWxS8CPUgQgWTCL3oQRSkiB+ol/SkbRIw9pJm5vm2NnVDN7ubvdqBMG/e529/mXkzACvjf2cAWyUgcijZRQZfQOBjoGnbQjzp74w0AaBvl7IPplvJ2RKAWO/QMLC6CQQGIuaZcepvMd4LwHENxrwAu1jKjY36BeEbQLQveUmcbwFDVgqdLeczBXuRyJGBraSMUfGJA8L5Ynbsrt3eTPYFoDOR3E0K3gvFz4uq6zRMpmuOCfenwmas9oyZBUR4TzGb+ezoZ1OSTW4qIvN1Mc5VVXiwaXEr+l1mnhQNaE1VUOpq04Q2gzeAnnSIgfsZ+XFlMjNri3UUf74c/UGkn8g+OQXptGd+T4cITW8moLXi+NaxopMS6Y2oI+arwkYns13nCcAIGWsWApB+2wNdZYaKZUfCNlc/MXoCWEogG2FJ9hTQt2/IK5fi2nZDzhVoPGH2Jrd4+Vt2DXofSkyNqVuW39xiXI+hmUj2s9JPgcg/U/ZqGpR0yOOl/MgLu9ouuzKgFVxGpqJswgSQ9r8HrAoK2oWJvBBxRVbBAEjgOiYuzORGpAktH7FEagdxVc3kHn5dbgWIxpPTwBxxstV1waiV6Ghi6IzcC5+kLX8x+wZP1hO2OgcGgJoPLBaT/UYHWy1c9w8MQBPck55flpZbYqD79YStzoEBlLNjH0jDR23glJ9Lpxkw11PQLKiuZ4JdqHG+vg4yB2bAPJzaBIid0m43tPekzCDFrZjAAGY7ykVpT93Wr7K+/CsogOB/wfh4dcajzfoB5cUAyxeG/SRy8kHSqzTK1eAyXBlAhNfy8Dwn78EJWrxiXXI1mhA65ErcKa/XO42GxpU7gDa+xnPYgQRHGbWrb2Naa0U1+fRHxmp9Y7ltRbPCwD8G/gDIotyJUrlbMQAAAABJRU5ErkJggg==');
      background-position: 50% 50%;
      background-repeat: no-repeat;
      text-indent: -777em;
      cursor: pointer;
    }

    &__body {
      float: left;
      min-width: 640px;
      padding: 1em;
      margin-right: 5em;

      &--visible-false {
        visibility: hidden;
      }

      b {
        font-size: 1.3em;
        font-weight: normal;
      }
      p {
        margin: 0;
        padding: 0;
        position: relative;
      }
    }

    &__bullets {
      display: inline-block;
      margin-left: 7px;
      padding-bottom: 5px;
      font-size: 2em;
      cursor: text;

      &--normal {
        color: white;
        border-bottom: 1px dashed white;
      }
      &--error {
        color: pink;
        border-bottom: 1px dashed pink;
      }
      &--success {
        color: springgreen;
        border-bottom: 1px dashed springgreen;
      }
    }

    &__field {
      position: absolute;
      top: 1em;
      left: 1em;
      width: 25%;
      font-size: 1em;
      padding: 1em;
      border: 0;
      outline: 0;
      visibility: hidden;

      &--visible-true {
        visibility: visible;
      }
    }
  }
</style>
