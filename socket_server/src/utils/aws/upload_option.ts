import multer from 'multer';

const upload = multer({
  limits: {fileSize: 4 * 1024 * 1024},
  fileFilter: (req, file, callback) => {
    const allowedMimes = ['image/jpeg', 'image/jpg', 'image/png', 'video/mp4'];
    if (allowedMimes.includes(file.mimetype)) {
      callback(null, true);
    } else {
      callback(new Error('Invalid file type'));
    }
  },
});

export default upload;
