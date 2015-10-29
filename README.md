# hubot-altmetric [![Build Status](https://travis-ci.org/altmetric/hubot-altmetric.svg?branch=master)](https://travis-ci.org/altmetric/hubot-altmetric)

Delivering freshly-baked Altmetric donuts for scholarly identifiers on demand.

See [`src/altmetric.coffee`](src/altmetric.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install altmetric/hubot-altmetric --save`

Then add **hubot-altmetric** to your `external-scripts.json`:

```json
[
  "hubot-altmetric"
]
```

## Usage

```
Hubot> hubot donut me 10.1629/2048-7754.79
Hubot> https://altmetric-badges.a.ssl.fastly.net/?size=100&score=19&types=bttttttw#.png
Hubot> http://www.altmetric.com/details/1619179
```

## License

Copyright © 2015 Altmetric LLP

Distributed under the MIT License.
