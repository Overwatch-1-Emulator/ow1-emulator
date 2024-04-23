// release.config.js
module.exports = {
    branches: [
        {name: 'main', prerelease: false},
        {name: 'beta', prerelease: true},
    ],
    plugins: [
        "@semantic-release/commit-analyzer",
        "@semantic-release/release-notes-generator",
        ["@semantic-release/github", {
            "assets": [
                { "path": "build/6v6-adj.txt", "label": "6v6 Adjustments" },
            ]
        }], 
        ["semantic-release-discord-bot", {
            "notifications": [
                { "branch": "*" },
            ]
        }]
    ],
};
