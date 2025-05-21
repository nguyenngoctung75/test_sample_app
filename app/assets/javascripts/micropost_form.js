//DOMContentLoaded hoac turbolinks:load
document.addEventListener('DOMContentLoaded', () => {
  const micropostImage = document.getElementById('micropost_image')

  if (micropostImage) {
    micropostImage.addEventListener('change', () => {
      const size_in_megabytes = micropostImage.files[0].size/1024/1024;

      if (size_in_megabytes > 5) {
        alert('Maximum file size is 5MB. Please choose a smaller file.')
        micropostImage.value = '';
      }
    })
  }
})
