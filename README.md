Hypriot Blog
==================

[![Circle CI](https://circleci.com/gh/hypriot/blog.svg?style=svg)](https://circleci.com/gh/hypriot/blog)
[![Join the chat at https://gitter.im/hypriot/talk](https://badges.gitter.im/hypriot/talk.svg)](https://gitter.im/hypriot/talk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This repository is used to generate the blog at [blog.hypriot.com](https://blog.hypriot.com).

Improve this blog, because you can!
------------------------
**The blog is completely open source, so everyone is empowered and welcome to create PRs to improve it!** It's as easy as the following steps:

- [Install Hugo](https://gohugo.io/overview/installing/) on your machine, thereby make sure you install exactly the same version as defined [here](https://github.com/hypriot/blog/blob/master/ci-install-hugo.sh#L2).
- Clone this repo
- Change directory into the freshly cloned repo
- Start hugo locally as a server

```bash
hugo server --watch=true -D
```
- Open a browser at URL [http://localhost:1313](http://localhost:1313)
- Make changes and see them immediately updated in the browser. Find our static pages in subfolder `content/` and the blogposts in `content/post/`
- Create a PR and ask the Hypriot Team for review


License
--------
<img src="http://www.creativecommons.ch/wp-content/uploads/2014/03/by-nc1.png" width="88" height="31" />

For this blog we use the [CC-BY-NC 4.0 license](http://creativecommons.org/licenses/by-nc/4.0/).
Any derivatives of this work and any contributions are assumed to be licensed under the same license.

