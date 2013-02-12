## Using javascript helper

TODO: Add javascript test suite for demo.

Assuming there is a file input on a page with the id of `file`.

```javascript
$(function() {
  $('#file').on('change', function(evt) {
    var file = this.files[0],
        store;

    if( !file ) {
      return;
    }

    store = new UploadStore();
    store.setData({file: file});
    store.onProgress(function(percentComplete) {
      console.warn('Progress...', percentComplete);
    });
    store.onSuccess(function(key) {
      console.warn('COMPLETE', key);
    });
    store.save();
  });
});
```
