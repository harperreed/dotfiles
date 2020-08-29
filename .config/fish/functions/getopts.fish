set -g getopts_version 1.0.0

function getopts -d "CLI options parser"
    if not set -q argv[1]
        return 1
    end
    printf "%s\n" $argv | command awk '
        { argv[n++] = $0 }
        END {
            for (i = 0; i < n; i++) {
                a = argv[i]
                if (a == "-" || a !~ /^-/) print "_", a
                else if (a == "--") while (++i < n) print "_", argv[i]
                else if (a ~ /^--/)
                    print (m = index(a, "=")) ? substr(a, 3, m - 3) : substr(a, 3),
                        m ? substr(a, m + 1) : (n == i + 1 || argv[i + 1] ~ /^-/ ? "true" : argv[++i])
                else {
                    v = substr(a, (m = match(substr(a, 3), /$|[!-@[-`{-~]|[[:space:]]/) + 2))
                    for (j = 2; j < m; j++)
                        print substr(a, j, 1),
                            (j + 1 < m ? "true": v == "" ? \
                                n == i + 1 || argv[i + 1] ~ /^-/ ? "true" : argv[++i] : v)
                }
            }
        }
    '
end
