## DEP-FOO

Dependencies manager for ruby based applications. We use it to keep our gems up
to date in projects hosted on a community gitlab instance.

## Getting started

To be able to use it, you will have to create your access token on:  https://gitlab.example.org/-/profile/personal_access_tokens
There are some configuration that must happen. For that you will need to add
some variables to your scheduled job:

GITLAB_PROJECT_ID: That's your project ID.

For your project, one can find it with:

```
curl -s  'https://gitlab.example.org/api/v4/projects?search=foo/bar&search_namespaces=true' --header "PRIVATE-TOKEN: $TOKEN" | jq .[] | jq ."id"
=> 31337
```


GITLAB_USER_ID: The user that will be open the PR

That is the ID of the user, not the login. One way to find it is:

```
curl -s  'https://gitlab.example.org/api/v4/users?username=superuser' --header "PRIVATE-TOKEN: $TOKEN" | jq .[] | jq ."id"
=> 69
```

You can use different solvers like (minor, patch, major and strict). More
information on https://bundler.io/man/bundle-update.1.html. Just pass it to parameter to `depfoo.rb`, [check this](https://github.com/vpereira/depfoo/blob/master/depfoo.rb#L8) for more information.

If everything goes well, there will be a new merge request on the target
project



### Disclaimer

This is a work of fiction. Names, characters, business, events and incidents are the products of the author's imagination. Any resemblance to actual persons, services, living or dead, or actual events is purely coincidental.
