dotfiles
========

linux programmer's config files: zsh, tmux, vim, ...

Install
=======
If ubuntu type OS: ubuntu, linux mint, ...  
  ./init_ubuntu.sh  

Update
======
Commit & Update  
  ./update.sh  

Rollback  
  git reset --hard <old-commit-id>  
  git push -f origin branch  

eclipse dark theme
=================

eclipse-moonrise-theme  
from https://github.com/guari/eclipse-ui-theme  

Modify the active view should click two times: 1st focus, 2nd click item.  
If plugin invalid, we can install by update:  
  https://raw.github.com/guari/eclipse-ui-theme/master/com.github.eclipseuitheme.themes.updatesite  
Then replaced by our modified version.

```
Please choose the moonrise, not moonrise(standalone)

$ cd eclipse-moonrise-theme
$ jar cf com.github.eclipseuitheme.themes.moonrise-ui_0.8.9.201404052318.jar *
$ mv com.github.eclipseuitheme.themes.moonrise-ui_0.8.9.201404052318.jar  ~/tools/eclipse/plugins/.
```
