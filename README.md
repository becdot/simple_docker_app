# Problem
Currently, a docker app running a node server does not handle exits gracefully.  If a `docker stop` command executes when the application is in the middle of processing something, the application will die without waiting to finish.

# Reasoning
Because Docker [does not handle passing signals to children processes when it's run as PID1](https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html), I used a library called [tini](https://github.com/krallin/tini) to better manage signal handling.

I also use techniques from [this article](https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86) to write a bash script to pass signals to the node server.  We start the node server in the bash script instead of calling `npm start` because [npm doesn't pass signals properly](https://github.com/npm/npm/issues/4603).

# Changes
- Use [tini](https://github.com/krallin/tini)
- Update the `start` executable to trap signals and wait for the process to finish before killing it
- Call `node` process directly in `start` executable instead of proxied via `npm start`
- Add signal listeners in the application JS to shut down before exiting
