FixPostReceive
==============

There was a breaking change in latest Windows Azure WebSites that would break git push scenario for sites created over a year ago.

    remote: hooks/post-receive: line 4: D:\Program: No such file or directory
    
The issue was that the `$KUDU_EXE` was relocated to `D:\Program Files (x86)\` folder with space and the old post-receive does not work well with this.   We are addressing this in our next release.  If you need the fix urgently, you can manually fix the post-receive by cloning this repository and run `FixupPostReceive.cmd "<scm-uri>"`.   You can find `scm-uri` from CONFIGURE TAB `deployment trigger uri` of your site.

The script performs a backup of the existing post-receive hook file and replace with the correct one (also part of this repository).  The git repository is assumed to be at `site\repository` folder. 
