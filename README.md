This repository demonstrates a Parcel issue where **later builds report errors
from a previous build**, even if they've been fixed.

Testing suggests that the issue does not occur in 2.0.0-nightly.1265 (2023-03-25)
but does occur in 2.0.0-nightly.1271 (2023-03-27).

The necessary JavaScript code has been made as minimal as possible:

- `main.js` exports one method, which calls an imported `lodash-es` function
- `other.js` exports one constant
- `index.js` imports from the first two files and re-exports

The provided `bug.sh` script demonstrates the issue by:

1. Removing any `.parcel-cache` or other cache directories
2. Installing any dependencies
3. Performing a 1st `parcel build`, which **succeeds**
4. Breaking a specific import statement to create a specific error
5. Performing a 2nd `parcel build`, which **fails correctly**
6. Fixing that specific import statement
7. Performing a 3rd `parcel build`, which **fails but should succeed**

The failing 3rd `parcel build` complains that `src/other.js` does not
export the function `chunk`, but then indicates a perfectly valid import
statement for `lodash-es`. The code _should_ be compiling without error,
but Parcel is seemingly remembering an earlier error and reporting it for
the later build. The output will look something like:

    Build failed.
    
    @parcel/core: src/other.js does not export 'chunk'
    
      ./ParcelCacheBug/src/main.js:1:10
        > 1 | import { chunk } from 'lodash-es';
        >   |          ^^^^^
          2 |
          3 | export function main() {

Note that this bug is fragile. Touching `package.json` or removing the
`.parcel-cache` directory after the second build will cause the third
build to succeed.

This issue was originally detected in an internal company project, and
the problematic import statement was _between_ company projects. While
we are using `lodash-es` to demonstrate the bug, other libraries can be
used. Some will cause the issue to appear, while some will not.
