<template>
  <div id='keychain'>
    <div class='keychain'>
      <div class='keychain__title'>
        <b>Admin Keychain</b>
        <p>
          Please, type your MailChimp API key in order to manage competition lists &rarr; <span title='Change key'>&bull;&bull;&bull;&bull;&bull;&bull;&bull;</span>
        </p>
      </div>
      <div class='keychain__field'>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: 'Admin keychain'
    }
  }
}
</script>

<style lang='scss' scoped>
  .keychain {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background: #209cee;
    color: #FFF;

    &__title {
      float: left;
      padding: 1em;
      margin-right: 5em;
      b {
        font-size: 1.5em;
        font-weight: normal;
      }
      p {
        margin: 0;
        padding: 0;
      }
      span {
        display: inline-block;
        margin-left: 7px;
        padding-bottom: 5px;
        border-bottom: 1px dashed #FFF;
        font-size: 2em;
        cursor: text;
      }
    }

    &__field {
      float: left;
      padding: 1.2em;
    }
  }
</style>
