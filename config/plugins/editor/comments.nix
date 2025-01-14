{
  plugins = {
    comment = {
      enable = true;
      lazyLoad.enable = false;
      settings = {
        toggler = {
          block = "gb";
        };
        pre_hook = "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
      };
    };
    ts-context-commentstring.enable = true;
  };
}
