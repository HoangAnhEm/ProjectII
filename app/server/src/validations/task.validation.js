// validations/task.validation.js
const Joi = require('joi');
const { objectId } = require('./custom.validation');

const createTask = {
    body: Joi.object().keys({
        project_id: Joi.string().custom(objectId).required(),
        name: Joi.string().required().max(255),
        description: Joi.string().allow(''),
        status: Joi.string().valid('to_do', 'in_progress', 'in_review', 'done'),
        priority: Joi.string().valid('low', 'medium', 'high', 'urgent'),
        due_date: Joi.date(),
        estimated_hours: Joi.number().min(0),
        assignee_id: Joi.string().custom(objectId),
    }),
};

const getTasks = {
    query: Joi.object().keys({
        name: Joi.string(),
        status: Joi.string(),
        priority: Joi.string(),
        project_id: Joi.string().custom(objectId),
        sortBy: Joi.string(),
        limit: Joi.number().integer(),
        page: Joi.number().integer(),
    }),
};

const getTask = {
    params: Joi.object().keys({
        taskId: Joi.string().custom(objectId),
    }),
};

const updateTask = {
    params: Joi.object().keys({
        taskId: Joi.string().custom(objectId),
    }),
    body: Joi.object()
        .keys({
            name: Joi.string().max(255),
            description: Joi.string().allow(''),
            status: Joi.string().valid('to_do', 'in_progress', 'in_review', 'done'),
            priority: Joi.string().valid('low', 'medium', 'high', 'urgent'),
            due_date: Joi.date(),
            estimated_hours: Joi.number().min(0),
            actual_hours: Joi.number().min(0),
            assignee_id: Joi.string().custom(objectId),
        })
        .min(1),
};

const deleteTask = {
    params: Joi.object().keys({
        taskId: Joi.string().custom(objectId),
    }),
};

const assignTask = {
    params: Joi.object().keys({
        taskId: Joi.string().custom(objectId),
        userId: Joi.string().custom(objectId),
    }),
};

module.exports = {
    createTask,
    getTasks,
    getTask,
    updateTask,
    deleteTask,
    assignTask,
};
