const httpStatus = require('http-status');
const pick = require('../utils/pick');
const ApiError = require('../utils/ApiError');
const catchAsync = require('../utils/catchAsync');
const { projectService } = require('../services');

/**
 * Tạo dự án mới
 */
const createProject = catchAsync(async (req, res) => {
    const project = await projectService.createProject(req.body);
    res.status(httpStatus.CREATED).send(project);
});

/**
 * Lấy danh sách dự án
 */
const getProjects = catchAsync(async (req, res) => {
    const filter = pick(req.query, ['name', 'status', 'workspaceId', 'managerId']);
    const options = pick(req.query, ['sortBy', 'limit', 'page']);
    const result = await projectService.queryProjects(filter, options);
    res.send(result);
});

/**
 * Lấy dự án theo ID
 */
const getProject = catchAsync(async (req, res) => {
    const project = await projectService.getProjectById(req.params.projectId);
    if (!project) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Project not found');
    }
    res.send(project);
});

/**
 * Lấy dự án theo workspace
 */
const getProjectsByWorkspace = catchAsync(async (req, res) => {
    const projects = await projectService.getProjectsByWorkspace(req.params.workspaceId);
    res.send(projects);
});

/**
 * Cập nhật dự án
 */
const updateProject = catchAsync(async (req, res) => {
    const project = await projectService.updateProjectById(req.params.projectId, req.body);
    res.send(project);
});

/**
 * Xóa dự án
 */
const deleteProject = catchAsync(async (req, res) => {
    await projectService.deleteProjectById(req.params.projectId);
    res.status(httpStatus.NO_CONTENT).send();
});

/**
 * Thêm thành viên vào dự án
 */
const addMember = catchAsync(async (req, res) => {
    const project = await projectService.addMember(
        req.params.projectId,
        req.params.userId
    );
    res.send(project);
});

/**
 * Xóa thành viên khỏi dự án
 */
const removeMember = catchAsync(async (req, res) => {
    const project = await projectService.removeMember(
        req.params.projectId,
        req.params.userId
    );
    res.send(project);
});

module.exports = {
    createProject,
    getProjects,
    getProject,
    getProjectsByWorkspace,
    updateProject,
    deleteProject,
    addMember,
    removeMember,
};
