(function($) {
  var currentId = 0;

  UploadStore = function() {
    var req = new XMLHttpRequest();

    var meta = function(name) {
      var value = $('[name="'+ name +'"]').attr('content');

      if( typeof value === undefined ) {
        throw 'Required meta key not defined. Make sure to set <meta name="'+ name +'" content="anything">.';
      }

      return value;
    };

    var _m = {
      success:  $.noop,
      progress: $.noop,
      error:    $.noop,

      // Path within the upload stores which the file is stored.
      path: meta('upload-policy-path'),

      // URL used as http target for HTTP POST from client.
      url: meta('upload-policy-url'),

      // Retrieve policy provider specific fields to be include with HTTP POST.
      metaFields: function() {
        return $('[name^="upload-policy-field"]').get().map(function(el) {
          var el = $(el),
              key = el.attr('name').substr(20),
              val = el.attr('content');

          return [key, val];
        });
      }(),

      setData: function(data) {
        // TODO: Find a way to calculate real size and depend on 'file' field
        _m.dataSize  = data.file.size;

        // This is stored to reconstruct the upload key. It would be much
        // better to be able to pull this out of the post somehow. Re-using
        // an UploadStore object would cause an exception when executions
        // overlap.
        _m.filename = currentId++ +'/'+ data.file.name;
        // _m.filename  = data.file.name;

        _m.form = new FormData();

        // Attach meta fields.
        $.each(_m.metaFields, function(i, field) {
          // `${filename}` is a magical value always replaced with the current
          // file name.
          _m.form.append(field[0], field[1].replace("${filename}",_m.filename));
        });

        // Attach passed data fields.
        $.each(data, function(k, v) {
          _m.form.append(k, v);
        });
      },

      progressProxy: function(e) {
        if( e.lengthComputable ) {
          var bytesLoaded = e.loaded,
              percentComplete = Math.round(_m.dataSize / bytesLoaded * 100);

          _m.progress(percentComplete);
        } else {
          _m.progress();
        }
      },

      completeProxy: function(e) {
        if( e.target.status >= 200 && e.target.status < 300 ) {
          full_path = [_m.path, _m.filename].filter(String).join('/');

          _m.success(full_path);
        } else {
          _m.error();
        }
      },

      errorProxy: function(e) {
        _m.error();
      },


      // Consuming agent binding

      onProgress: function(cb) {
        _m.progress = cb;
      },

      onSuccess: function(cb) {
        _m.success = cb;
      },

      onError: function(cb) {
        _m.error = cb;
      },

      // Public actions

      save: function() {
        req.open('POST', _m.url);

        req.send(_m.form);
      }
    };

    req.addEventListener('load', _m.completeProxy, false);
    req.addEventListener('error', _m.errorProxy, false);
    req.upload.addEventListener('progress', _m.progressProxy, false);

    return _m;
  }
})(jQuery);
