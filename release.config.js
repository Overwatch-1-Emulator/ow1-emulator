// release.config.js
module.exports = {
    branches: [
        {name: 'main', prerelease: false},
        {name: 'beta', prerelease: true},
    ],
    plugins: [
        "@semantic-release/commit-analyzer",
        "@semantic-release/release-notes-generator",
        ["@semantic-release/gitlab", {
            "assets": [
                { "path": "build/ow1em.txt", "label": "Overwatch 1 Emulator" },
                { "path": "build/ow1pp.txt", "label": "Overwatch 1++" },
                { "path": "build/1v1-ow1.txt", "label": "1v1 - Overwatch 1 Edition" },
            ]
        }], 
        ["semantic-release-discord-bot", {
            "notifications": [
                { "branch": "*" },
            ]
        }]
    ],
};
