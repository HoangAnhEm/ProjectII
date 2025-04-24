const httpStatus = require('http-status');
const pick = require('../utils/pick');
const ApiError = require('../utils/ApiError');
const catchAsync = require('../utils/catchAsync');
const { workspaceService } = require('../services');

/**
 * Tạo workspace mới
 */
const createWorkspace = catchAsync(async (req, res) => {
    const workspace = await workspaceService.createWorkspace(req.body);
    res.status(httpStatus.CREATED).send(workspace);
});

/**
 * Lấy danh sách workspace (phân trang)
 */
const getWorkspaces = catchAsync(async (req, res) => {
    const filter = pick(req.query, ['name', 'is_public']);
    const options = pick(req.query, ['sortBy', 'limit', 'page']);
    const result = await workspaceService.queryWorkspaces(filter, options);
    res.send(result);
});

/**
 * Lấy chi tiết workspace bằng ID
 */
const getWorkspace = catchAsync(async (req, res) => {
    const workspace = await workspaceService.getWorkspaceById(req.params.workspaceId);
    res.send(workspace);
});

/**
 * Cập nhật workspace bằng ID
 */
const updateWorkspace = catchAsync(async (req, res) => {
    const workspace = await workspaceService.updateWorkspaceById(req.params.workspaceId, req.body);
    res.send(workspace);
});

/**
 * Xóa workspace bằng ID
 */
const deleteWorkspace = catchAsync(async (req, res) => {
    await workspaceService.deleteWorkspaceById(req.params.workspaceId);
    res.status(httpStatus.NO_CONTENT).send();
});

/**
 * Thêm thành viên vào workspace
 */
const addMember = catchAsync(async (req, res) => {
    const workspace = await workspaceService.addMember(
        req.params.workspaceId,
        req.params.userId
    );
    res.send(workspace);
});

/**
 * Xóa thành viên khỏi workspace
 */
const removeMember = catchAsync(async (req, res) => {
    const workspace = await workspaceService.removeMember(
        req.params.workspaceId,
        req.params.userId
    );
    res.send(workspace);
});

module.exports = {
    createWorkspace,
    getWorkspaces,
    getWorkspace,
    updateWorkspace,
    deleteWorkspace,
    addMember,
    removeMember,
};
