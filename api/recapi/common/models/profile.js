"use strict";

module.exports = function(Profile) {
  /**
   * creates a recepi with cloudinary uploader
   * @param {object} data body of the recepi object
   * @param {Function(Error, object)} callback
   */

  Profile.remoteMethod("new", {
    accepts: [
      {
        arg: "data",
        type: "object",
        required: true,
        description: "body of the recepi object",
        http: {
          source: "body"
        }
      }
    ],
    returns: [
      {
        arg: "result",
        type: "object",
        root: true,
        description: "returns the newly created recepi"
      }
    ]
  });

  Profile.new = async function(data, callback) {
    let newd = data;
    // var photo =  await cloudinary.uploader.upload(data.image,{tags:"profile_photo"});

    Profile.create(newd, (err, rec) => {
      callback(null, rec);
    });
  };
};
