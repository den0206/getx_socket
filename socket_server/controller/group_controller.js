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

async function leaveTheGroup(req, res) {
  const groupId = req.params.groupId;
  const userId = req.userData.userid;
  if (!checkId(groupId))
    return res.status(400).json({status: false, message: 'Invalid id'});

  const findGroup = await Group.findById(groupId);
  if (!findGroup)
    res.status(400).json({status: false, message: 'Not Find TheGroup'});

  if (findGroup.ownerId == userId)
    res
      .status(400)
      .json({status: false, message: 'Owner Cant Leave The Group'});

  try {
    let currentMembers = findGroup.members;
    // remove user id from Array
    currentMembers = currentMembers.filter((id) => id !== userId);

    if (currentMembers.length <= 2) {
      // delete(人数が2を切った時)
      await findGroup.delete();
    } else {
      // update member
      const value = {members: currentMembers};

      await Group.findByIdAndUpdate(groupId, value);
    }

    res.status(200).json({status: true, data: findGroup});
  } catch (e) {
    res.status(500).json({status: false, message: 'Can not Leave theGroups'});
  }
}

async function deleteGroup(req, res) {
  const groupId = req.params.groupId;
  const ownerId = req.params.ownerId;

  [ownerId, groupId].forEach((id) => {
    if (!checkId(id))
      return res.status(400).json({status: false, message: 'Invalid id'});
  });
  const findGroup = await Group.findById(groupId);

  if (!findGroup || findGroup.ownerId != ownerId) {
    return res.status(400).json({status: false, message: 'Not Match OwnerId'});
  }

  try {
    /// delete with pre reletaion
    await findGroup.delete();

    console.log('=== Complete DELETE');
    res.status(200).json({status: true, data: findGroup});
  } catch (e) {
    console.log(e.message);
    res.status(500).json({status: false, message: 'Can not delete Group'});
  }
}

module.exports = {createGroup, findByUserId, leaveTheGroup, deleteGroup};
