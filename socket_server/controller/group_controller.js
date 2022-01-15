const Group = require('../model/group');

async function createGroup(req, res) {
  const body = req.body;

  const group = new Group({
    ownerId: body.ownerId,
    title: body.title,
    members: body.members,
  });

  try {
    await group.save();
    res.status(200).json({status: true, data: group});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not create Group'});
  }
}

module.exports = {createGroup};
