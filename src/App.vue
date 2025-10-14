<template>
  <div id="app">
    <NavBar />
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import NavBar from './components/NavBar.vue'
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'SimSun', '宋体', serif;
  background-color: #f8f5f0;
  color: #333;
}

.main-content {
  min-height: calc(100vh - 80px);
  padding: 20px;
}
</style>