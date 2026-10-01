# Your slide app with flutter

The app allows read from your assets folder a .json file to run a slide presentation system.

Sample slides json

```json
{
  "design": {
    "logos": [
      "assets/images/logo.png",
      "assets/images/logo2.png"
    ]
  },
  "slides": [
    {
      "id": "1",
      "title": "Welcome",
      "content": "",
      "imageUrl": "assets/images/logo.png"
    },
    {
      "id": "2",
      "title": "What is Slides?",
      "content": "Is a Flutter app to present *slides* that accept ##markdown",
      "imageUrl": "assets/images/logo.png"
    },
    {
      "id": "3",
      "title": "Features",
      "content": "- Light. \n\n - Markdown support \n\n - Allow full screen",
      "imageUrl": "assets/images/logo.png"
    },
  ]
}

```
