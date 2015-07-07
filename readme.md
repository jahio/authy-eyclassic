# authy-eyclassic

Chef cookbook that integrates [authy](https://authy.com) into SSH for your users

Based on authy-ssh: https://github.com/authy/authy-ssh

## Setup

First, go sign up with authy to get yourself API access for SSH integration.
Docs are here: https://www.authy.com/signup

1. Make sure your environtment at https://cloud.engineyard.com is up and running.
2. REMOVE your ssh public keys from that environment. No idea what happens if you have the key here and the key there both in the authorized_keys file so let's not tempt fate, eh?
3. After modifying environment settings in the cloud dashboard, be sure to click "apply" on the environment overview page so you force the regeneration of configuration cluster-wide.
4. Integrate this recipe with your custom chef, if any. Then use the [engineyard gem](https://github.com/engineyard/engineyard) to upload recipes: ```ey recipes upload -e envname --apply```
5. Once chef is done, you should be able to ssh up as deploy and be asked for an authy token. Get your 2fa device (iPhone for example) and get that token, punch it in. Now you're in.

## Status: Early Development

This has been tested in a very limited capacity and found working in that situation only. It has NOT been exposed to numerous edge cases that are "the world at large", so YMMV if you use this.

## License: MIT

The MIT License (MIT)

Copyright (c) 2015 J. Austin Hughey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
