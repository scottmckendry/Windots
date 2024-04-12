return {
    "NTBBloodbath/rest.nvim",
    ft = "http",
    config = function()
        require("rest-nvim").setup({
            result_split_in_place = true,
            stay_in_current_window_after_split = true,
            result = {
                show_statistics = {
                    "time_total",
                    "remote_ip",
                    "response_code",
                },
                show_http_info = false,
                show_url = false,
                show_curl_command = false,
            },
        })
    end,
}
