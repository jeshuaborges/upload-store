# UploadStore::Policy

Required fields:

`#url`: Path the url which can receive the http multipart post including the file.

`#path`: Relative path the server should use to store files posted. This should not include a file name. For example posting file `bar.jpeg` with path `foo` should cause the server to create the file `foo/bar.jpeg`.
