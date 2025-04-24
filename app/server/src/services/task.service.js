// services/task.service.js
const { Task } = require('../models');
const ApiError = require('../utils/ApiError');
const httpStatus = require('http-status');

const createTask = async (taskBody) => {
    if (await Task.isNameTakenInProject(taskBody.name, taskBody.project_id)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Task name already exists in this project');
    }
    return Task.create(taskBody);
};

const queryTasks = async (filter, options) => {
    return Task.paginate(filter, options);
};

const getTaskById = async (id) => {
    return Task.findById(id).populate('project_id assignee_id created_by');
};

const updateTaskById = async (taskId, updateBody) => {
    const task = await getTaskById(taskId);
    if (!task) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Task not found');
    }

    if (updateBody.name && await Task.isNameTakenInProject(updateBody.name, task.project_id, taskId)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Task name already exists in this project');
    }

    Object.assign(task, updateBody);
    await task.save();
    return task;
};

const deleteTaskById = async (taskId) => {
    const task = await Task.findByIdAndDelete(taskId);
    return task;
};

const updateTaskAssignee = async (taskId, userId) => {
    return Task.findByIdAndUpdate(
        taskId,
        { assignee_id: userId },
        { new: true }
    ).populate('assignee_id');
};

module.exports = {
    createTask,
    queryTasks,
    getTaskById,
    updateTaskById,
    deleteTaskById,
    updateTaskAssignee,
};
