const httpStatus = require('http-status');
const { Project } = require('../models');
const ApiError = require('../utils/ApiError');

/**
 * Tạo dự án mới
 * @param {Object} projectBody
 * @returns {Promise<Project>}
 */
const createProject = async (projectBody) => {
    if (await Project.isNameTakenInWorkspace(projectBody.name, projectBody.workspaceId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Project name already exists in this workspace');
    }
    return Project.create(projectBody);
};

/**
 * Lấy danh sách dự án
 * @param {Object} filter - Mongo filter
 * @param {Object} options - Query options
 * @returns {Promise<QueryResult>}
 */
const queryProjects = async (filter, options) => {
    const projects = await Project.paginate(filter, options);
    return projects;
};

/**
 * Lấy dự án theo ID
 * @param {ObjectId} id
 * @returns {Promise<Project>}
 */
const getProjectById = async (id) => {
    return Project.findById(id)
        .populate('managerId', 'name email')
        .populate('members', 'name email')
        .populate('workspaceId', 'name')
        .populate('tasks');
};

/**
 * Lấy danh sách dự án trong workspace
 * @param {ObjectId} workspaceId
 * @returns {Promise<Project[]>}
 */
const getProjectsByWorkspace = async (workspaceId) => {
    return Project.find({ workspaceId })
        .populate('managerId', 'name email');
};

/**
 * Cập nhật dự án
 * @param {ObjectId} projectId
 * @param {Object} updateBody
 * @returns {Promise<Project>}
 */
const updateProjectById = async (projectId, updateBody) => {
    const project = await getProjectById(projectId);
    if (!project) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Project not found');
    }

    if (updateBody.name && await Project.isNameTakenInWorkspace(updateBody.name, project.workspaceId, projectId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Project name already exists in this workspace');
    }

    Object.assign(project, updateBody);
    await project.save();
    return project;
};

/**
 * Xóa dự án
 * @param {ObjectId} projectId
 * @returns {Promise<Project>}
 */
const deleteProjectById = async (projectId) => {
    const project = await getProjectById(projectId);
    if (!project) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Project not found');
    }
    await project.deleteOne();
    return project;
};

/**
 * Thêm thành viên vào dự án
 * @param {ObjectId} projectId
 * @param {ObjectId} userId
 * @returns {Promise<Project>}
 */
const addMember = async (projectId, userId) => {
    const project = await getProjectById(projectId);
    if (!project) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Project not found');
    }

    if (project.members.includes(userId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'User already a member of this project');
    }

    project.members.push(userId);
    await project.save();
    return project.populate('members', 'name email');
};

/**
 * Xóa thành viên khỏi dự án
 * @param {ObjectId} projectId
 * @param {ObjectId} userId
 * @returns {Promise<Project>}
 */
const removeMember = async (projectId, userId) => {
    const project = await getProjectById(projectId);
    if (!project) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Project not found');
    }

    if (!project.members.includes(userId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'User not a member of this project');
    }

    project.members.pull(userId);
    await project.save();
    return project.populate('members', 'name email');
};

module.exports = {
    createProject,
    queryProjects,
    getProjectById,
    getProjectsByWorkspace,
    updateProjectById,
    deleteProjectById,
    addMember,
    removeMember,
};
