const mongoose = require('mongoose');
const { toJSON, paginate } = require('./plugins');

const workspaceSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        maxlength: 100
    },
    description: {
        type: String
    },
    is_public: {
        type: Boolean,
        default: false
    },
    members: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }
    ],
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date,
        default: Date.now
    }
});

workspaceSchema.pre('save', function (next) {
    this.updated_at = Date.now();
    next();
});


workspaceSchema.statics.isNameTaken = async function (name, excludeWorkspaceId) {
    const workspace = await this.findOne({
        name,
        _id: { $ne: excludeWorkspaceId }
    });
    return !!workspace;
};


// add plugin that converts mongoose to json
workspaceSchema.plugin(toJSON);
workspaceSchema.plugin(paginate);

/**
 * @typedef WorkSpace
 */
const WorkSpace = mongoose.model('WorkSpace', workspaceSchema);

module.exports = WorkSpace;
