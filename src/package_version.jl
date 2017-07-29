
function package_version(name)
    gitdir = Pkg.dir(name) * "/.git"
    gitcmd = `git --git-dir $gitdir log -1 --format="%H"`
    gitver = chomp(readstring(gitcmd))
    string(Pkg.installed(name)) * " ($gitver)"
end
