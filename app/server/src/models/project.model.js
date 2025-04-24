const mongoose = require('mongoose');
const { toJSON, paginate } = require('./plugins');

const projectSchema = mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            trim: true,
            maxlength: 100
        },
        description: {
            type: String,
            trim: true
        },
        startDate: {
            type: Date,
            default: Date.now
        },
        endDate: {
            type: Date
        },
        status: {
            type: String,
            enum: ['not_started', 'in_progress', 'on_hold', 'completed', 'cancelled'],
            default: 'not_started'
        },
        managerId: {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'User',
            required: true
        },
        workspaceId: {
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Workspace',
            required: true
        },
        tasks: [{
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'Task'
        }],
        members: [{
            type: mongoose.SchemaTypes.ObjectId,
            ref: 'User'
        }],
    },
    {
        timestamps: true
    }
);

// Kiểm tra xem tên dự án đã tồn tại trong workspace
projectSchema.statics.isNameTakenInWorkspace = async function (name, workspaceId, excludeProjectId) {
    const project = await this.findOne({
        name,
        workspaceId,
        _id: { $ne: excludeProjectId }
    });
    return !!project;
};

// Plugins
projectSchema.plugin(toJSON);
projectSchema.plugin(paginate);

/**
 * @typedef Project
 */
const Project = mongoose.model('Project', projectSchema);

module.exports = Project;
