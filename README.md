Taiga Contrib Subscriptions
===========================

[![Kaleidos Project](http://kaleidos.net/static/img/badge.png)](https://github.com/kaleidos "Kaleidos Project")
[![Managed with Taiga.io](https://img.shields.io/badge/managed%20with-TAIGA.io-709f14.svg)](https://tree.taiga.io/project/taiga/ "Managed with Taiga.io")

Taiga plugin to manage user subscriptions for private projects.


Installation
------------

This plugin affects the gulp compilation process so you need a working taiga-front development environment to use it.

Download in your `app/modules/compile-modules` directory of Taiga front the `taiga-contrib-subscriptios` code:

```bash
  cd taiga-front
  mkdir -p app/modules/compile-modules
  cd app/modules/compile-modules
  git clone git@github.com:taigaio/taiga-contrib-subscriptions.git
```

Configure thu plugin (see _Settings_).

Now when executing "gulp" or "gulp deploy" this plugin will be compiled and included too.


Settings
--------

In `dist/conf.json` you can customize this:


- **_subscriptionsAPI_**
:    by default this plugin will use (`http://localhost:5000/api/v1/` by default).


- **_stripeKey_**
:    the Public Key of an Stripe account.

- **_quadernoKey_**
:    the Public Key of a Quaderno account.


- **_google_adwords_conversion_id_**
:   Google AdWords - conversion id

- **_google_adwords_conversion_label_**
:   Google AdWords - conversion label
:
