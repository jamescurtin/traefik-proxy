#!/usr/bin/env bash

export SHELLCHECK_OPTS="-x -e SC2034 --shell=bash"

shebangregex="^#! */[^ ]*/(env *)?[abkz]*sh"

filepaths=()
excludes=(! -path *./.git/*)
excludes+=(! -path *.go)
excludes+=(! -path */mvnw)
excludes+=(! -path */meta/dotbot/*)

readarray -d '' filepaths < <(find . -type f "${excludes[@]}" \
	'(' \
	-name '*.bash' \
	-o -name '.bashrc' \
	-o -name 'bashrc' \
	-o -name '.bash_aliases' \
	-o -name '.bash_completion' \
	-o -name '.bash_login' \
	-o -name '.bash_logout' \
	-o -name '.bash_profile' \
	-o -name 'bash_profile' \
	-o -name '*.ksh' \
	-o -name 'suid_profile' \
	-o -name '*.zsh' \
	-o -name '.zlogin' \
	-o -name 'zlogin' \
	-o -name '.zlogout' \
	-o -name 'zlogout' \
	-o -name '.zprofile' \
	-o -name 'zprofile' \
	-o -name '.zsenv' \
	-o -name 'zsenv' \
	-o -name '.zshrc' \
	-o -name 'zshrc' \
	-o -name '*.sh' \
	-o -path '*/.profile' \
	-o -path '*/profile' \
	-o -name '*.shlib' \
	')' \
	-print0)

readarray -d '' tmp < <(find . "${excludes[@]}" -type f ! -name '*.*' -print0)
for file in "${tmp[@]}"; do
	head -n1 "$file" | grep -Eqs "$shebangregex" || continue
	filepaths+=("$file")
done

echo "Running shellcheck..."
shellcheck "${filepaths[@]}"

echo "Running shfmt..."
shfmt -l -w -s .

echo "Running yamllint..."
yamllint .
