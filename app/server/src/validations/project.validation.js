const Joi = require('joi');
const { objectId } = require('./custom.validation');

const createProject = {
    body: Joi.object().keys({
        name: Joi.string().required().max(100),
        description: Joi.string().allow(''),
        startDate: Joi.date(),
        endDate: Joi.date().min(Joi.ref('startDate')),
        status: Joi.string().valid('not_started', 'in_progress', 'on_hold', 'completed', 'cancelled'),
        managerId: Joi.string().custom(objectId).required(),
        workspaceId: Joi.string().custom(objectId).required(),
        members: Joi.array().items(Joi.string().custom(objectId)),
        tasks: Joi.array().items(Joi.string().custom(objectId))
    }),
};

const getProjects = {
    query: Joi.object().keys({
        name: Joi.string(),
        status: Joi.string(),
        workspaceId: Joi.string().custom(objectId),
        managerId: Joi.string().custom(objectId),
        sortBy: Joi.string(),
        limit: Joi.number().integer(),
        page: Joi.number().integer(),
    }),
};

const getProject = {
    params: Joi.object().keys({
        projectId: Joi.string().custom(objectId),
    }),
};

const getProjectsByWorkspace = {
    params: Joi.object().keys({
        workspaceId: Joi.string().custom(objectId),
    }),
};

const updateProject = {
    params: Joi.object().keys({
        projectId: Joi.string().custom(objectId),
    }),
    body: Joi.object().keys({
        name: Joi.string().max(100),
        description: Joi.string().allow(''),
        startDate: Joi.date(),
        endDate: Joi.date().min(Joi.ref('startDate')),
        status: Joi.string().valid('not_started', 'in_progress', 'on_hold', 'completed', 'cancelled'),
        managerId: Joi.string().custom(objectId),
        members: Joi.array().items(Joi.string().custom(objectId)),
        tasks: Joi.array().items(Joi.string().custom(objectId))
    }).min(1),
};

const deleteProject = {
    params: Joi.object().keys({
        projectId: Joi.string().custom(objectId),
    }),
};

const modifyMember = {
    params: Joi.object().keys({
        projectId: Joi.string().custom(objectId),
        userId: Joi.string().custom(objectId),
    }),
};

module.exports = {
    createProject,
    getProjects,
    getProject,
    getProjectsByWorkspace,
    updateProject,
    deleteProject,
    modifyMember,
};
