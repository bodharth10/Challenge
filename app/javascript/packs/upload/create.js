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
import UploadCreate from "../../views/upload/create.vue";

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#vue",
    components: { UploadCreate },
  });
});
