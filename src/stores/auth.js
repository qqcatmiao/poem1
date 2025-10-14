import { defineStore } from 'pinia'
import { supabase } from '../supabase'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    session: null
  }),

  actions: {
    async signUp(email, password) {
      const { data, error } = await supabase.auth.signUp({
        email,
        password
      })
      return { data, error }
    },

    async signIn(email, password) {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })
      if (!error) {
        this.user = data.user
        this.session = data.session
      }
      return { data, error }
    },

    async signOut() {
      const { error } = await supabase.auth.signOut()
      if (!error) {
        this.user = null
        this.session = null
      }
      return { error }
    }
  }
})