JS="
// First make sure the wrapper app is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Fetch our CSS in parallel ahead of time
  const cssPath = 'https://raw.githubusercontent.com/MattSchiller/slackDarkTheme/master/css/slackDarkTheme.css';
  
  let cssPromise = fetch(cssPath).then((response) => response.text());

  let customPalette = `
   :root {
    /* Modify these to change your theme colors: */
    --primary: #00ff10d6;
    --text: #ddd;
    --background: #111;
    --background-elevated: #222;

    /* These should be less important: */
    --background-hover: rgba(255, 255, 255, 0.1);
    --background-light-hover: rgba(100, 100, 100, 0.7);
    --background-light: #aaa;
    --background-bright: #fff;

    --border-dim: #666;
    --border-bright: var(--primary);

    --text-bright: #1dbde8;
    --text-bright-dim: #1dbde8a6;
    --text-special: var(--primary);

    --scrollbar-background: #000;
    --scrollbar-border: var(--border-dim);

    --edited: coral;
    --unread: #d71fc2;
    --secondary: #ffff00d4;
    --tertiary: #8833f9;
    --smiley: var(--background-elevated);
    --caret-color: #e30000;
   `

   let customCSSRules = `
    /* channel side icon */
    .p-channel_sidebar__channel:not(.p-channel_sidebar__channel--im):not(.p-channel_sidebar__channel--mpim):before {
      content: ">";
      font-size: 10pt;
      padding-left: 7px;
    }

    :not(.p-channel_sidebar__channel--muted).p-channel_sidebar__channel--unread:before {
      color: var(--primary);
      font-weight: bold;
    }
   }
   `

  // Insert a style tag into the wrapper view
  cssPromise.then((css) => {
    let s = document.createElement('style');
    s.type = 'text/css';
    s.innerHTML = customPalette + css + customCSSRules;
    document.head.appendChild(s);
  });
});"

SLACK_RESOURCES_DIR="/Applications/Slack.app/Contents/Resources"
SLACK_FILE_PATH="${SLACK_RESOURCES_DIR}/app.asar.unpacked/dist/ssb-interop.bundle.js"

echo "Adding Dark Theme Code to Slack... "
echo "This script requires sudo privileges." && echo "You'll need to provide your password."

sudo npx asar extract ${SLACK_RESOURCES_DIR}/app.asar ${SLACK_RESOURCES_DIR}/app.asar.unpacked
# sudo tee -a "${SLACK_FILE_PATH}" > /dev/null <<< "$JS"
sudo npx asar pack ${SLACK_RESOURCES_DIR}/app.asar.unpacked ${SLACK_RESOURCES_DIR}/app.asar


sudo npx asar extract /Applications/Slack.app/Contents/Resources/app.asar /Applications/Slack.app/Contents/Resources/app.asar.unpacked
# sudo tee -a "${SLACK_FILE_PATH}" > /dev/null <<< "$JS"
sudo npx asar pack /Applications/Slack.app/Contents/Resources/app.asar.unpacked /Applications/Slack.app/Contents/Resources/app.asar