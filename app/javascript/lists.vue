<template>
  <div id='lists' class='lists'>
    <a class='lists__handler' v-on:click='showLists'>{{ name }} ▼</a>
    <ul :class="['lists__items lists__items--open-' + listsState]">
      <li v-for='item in listItems' :key='item.id' v-on:click='setList(item)'>{{ item.name }}</li>
    </ul>
  </div>
</template>

<script>
  import axios from 'axios'
  import store from 'store2'

  export default {
    props: ['competition'],
    data () {
      return {
        name: 'Attach MaliChimp list',
        listsState: false,
        listItems: [],
        apiKey: store.namespace('global').get('apiKey')
      }
    },
    methods: {
      showLists: function() {
        axios.get('/api/v1/mailchimp/proxy', {
          params: {
            api_key: this.apiKey
          }
        }).then(response => {
          this.listItems  = response.data.lists
          this.listsState = !this.listsState
        })
      },
      setList: function(list) {
        axios.put('/api/v1/competitions/' + this.competition.id, {
          competition: {
            mailchimp_list_id: list.id,
            mailchimp_api_key: this.apiKey
          }
        }).then(response => {
          this.name = list.name
          this.listsState = false
        })
      }
    }
  }
</script>

<style lang='scss' scoped>
  .lists {
    position: relative;
    width: 170px;
    &__handler {
      cursor: pointer;
    }
    &__items {
      display: none;
      position: absolute;
      top: 20px;
      left: 0;
      padding: 0;
      margin: 0;
      width: 100%;
      border: 1px solid gray;
      background: white;

      &--open-true {
        display: block;
      }

      li {
        padding: 10px;
        margin: 0;
        cursor: pointer;
        &:hover {
          background-color: #EEE;
        }
      }
    }
  }
</style>