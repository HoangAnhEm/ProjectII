const httpStatus = require('http-status');
const { WorkSpace } = require('../models');
const ApiError = require('../utils/ApiError');

/**
 * Tạo workspace mới
 * @param {Object} workspaceBody
 * @returns {Promise<WorkSpace>}
 */
const createWorkspace = async (workspaceBody) => {
    if (await WorkSpace.isNameTaken(workspaceBody.name)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Workspace name already taken');
    }
    return WorkSpace.create(workspaceBody);
};

/**
 * Truy vấn danh sách workspace (phân trang)
 * @param {Object} filter - Bộ lọc MongoDB
 * @param {Object} options - Tùy chọn phân trang/sắp xếp
 * @returns {Promise<QueryResult>}
 */
const queryWorkspaces = async (filter, options) => {
    return WorkSpace.paginate(filter, options);
};

/**
 * Lấy workspace bằng ID
 * @param {ObjectId} id
 * @returns {Promise<WorkSpace>}
 */
const getWorkspaceById = async (id) => {
    const workspace = await WorkSpace.findById(id).populate('members', 'name email');
    if (!workspace) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Workspace not found');
    }
    return workspace;
};

/**
 * Lấy workspace bằng tên
 * @param {string} name
 * @returns {Promise<WorkSpace>}
 */
const getWorkspaceByName = async (name) => {
    return WorkSpace.findOne({ name });
};

/**
 * Kiểm tra trùng tên workspace
 * @param {string} name
 * @param {ObjectId} [excludeWorkspaceId] - ID workspace cần loại trừ
 * @returns {Promise<boolean>}
 */
const isNameTaken = async (name, excludeWorkspaceId) => {
    const workspace = await WorkSpace.findOne({
        name,
        _id: { $ne: excludeWorkspaceId }
    });
    return !!workspace;
};

/**
 * Cập nhật workspace bằng ID
 * @param {ObjectId} workspaceId
 * @param {Object} updateBody
 * @returns {Promise<WorkSpace>}
 */
const updateWorkspaceById = async (workspaceId, updateBody) => {
    const workspace = await getWorkspaceById(workspaceId);

    if (updateBody.name && (await isNameTaken(updateBody.name, workspaceId))) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Workspace name already taken');
    }

    Object.assign(workspace, updateBody);
    await workspace.save();
    return workspace;
};

/**
 * Xóa workspace bằng ID
 * @param {ObjectId} workspaceId
 * @returns {Promise<WorkSpace>}
 */
const deleteWorkspaceById = async (workspaceId) => {
    const workspace = await getWorkspaceById(workspaceId);
    await workspace.deleteOne();
    return workspace;
};

/**
 * Thêm thành viên vào workspace
 * @param {ObjectId} workspaceId 
 * @param {ObjectId} userId 
 * @returns {Promise<WorkSpace>}
 */
const addMember = async (workspaceId, userId) => {
    const workspace = await getWorkspaceById(workspaceId);

    if (workspace.members.includes(userId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'User already in workspace');
    }

    workspace.members.push(userId);
    await workspace.save();
    return workspace.populate('members', 'name email');
};

/**
 * Xóa thành viên khỏi workspace
 * @param {ObjectId} workspaceId 
 * @param {ObjectId} userId 
 * @returns {Promise<WorkSpace>}
 */
const removeMember = async (workspaceId, userId) => {
    const workspace = await getWorkspaceById(workspaceId);

    if (!workspace.members.includes(userId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'User not in workspace');
    }

    workspace.members.pull(userId);
    await workspace.save();
    return workspace.populate('members', 'name email');
};

module.exports = {
    createWorkspace,
    queryWorkspaces,
    getWorkspaceById,
    getWorkspaceByName,
    updateWorkspaceById,
    deleteWorkspaceById,
    addMember,
    removeMember,
};
