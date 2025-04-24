const Joi = require('joi');
const { objectId } = require('./custom.validation');

const createWorkspace = {
    body: Joi.object().keys({
        name: Joi.string().max(100).required(),
        description: Joi.string().allow(''),
        is_public: Joi.boolean(),
        members: Joi.array().items(Joi.string().custom(objectId)),
    }),
};

const getWorkspaces = {
    query: Joi.object().keys({
        name: Joi.string(),
        is_public: Joi.boolean(),
        sortBy: Joi.string(),
        limit: Joi.number().integer(),
        page: Joi.number().integer(),
    }),
};

const getWorkspace = {
    params: Joi.object().keys({
        workspaceId: Joi.string().custom(objectId),
    }),
};

const updateWorkspace = {
    params: Joi.object().keys({
        workspaceId: Joi.string().custom(objectId),
    }),
    body: Joi.object()
        .keys({
            name: Joi.string().max(100),
            description: Joi.string().allow(''),
            is_public: Joi.boolean(),
            members: Joi.array().items(Joi.string().custom(objectId)),
        })
        .min(1),
};

const deleteWorkspace = {
    params: Joi.object().keys({
        workspaceId: Joi.string().custom(objectId),
    }),
};

const modifyMember = {
    params: Joi.object().keys({
        workspaceId: Joi.string().custom(objectId),
        userId: Joi.string().custom(objectId),
    }),
};

module.exports = {
    createWorkspace,
    getWorkspaces,
    getWorkspace,
    updateWorkspace,
    deleteWorkspace,
    modifyMember,
};
