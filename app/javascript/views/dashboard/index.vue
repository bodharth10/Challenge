<template>
  <div id="dashboard-index">
    <div class="mt-8 flex justify-between items-center">
      <div
        @click="uploadANewFile"
        class="create-a-new-model-btn flex items-center justify-center cursor-pointer"
      >
        <div class="mr-4">+</div>
        <div class="text-sm">Upload a new file</div>
      </div>
    </div>
    <div v-if="hasUploads" class="ai-table mt-8">
      <div class="th pb-4 flex w-full font-bold text-xl text-color-1 b-b-2">
        <div class="w-220">Title</div>
        <div class="w-228">Description</div>
        <div>File</div>
      </div>
      <div class="tbody flex flex-col b-b">
        <div
          v-for="(upload, index) in uploadList"
          :key="index"
          class="py-4 flex items-center b-b"
        >
          <div class="w-220 flex items-center">
            <div class="ml-4 text-color-1 text-sm">
              {{ upload.attributes.title }}
            </div>
          </div>
          <div class="w-228 text-color-1 f-13">
            {{ upload.attributes.description }}
          </div>
          <div class="flex-grow flex justify-start items-center text-color-1">
            <div class="flex-grow flex flex-col mr-4">
              <div class="f-13">{{ upload.attributes.filename }}</div>
              <div class="flex justify-start flex-wrap items-center">
                <div class="f-10 mr-2">{{ upload.attributes.file_type }}</div>
                <div class="f-8">
                  {{ upload.attributes.file_size | bytesToSize }}
                </div>
              </div>
            </div>
            <div class="flex-shrink-0 mr-4">
              <a title="click to view" :href="upload.attributes.attachment"
                ><i class="fa fa-eye text-xl"></i
              ></a>
            </div>
            <div class="flex-shrink-0">
              <a
                title="click to download"
                download
                :href="upload.attributes.attachment"
                ><i class="fa fa-download"></i
              ></a>
            </div>

            <div class="flex-shrink-0">
              <div class="flex justify-end items-center">
                <div class="ml-8 mr-4">
                  <img
                    @click="deleteFile(upload.id, upload.attributes.title)"
                    class="cursor-pointer"
                    src="/assets/icons/delete_icon.svg"
                  />
                </div>
                <div>
                  <i
                    @click.stop="shareFile(upload.attributes.tiny_url)"
                    class="fa fa-share text-xl text-color-1 cursor-pointer"
                    title="Share"
                  ></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="text-center text-color-1 mt-16">
      No files uploaded yet!
    </div>
    <modal name="share-modal" width="420px" height="auto">
      <div class="flex flex-col items-center p-12">
        <div class="flex justify-between items-center w-full">
          <h1 class="text-color-1 text-2xl font-semibold">
            Share
          </h1>
          <div
            @click="$modal.hide('share-modal')"
            class="text-color-2 cursor-pointer"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </div>
        </div>
        <div class="mt-8 flex justify-start w-full share-div">
          <div
            :class="{ 'bg-blue-300': isCopied }"
            class="flex-grow px-4 py-2 overflow-x-auto"
          >
            {{ shareUrl }}
          </div>
          <div
            @click="copyToClipBoard"
            class="flex-shrink-0 copy-div w-20 py-2 curser-pointer flex items-center justify-center cursor-pointer"
          >
            {{ getText }}
          </div>
        </div>
      </div>
    </modal>
  </div>
</template>

<script>
import UploadFactory from "../../api/resources/upload";
export default {
  name: "dashboard-index",
  props: {
    uploads: String,
    current_user_id: String,
  },
  data() {
    return {
      uploadList: [],
      shareUrl: "",
      isCopied: false,
    };
  },
  watch: {
    isCopied(val) {
      if (val) {
        let $this = this;
        setTimeout(() => {
          $this.isCopied = false;
        }, 1000);
      }
    },
  },
  computed: {
    hasUploads() {
      if (this.uploadList.length > 0) {
        return true;
      } else {
        return false;
      }
    },
    getText() {
      if (this.isCopied) {
        return "Copied!";
      } else {
        return "Copy";
      }
    },
  },
  beforeMount() {
    this.uploadList = JSON.parse(this.uploads).data;
  },
  filters: {
    bytesToSize(bytes) {
      var sizes = ["Bytes", "KB", "MB", "GB", "TB"];
      if (bytes == 0) return "0 Byte";
      var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
      return Math.round(bytes / Math.pow(1024, i), 2) + " " + sizes[i];
    },
  },
  methods: {
    uploadANewFile() {
      window.location = "../upload";
    },
    deleteFile(id, fileName) {
      this.$swal({
        title: "Are you sure?",
        text: `Are sure that you want to delete ${fileName} file?`,
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Delete",
      }).then((result) => {
        if (result.value) {
          UploadFactory.delete(id).then((response) => {
            if (response.status === 204) {
              const index = this.uploadList.findIndex((res) => res.id === id);
              if (index != -1) {
                this.uploadList.splice(index, 1);
              }
              this.$swal({
                title: "",
                text: `${fileName} has been removed`,
                type: "success",
                toast: true,
                position: "bottom-end",
                showConfirmButton: false,
                timer: 1000,
              });
            }
          });
        }
      });
    },
    shareFile(url) {
      this.shareUrl = url;
      this.$modal.show("share-modal");
    },
    async copyToClipBoard() {
      await navigator.clipboard.writeText(this.shareUrl);
      this.isCopied = true;
    },
  },
};
</script>

<style lang="scss" scoped>
.text-color-1 {
  color: #707070;
}
.create-a-new-model-btn {
  border: 1px solid #456fff;
  width: 183px;
  height: 38px;
  color: #456fff;
  border-radius: 8px;
}
.th {
  font-size: 13px;
}
.b-b {
  border-bottom: 1px solid #e8e8e8;
}
.b-b-2 {
  border-bottom: 2px solid #e8e8e8;
}
.text-color-2 {
  color: #a1a1ac;
}
@responsive {
  .w-220 {
    width: 220px;
  }
  .w-228 {
    width: 228px;
  }
  .f-13 {
    font-size: 13px;
  }
  .f-10 {
    font-size: 10px;
  }
  .f-8 {
    font-size: 8px;
  }
  .h-15 {
    height: 15px;
  }
  .w-257 {
    width: 257px;
  }
  .w-267 {
    width: 267px;
  }
}

</style>
<style>
.vm--modal {
  border-radius: 47px !important;
}
</style>
