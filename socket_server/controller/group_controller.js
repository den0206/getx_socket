const Group = require('../model/group');
const {checkId} = require('../db/database');

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

async function findByUserId(req, res) {
  const userId = req.params.userId;
  if (!checkId(userId))
    return res.status(400).json({status: false, message: 'Invalid id'});

  const groups = await Group.find({members: {$in: [userId]}}).populate(
    'members',
    '-password'
  );

  try {
    res.status(200).json({status: true, data: groups});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not get Groups'});
  }
}

module.exports = {createGroup, findByUserId};
