"use strict";

var cloudinary = require("../../server/server");
module.exports = function(Recepi) {
  /**
   * creates a recepi with cloudinary uploader
   * @param {object} data body of the recepi object
   * @param {Function(Error, object)} callback
   */

  Recepi.remoteMethod("new", {
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
        type: "recepi",
        root: true,
        description: "returns the newly created recepi"
      }
    ]
  });

  Recepi.new = async function(data, callback) {
    var {
      dish,
      steps,
      ingridients,
      tags,
      equipments,
      duration,
      profileId,
      image
    } = data;
    // var photo = await cloudinary.uploader.upload(data.image, {
    //   tags: "recepi_photo"
    // });
    let newd = {
      dish,
      steps,
      ingridients,
      tags,
      equipments,
      duration,
      profileId,
      img_url: image
    };
    Recepi.create(newd, (err, rec) => {
      // if (err) {
      //   callback(null, rec);
      // } else {
      //   callback(err, null);
      // }
    });
  };
};
