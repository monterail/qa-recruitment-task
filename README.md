# Born.hussa.rs

Born.hussa.rs helps organising birthdays and gifts for team mates.

## Requirements
- Ruby 2.2.0
- PostgreSQL
- Redis (for Sidekiq)


## Local setup

This app relies on [authentic](https://github.com/monterail/authentic.hussa.rs) as identity provider.
In development it is set up to use real authentic instance, so you will
have to setup authentic locally - please see [authentic's README](https://github.com/monterail/authentic.hussa.rs)
on how to do this.

```bash
# 1. set ruby's version, e.g. $ rbenv local 2.2.0

# 2. run setup script and follow its instructions
bin/setup

# 3. start the app
foreman start
```

Now you will need to connect with local authentic instance.
First, create a new client app in authentic.
The callback url should be `http://localhost:3000/sso/hussars/callback` (or `http://my-domain.dev/sso/hussars/callback` if you've used pow or prax).

Now the tricky part - no matter what you might think, you **MUST** set the `ID_HUSSARS_HOST` environment variable to you local authentic host (e.g. `http://authentic.dev/`).
Yes, even if you want to use http://authentic.dev you need to set this environment variable. (Why? Simply because it is the only way to configure omniauth-hussars despite what you might think when looking at [sso.rb](config/initializers/sso.rb))


### Domain and other setting

It might be handy to setup [pow](http://pow.cx/) or [prax](http://ysbaddaden.github.io/prax/) for \*.hussa.rs stack.
If you do so, remeber to adjust `HOST` environment variable
(using e.g. rbenv-vars)

Please refer to [Envfile](Envfile) to see all configuration options.
