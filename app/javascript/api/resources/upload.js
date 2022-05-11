import ApiConnection from "../api_connection";
const resource_api_path = "/upload";

export default {
  create(payload) {
    return ApiConnection.post(`${resource_api_path}`, payload);
  },

  delete(id) {
    return ApiConnection.delete(`${resource_api_path}/${id}`);
  },
};
