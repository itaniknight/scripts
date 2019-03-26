import subprocess
from pprint import pprint

print()

pacman_output = subprocess.run("pacman -Qq".split(), capture_output=True)
packages = pacman_output.stdout.decode().strip().split("\n")

no_opts = []

##  get optional dependencies
for package in packages:

    # gather dependencies
    try:
        deps = [
            {
                "name": x.split(": ")[0],
                "desc": x.split(": ")[1],
                "installed": "",
            }
            for x in subprocess.run(
                rf"expac -Q %O -l \n {package}".split(), capture_output=True
            )
            .stdout.decode()
            .strip()
            .split("\n")
        ]

    # if none exist
    except IndexError:
        no_opts.append(package)
        continue

    # check installed
    for dep in deps:
        installed = (
            subprocess.run(
                rf"expac -Q %w {dep['name']}".split(), capture_output=True
            )
            .stdout.decode()
            .strip()
        )
        if installed:
            dep["installed"] = installed

    # print output
    print(f"\033[1m{package}:\033[0m")
    for dep in deps:
        if dep["installed"] == "dependency":
            print("\033[95m", end="")
        elif dep["installed"] == "explicit":
            print("\033[93m", end="")
        print(f"\t{dep['name']}: {dep['desc']}", end="")
        if dep["installed"]:
            print(f" [{dep['installed']}]", end="")
        print("\033[0m")
    print()

#     for x in opt_deps:
#         print(x["data"[0]])
#         subprocess.run(rf"expac -Q %w {x}".split(), capture_output=False)
#
#     pprint(opt_deps)
#
# for package in packages:
#     result = subprocess.run(
#         rf"expac -Q %n:\n\t%o -l \n\t {package}".split(), capture_output=True
#     )
#     out = result.stdout.decode()
#     print(out)
#     if out.count(":") > 1:
#         print(out)
#     else:
#         no_opts.append(package)
#
# if no_opts:
#     print("The following packages have no optional dependencies:")
#     print(", ".join(no_opts))
#     print()
