# ABOUTME: Loads environment variables from secrets file
# ABOUTME: Safely parses and exports secrets without exposing them

# Load secrets from ~/.secrets/secrets.env if it exists
if test -f ~/.secrets/secrets.env
    for i in (cat ~/.secrets/secrets.env)
        if test (echo $i | sed -E 's/^[[:space:]]*(.).+$/\\1/g') != "#"
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
        end
    end
end