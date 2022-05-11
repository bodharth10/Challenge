import Vue from "vue/dist/vue.esm";
import VueSweetalert2 from "vue-sweetalert2";
import "sweetalert2/dist/sweetalert2.min.css";
const swalOptions = {
  allowOutsideClick: false,
  allowEscapeKey: false,
  allowEnterKey: false,
  confirmButtonColor: "#d73f49",
  cancelButtonColor: "#707070",
};
Vue.use(VueSweetalert2, swalOptions);
import VModal from "vue-js-modal";
Vue.use(VModal);
import DashboardIndex from "../../views/dashboard/index.vue";

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#vue",
    components: { DashboardIndex },
  });
});
