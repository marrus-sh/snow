#  CONTRIBUTING  #

##  Branches and Pull Requests  ##

Development for Snow takes place on the `development-x.y.z` branch, where `x.y.z` is the version number of the currently-being-developed version.
Any pull requests should be made to this branch, and not to `master`.
This allows specific versioned releases to be well-documented.

##  Issues  ##

Snow employs a number of issue labels, which are summarized below:

- __bug :__ Snow differs from its specification or what might be reasonably expected
- __depreciation :__ An aspect of Snow should be removed
- __documentation :__ This issue relates to the Snow specification/documentation in addition to or instead of its implementation
- __duplicate :__ This issue has already been reported before
- __enhancement :__ A new feature should be added to Snow
- __low-priority :__ This issue might not be fixed for a while
- __polish :__ This issue improves an existing aspect of how Snow operates without necessarily changing which features are offered
- __question :__ It is unclear whether this issue needs to be acted upon
- __wontfix :__ This issue won't be acted upon

When creating new issues, try to thoroughly describe the problem or, in the case of feature-requests, provide scenarios where the proposed fix would be beneficial.
Providing an extensive technical solution isn't necessary in the case of most issues, but an effort should be made to help readers understand the problem at hand.

##  Contribution Guidelines  ##

Any Pull Request that has good code and isn't out-of-scope will get merged, but following these guidelines will help them get merged faster.

###  Document your code:

If you take a glance through the Snow codebase, you will see that the code is filled with comments describing what various processes and functions do.
Don't submit undocumented code!
Things which appear clear and straightforward to you might not appear as such to others.

###  Be mindful of data mutability:

If a property shouldn't be overwritten, consider defining it with `Object.definePropery()`.
If an object should be considered immutable, maybe use `Object.freeze()`.
Don't directly modify arguments passed in from outside sources, and be careful when evaluating them in case they don't respond like you expect.
(This is less important for internal code, but *very* important for anything which is exposed to users.)

###  Be concise and elegant:

CoffeeScript is a very powerful language for writing code that is elegant and easy-to-read.
Take advantage of this!
Having commented explanations doesn't excuse messy code.
That said, don't be afraid to sacrifice some readability for efficiency or conciseness if what you're doing is well-documented.

###  Format your code correctly:

Snow follows the conventions set forward in the [Laboratory Style Guide](https://github.com/marrus-sh/laboratory-style).
(At time of writing, this style guide hasn't been published yet, so just try to match the style of surrounding code ;P ).
Try to follow this guide as closely as possible (or else we will have to rewrite it to conform).
