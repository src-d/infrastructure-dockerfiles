// add timestamps in front of log messages
require('console-stamp')(console, '[HH:MM:ss]');

if (!process.env.GHOST_ENDPOINT) {
    console.error("Misssing GHOST_ENDPOINT environment variable");
    process.exit(1);
}

if (!process.env.GHOST_API_KEY) {
    console.error("Misssing GHOST_API_KEY environment variable");
    process.exit(1);
}

if (!process.env.GCS_BUCKET) {
    console.error("Misssing GCS_BUCKET environment variable");
    process.exit(1);
}

const fs = require('fs');
const https = require('https');
const GhostContentAPI = require('@tryghost/content-api');
const { Storage } = require('@google-cloud/storage');
const storage = new Storage();

const today = new Date();
const dd = String(today.getDate()).padStart(2, '0');
const mm = String(today.getMonth() + 1).padStart(2, '0');
const yyyy = today.getFullYear();

const downloadImage = (src) => new Promise(async (resolve, reject) => {
    const file = await storage.bucket(process.env.GCS_BUCKET).file(`ghost_${yyyy}_${mm}_${dd}` + src).createWriteStream()
    https.get(process.env.GHOST_ENDPOINT + src, function(response) {
        response.pipe(file)
        .on('error', (err) => reject(err))
        .on('finish', () => resolve());
    });
})

const api = new GhostContentAPI({
    url: process.env.GHOST_ENDPOINT,
    version: 'v2',
    key: process.env.GHOST_API_KEY,
});

(async () => {
    console.log("Fetching posts")
    const posts = await api.posts.browse({'limit': 1000});
    await storage.bucket(process.env.GCS_BUCKET).file(`ghost_${yyyy}_${mm}_${dd}.json`).save(JSON.stringify(posts))

    console.log("Fetching images")
    for (let post of posts) {
        await downloadImage(post.feature_image.substr(process.env.GHOST_ENDPOINT.length));
        if (post.mobiledoc) {
            for (let card of JSON.parse(post.mobiledoc).cards) {
                if (card[0] == 'image') {
                    await downloadImage(card[1].src);
                }
            }
        }
    }
    console.log("Backup finished")
})();
